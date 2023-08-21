import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

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

  void sendAttendanceData(String attendanceData) async {
    final url = Uri.parse(
        'http://192.168.254.159/ojt_rms/student/attendance_afternoon_create.php'); // Replace with your API URL
    final response = await http.get(url); // Make a GET request to your API
    if (response.statusCode == 200) {
      print(response.statusCode);
      // Handle the API response here
      print(response.body);
    } else {
      // Handle error
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
              // Send the scanned data to the API
              sendAttendanceData(scanData.code ?? '');
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
