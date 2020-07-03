//
//  FlutterBarcodeScannerView.m
//  barcode_scan
//
//  Created by ZhouYuan on 2020/6/5.
//

#import "FlutterBarcodeScannerView.h"
#import <MTBBarcodeScanner/MTBBarcodeScanner.h>

CGFloat toTop = 8;
CGFloat toLeft = 30;
NSInteger lineImageViewTag = 2011;
CGFloat lineImageViewHeight = 2;

@interface FlutterBarcodeScannerView() {
    UIView* _view;
    CGFloat _viewHeight;
}

@property (strong, nonatomic) MTBBarcodeScanner* scanner;

@end

@implementation FlutterBarcodeScannerView

-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    if ([super init]) {
        _viewHeight = 200;
        if (args != nil && ![args isKindOfClass:[NSNull class]]) {
            _viewHeight = ((NSNumber*)args).floatValue;
        }
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _view = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, _viewHeight)];
        _view.backgroundColor = [UIColor whiteColor];

        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(toLeft, toTop, width - toLeft * 2, lineImageViewHeight)];
        lineImageView.tag = lineImageViewTag;
        lineImageView.image = [UIImage imageNamed:@"scan_line"];
        lineImageView.contentMode = UIViewContentModeScaleAspectFill;
        lineImageView.backgroundColor = [UIColor clearColor];
        [_view addSubview: lineImageView];

        _scanner = [[MTBBarcodeScanner alloc]initWithPreviewView:_view];
        __weak typeof(self) weakSelf = self;
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (success) {
                [strongSelf.scanner startScanningWithResultBlock:^(NSArray<AVMetadataMachineReadableCodeObject *> *codes) {
                    if (strongSelf.delegate) {
                        AVMetadataMachineReadableCodeObject* object = [codes firstObject];
                        NSString * value = @"";
                        if (object != nil) {
                            value = object.stringValue;
                            if (object.type == AVMetadataObjectTypeEAN13Code && [value hasPrefix:@"0"]) {
                                value = [value substringFromIndex:1];
                            }
                        }
                        [strongSelf.delegate didScanBarcodeWithResult:value];
                    }
                } error:nil];
                [strongSelf addAnimation];
            }else {
            [strongSelf.delegate cameraDenied:YES];
            }
        }];
    }
    return self;
}

- (void) addAnimation {
    UIView *lineView = [self.view viewWithTag:lineImageViewTag];
    lineView.hidden = NO;
    CABasicAnimation *animation = [FlutterBarcodeScannerView moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:(_viewHeight-toTop*2-lineImageViewHeight)] rep:OPEN_MAX];
    [lineView.layer addAnimation:animation forKey:@"LineAnimation"];
}

- (void) removeAnimation {
    UIView *lineView = [self.view viewWithTag:lineImageViewTag];
    [lineView.layer removeAnimationForKey:@"LineAnimation"];
    lineView.hidden = YES;
}

- (void) stopScanning {
    [self removeAnimation];
    [self.scanner stopScanning];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep {
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}

- (nonnull UIView *)view {
    return _view;
}

- (void)dealloc {
    if (_scanner && [_scanner isScanning]) {
        [_scanner stopScanning];
    }
    _scanner = nil;
    _view = nil;
}

@end
