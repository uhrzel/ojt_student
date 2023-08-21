import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreenAfternoon extends StatefulWidget {
  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreenAfternoon> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isScanned = false;

  @override
  void dispose() {
    controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  Future<void> sendAttendanceLog(
    String attendanceLog,
    String studentId,
    String attendanceDate,
    String attendanceTime,
    String coordinatorId,
    String organizationId,
  ) async {
    final apiUrl =
        'http://192.168.254.159/ojt_rms/student/attendance_afternoon_create.php';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'attendance_log': attendanceLog,
          'student_id': studentId,
          'attendance_date': attendanceDate,
          'attendance_time': attendanceTime,
          'coordinator_id': coordinatorId,
          'organization_id': organizationId,
        },
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Attendance Logged'),
              content: Text('Attendance data has been logged.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Display error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to log attendance.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle exception
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
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
          // Inside the onQRViewCreated callback
          controller.scannedDataStream.listen((scanData) {
            if (!isScanned && scanData != null) {
              isScanned = true;

              // Extract data from the scanned QR code (replace with actual values)
              Map<String, String> qrData =
                  Uri.splitQueryString(scanData.code ?? '');

              String scannedAttendanceLog = qrData['attendance_log'] ?? '';
              String scannedStudentId = qrData['student_id'] ?? '';
              String scannedAttendanceDate = qrData['attendance_date'] ?? '';
              String scannedAttendanceTime = qrData['attendance_time'] ?? '';
              String scannedCoordinatorId = qrData['coordinator_id'] ?? '';
              String scannedOrganizationId = qrData['organization_id'] ?? '';

              // Send attendance data to the API
              sendAttendanceLog(
                scannedAttendanceLog,
                scannedStudentId,
                scannedAttendanceDate,
                scannedAttendanceTime,
                scannedCoordinatorId,
                scannedOrganizationId,
              );

              // Display the scanned data using a dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Scanned QR Code'),
                    content: Text('Scanned Data: ${scanData.code ?? ""}'),
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
    home: QRCodeScannerScreenAfternoon(),
  ));
}
