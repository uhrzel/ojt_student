import 'package:ojt_student/attendance.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class QRCodeScannerScreenMorning extends StatefulWidget {
  final int userId;
  QRCodeScannerScreenMorning({required this.userId});
  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreenMorning> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isScanned = false;

  @override
  void dispose() {
    controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  void sendAttendanceData(String attendanceData) async {
    String decodedData = Uri.decodeFull(attendanceData);
    Map<String, String> qrDataMap = Uri.splitQueryString(decodedData);

    final url = Uri.parse(
      'http://192.168.254.159/ojt_rms/student/attendance_morning_create.php' +
          '?attendance_log=Morning' +
          '&attendance_date=${qrDataMap['attendance_date']}' +
          '&attendance_time=${qrDataMap['attendance_time']}' +
          '&coordinator_id=${qrDataMap['coordinator_id']}' +
          '&organization_id=${qrDataMap['organization_id']}' +
          '&student_id=${widget.userId}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("data:" + response.body);

      String message = '';
      if (response.body.contains('Attendance Time In Success')) {
        message = 'Attendance Time In Success';
      } else if (response.body.contains('Attendance Time Out Success')) {
        message = 'Attendance Time Out Success';
      } else if (response.body.contains('Attendance Already Checked')) {
        message = 'Attendance Already Checked';
      } else {
        message = 'Attendance Action Failed';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Attendance Response'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  if (message.contains('Success')) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          AttendanceScreen(userId: widget.userId),
                    )); // Navigate to AttendanceScreen
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to send attendance data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
        onQRViewCreated: (controller) {
          this.controller = controller;
          controller.scannedDataStream.listen((scanData) {
            if (!isScanned && scanData != null) {
              isScanned = true;
              String decodedData = Uri.decodeFull(
                  scanData.code ?? ''); // Decoding URL-encoded data
              Map<String, String> qrDataMap = Uri.splitQueryString(decodedData);
              String coordinatorId = qrDataMap['coordinator_id'] ?? '';
              String organizationId = qrDataMap['organization_id'] ?? '';
              String attendanceDate = qrDataMap['attendance_date'] ?? '';
              String attendanceTime = qrDataMap['attendance_time'] ?? '';

              sendAttendanceData(scanData.code ?? '');
              // Display the scanned data using a dialog

            }
          });
          controller.resumeCamera();
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QRCodeScannerScreenMorning(userId: 123),
  ));
}
