//
//  FlutterBarcodeScannerViewFactory.m
//  barcode_scan
//
//  Created by ZhouYuan on 2020/6/5.
//

#import "FlutterBarcodeScannerViewFactory.h"
#import "FlutterBarcodeScannerView.h"

@interface FlutterBarcodeScannerViewFactory() <FlutterPlatformViewFactory, FlutterBarcodeScannerViewDelegate>

@property (nonatomic, strong) FlutterBarcodeScannerView* barcodeScannerView;
@property (nonatomic, strong) FlutterMethodChannel* channel;

@end

@implementation FlutterBarcodeScannerViewFactory

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        _channel = [FlutterMethodChannel methodChannelWithName:@"com.flutter_to_barcode_scanner_view_channel" binaryMessenger:registrar.messenger];
        [registrar addMethodCallDelegate:self channel: _channel];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"stopScanning" isEqualToString:call.method]) {
        [_barcodeScannerView stopScanning];
        result(@(true));
    }
}

#pragma mark - FlutterBarcodeScannerViewDelegate
- (void)didScanBarcodeWithResult:(NSString*) result {
    if (_channel) {
        [_channel invokeMethod:@"didScanBarcodeAction" arguments:result];
    }
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    id viewFactory = [[FlutterBarcodeScannerViewFactory alloc]initWithRegistrar:registrar];
    [registrar registerViewFactory:viewFactory withId:@"com.flutter_to_barcode_scanner_view"];
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    _barcodeScannerView = [[FlutterBarcodeScannerView alloc]initWithWithFrame:frame viewIdentifier:viewId arguments:args];
    _barcodeScannerView.delegate = self;
    return _barcodeScannerView;
}

@end
