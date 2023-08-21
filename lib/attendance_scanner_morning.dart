import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreenMorning extends StatefulWidget {
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

  Future<void> sendAttendance(
      String attendanceLog,
      String studentId,
      String attendanceDate,
      String attendanceTime,
      String coordinatorId,
      String organizationId) async {
    final apiUrl =
        'http://192.168.254.159/ojt_rms/student/attendance_morning_create.php'; // Replace with your API endpoint
    final uri = Uri.https(apiUrl, '', {
      'attendance_log': attendanceLog,
      'student_id': studentId,
      'attendance_date': attendanceDate,
      'attendance_time': attendanceTime,
      'coordinator_id': coordinatorId,
      'organization_id': organizationId,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Handle successful response
      print(response.body);
    } else {
      // Handle error response
      print('Failed to send attendance');
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
              // Send attendance data to the API
              sendAttendance(
                  'Morning', '1', '2023-08-17', '10:00:00', '1', '1');
              // Display the scanned data using a dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Scanned QR Code'),
                    content: Text('Scanned Data: ${scanData.code}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          isScanned = false;
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
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
    home: QRCodeScannerScreenMorning(),
  ));
}
