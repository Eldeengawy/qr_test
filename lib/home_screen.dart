import 'package:flutter/material.dart';
import 'package:qr_test/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {super.key, required this.firstData, required this.secondData});
  final firstData;
  final secondData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '{first_data:$firstData,secnd_data : $secondData}',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScannerScreen(),
                    ),
                  );
                },
                child: Text('Rescan')),
          ),
        ),
      ],
    ));
  }
}
