import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// ignore: public_member_api_docs
class PlatformBarcodeScannerWidget extends StatelessWidget {
  // ignore: public_member_api_docs
  final ScanParam param;

  // ignore: public_member_api_docs
  PlatformBarcodeScannerWidget({Key key, this.param}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: "com.flutter_to_barcode_scanner_view",
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: param.toMap(),
      );
    } else {
      return AndroidView(
          viewType: "barcode_android_view",
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: param.toMap());
    }
  }
}

class ScanParam{
  double height;
  int scanType;

  ScanParam(this.height, this.scanType);

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map();
    map["height"]=height.toString();
    map["scanType"]=scanType.toString();
    return map;
  }

}

