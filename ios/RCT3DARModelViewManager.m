#import "RCT3DARModelViewManager.h"

@implementation RCT3DARModelViewManager
{
  RCT3DARModelView *modelView;
}

RCT_EXPORT_MODULE()

- (UIView *)view
{
    if (@available(iOS 11.0, *)) {
        if ([ARConfiguration isSupported]) {
            modelView = [[RCT3DARModelView alloc] init];
        }
    }
    return modelView;
}

RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(type, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(scale, float)
RCT_EXPORT_VIEW_PROPERTY(color, UIColor)

RCT_EXPORT_VIEW_PROPERTY(onLoadModelStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelError, RCTBubblingEventBlock)

// MARK: - ARView specifics
RCT_EXPORT_VIEW_PROPERTY(focusSquareColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(focusSquareFillColor, UIColor)

RCT_EXPORT_VIEW_PROPERTY(onStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSurfaceFound, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSurfaceLost, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionInterupted, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionInteruptedEnded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaceObjectSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaceObjectError, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTrackingQualityInfo, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(reload)
{
    if (modelView) {
        [modelView reload];
    }
}

RCT_EXPORT_METHOD(clearDownloadedFiles)
{
    [[RCT3DModelIO sharedInstance] clearDownloadedFiles];
}

RCT_EXPORT_METHOD(checkIfARSupported:(RCTResponseSenderBlock)callback)
{
    BOOL isSupported = NO;
    if (@available(iOS 11.0, *)) {
        isSupported = [ARConfiguration isSupported];
    }
    callback(@[@(isSupported)]);
}

RCT_EXPORT_METHOD(restart)
{
    if (modelView) {
        [modelView restart];
    }
}

RCT_EXPORT_METHOD(getSnapshot:(BOOL)saveToLibrary
                 findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    if (modelView) {
        [modelView takeSnapshot:saveToLibrary completion:^(BOOL success, NSURL *url) {
            if (success) {
                if (saveToLibrary) {
                    resolve(@{@"success":@YES});
                } else {
                    resolve(@{@"success":@YES, @"url": [url path]});
                }
            } else {
                reject(RCTErrorUnspecified, nil, RCTErrorWithMessage(@"RCT3DModelView: Could not save image"));
            }
        }];
    } else {
        reject(RCTErrorUnspecified, nil, RCTErrorWithMessage(@"RCT3DModelView: Could not save image"));
    }
}

@end
