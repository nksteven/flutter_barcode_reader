/**
 * author:
 * time:2020/6/9
 * descript:
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/platform_barcode_scanner_widget.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'main.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  MethodChannel methodChannel =
      new MethodChannel("plugins.flutter.io/barcode_view");

  String str = "ssa";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BarcodeScanner.scannerViewChannel.setMethodCallHandler((methodChannel) {
      if (methodChannel.method == "onScanCallBack") {
        print("methodChannel.arguments=${methodChannel.arguments}");
        str = methodChannel.arguments;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            key: ValueKey("barcode_android_view"),
            child: PlatformBarcodeScannerWidget(
              param: ScanParam(200,ScanParam.SCAN_BARCODE),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 200),
          ),
          Container(
            margin: EdgeInsets.only(top: 300),
            child: TextField(

            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 400),
            child: InkWell(
              onTap: (){
                BarcodeScanner.resumeCamera();
              },
              child: Text("click to resume"),
            ),
          )
        ],
      ),
    );
  }
}
