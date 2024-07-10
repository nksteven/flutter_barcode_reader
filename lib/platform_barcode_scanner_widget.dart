import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: public_member_api_docs
class PlatformBarcodeScannerWidget extends StatelessWidget {
  // ignore: public_member_api_docs
  final ScanParam param;

  // ignore: public_member_api_docs
  PlatformBarcodeScannerWidget({Key? key, required this.param}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: "com.flutter_to_barcode_scanner_view",
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: param.toMap(),
      );
    } else {
      return PlatformViewLink(
        viewType: "barcode_android_view",
        surfaceFactory: (BuildContext context,
            PlatformViewController controller) {
          return PlatformViewSurface(
            controller: controller,
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          );
        },
        onCreatePlatformView:
            (PlatformViewCreationParams params) {
          return PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: "barcode_android_view",
            layoutDirection: TextDirection.ltr,
            creationParams: param.toMap(),
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(
                params.onPlatformViewCreated)
            ..create();
        },
      );
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
  static const int SCAN_BARCODE=1;
  static const int SCAN_QRCODE=2;

  ScanParam(this.height, this.scanType);

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map();
    map["height"]=height.toString();
    map["scanType"]=scanType.toString();
    return map;
  }

}

