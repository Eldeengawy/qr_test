import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_test/constants/constants.dart';
import 'package:qr_test/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScannerScreen(),
    );
  }
}

class ScannerScreen extends StatefulWidget {
  ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  PageController _myPage = PageController(initialPage: 0);
  String firstScanData = '';
  String secondScanData = '';
  int count = 0;

  // QRViewController? controller;
  Barcode? barCode;

  @override
  void dispose() {
    MyConstants.controller?.dispose();
    super.dispose();
  }

  @override
  Future<void> reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await MyConstants.controller!.pauseCamera();
    }
    MyConstants.controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // bottomNavigationBar: BottomAppBar(color: Colors.white, child: AppBar()),
        // backgroundColor: Colors.green,
        body: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            // Positioned(bottom: 120.0, child: buildResult())
            Positioned(
              bottom: 120.0,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: firstScanData != ''
                              ? Colors.white
                              : Colors.grey.withOpacity(0.1),
                        ),
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          height: 50,
                          // color: Colors.white,
                          child: Center(child: Text('$firstScanData'))),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: secondScanData != ''
                                ? Colors.white
                                : Colors.grey.withOpacity(0.1)),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          height: 50,
                          child: Center(
                            child: Text(
                              '$secondScanData',
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResult() {
    return barCode?.code != 'Scan a code!'
        ? Text(
            barCode != null ? 'Result : ${barCode!.code}' : 'Scan a code!',
            maxLines: 3,
            style: const TextStyle(
                color: Colors.white,
                backgroundColor: Colors.black,
                fontSize: 20.0),
          )
        : const CircularProgressIndicator();
  }

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderRadius: 10.0,
          borderLength: 20.0,
          borderWidth: 10.0,
          cutOutSize: MediaQuery.of(context).size.width * 0.8),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      MyConstants.controller = controller;
    });
    controller.scannedDataStream.listen((barCode) {
      setState(() {
        // Timer.periodic(Duration(milliseconds: 5000), (timer) {
        if (firstScanData == '') {
          this.barCode = barCode;

          firstScanData = barCode.code.toString();
          print(firstScanData);
        } else if (secondScanData == '' && barCode.code != firstScanData) {
          this.barCode = barCode;
          secondScanData = barCode.code.toString();
          print(secondScanData);
          if (firstScanData != '' && secondScanData != '')
            Future.delayed(Duration(milliseconds: 500), () {
              controller.pauseCamera();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => HomeScreen(
                        firstData: firstScanData,
                        secondData: secondScanData,
                      )),
                ),
              );
            });
          ;
        }
        // else {
        //   // timer.cancel();
        //   controller.pauseCamera();
        //   Future.delayed(Duration(milliseconds: 500), () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: ((context) => HomeScreen(
        //               firstData: firstScanData,
        //               secondData: secondScanData,
        //             )),
        //       ),
        //     );
        //   });
        // }

        // });
        // if (count == 0) {
        //   if (firstScanData == '') {
        //     this.barCode = barCode;
        //     firstScanData = barCode.code.toString();
        //     print(firstScanData);
        //     print(count);
        //     Future.delayed(Duration(milliseconds: 500), () {
        //       count++;
        //     });
        //   }
        // } else if (barCode.code.toString() == firstScanData) {
        // }

        // //   Future.delayed(Duration(milliseconds: 200), () {
        // //     this.barCode = barCode;
        // //     secondScanData = barCode.code.toString();
        // //     count = 0;

        // //     Future.delayed(Duration(milliseconds: 2000), () {
        // //     controller.pauseCamera();
        // //       Navigator.push(
        // //         context,
        // //         MaterialPageRoute(
        // //           builder: ((context) => HomeScreen(
        // //                 firstData: firstScanData,
        // //                 secondData: secondScanData,
        // //               )),
        // //         ),
        // //       );
        // //     });
        // //   });
        // // }
        // else if (count == 1) {
        //   this.barCode = barCode;
        //   secondScanData = barCode.code.toString();
        //   print(secondScanData);
        //   print(count);

        //   // controller.pauseCamera();
        //   count++;

        //   // Navigator.pushReplacement(
        //   //   context,
        //   //   MaterialPageRoute(
        //   //     builder: ((context) => HomeScreen(
        //   //           firstData: firstScanData,
        //   //           secondData: secondScanData,
        //   //         )),
        //   //   ),
        //   // );
        // } else if (barCode.code.toString() == secondScanData) {
        // } else {
        //   controller.pauseCamera();
        //   // count = 0;

        // Future.delayed(Duration(milliseconds: 500), () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: ((context) => HomeScreen(
        //             firstData: firstScanData,
        //             secondData: secondScanData,
        //           )),
        //     ),
        //   );
        // });
        // }
      });
    });
  }
}
