import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// ignore: public_member_api_docs
class PlatformBarcodeScannerWidget extends StatelessWidget {
  // ignore: public_member_api_docs
  final double height;

  // ignore: public_member_api_docs
  PlatformBarcodeScannerWidget({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: "com.flutter_to_barcode_scanner_view",
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: height,
      );
    } else {
      return AndroidView(
          viewType: "barcode_android_view",
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: height);
    }
  }
}
