#import "FlutterEchartPlugin.h"
#import "FlutterWebView.h"

@implementation FlutterEchartPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterNativeWebFactory* webviewFactory =
      [[FlutterNativeWebFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:webviewFactory withId:@"flutter_echart"];
}

@end
