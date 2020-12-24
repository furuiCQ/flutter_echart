#import "FlutterWebView.h"

@implementation FlutterNativeWebFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    FlutterNativeWebController* webviewController =
    [[FlutterNativeWebController alloc] initWithWithFrame:frame
                                           viewIdentifier:viewId
                                                arguments:args
                                          binaryMessenger:_messenger];
    return webviewController;
}

@end

@interface FlutterNativeWebController()<UIWebViewDelegate,FlutterStreamHandler>{
    
}
@end

@implementation FlutterNativeWebController {
    UIWebView* _webView;
    int64_t _viewId;
    FlutterEventSink startEventSink;
    FlutterEventSink finishEventSink;
    NSString *loadData;
    
    FlutterMethodChannel* _channel;
    FlutterEventChannel* _onPageFinishEvenetChannel;
    FlutterEventChannel* onPageStartEvenetChannel;
    
}

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _viewId = viewId;
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.delegate=self;
        _webView.multipleTouchEnabled = YES;
        _webView.userInteractionEnabled = YES;
        _webView.scrollView.scrollEnabled = YES;
        _webView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        NSString* channelName = [NSString stringWithFormat:@"flutter_echart_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
        //    channelName = [NSString stringWithFormat:@"ponnamkarthik/flutterwebview_stream_pagestart_%lld", viewId];
        //
        //    onPageStartEvenetChannel=[FlutterEventChannel eventChannelWithName:channelName binaryMessenger:messenger];
        //    [onPageStartEvenetChannel setStreamHandler:self];
        //
        channelName = [NSString stringWithFormat:@"flutter_echart_stream_pagefinish_%lld", viewId];
        
        _onPageFinishEvenetChannel=[FlutterEventChannel eventChannelWithName:channelName binaryMessenger:messenger];
        [_onPageFinishEvenetChannel setStreamHandler:self];
        
        
        
        
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
    }
    return self;
}

- (UIView*)view {
    return _webView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"loadUrl"]) {
        [self onLoadUrl:call result:result];
    } else if ([[call method] isEqualToString:@"loadData"]) {
        [self onloadData:call result:result];
    } else if ([[call method] isEqualToString:@"evalJs"]) {
        [self evalJs:call result:result];
    }  else{
        result(FlutterMethodNotImplemented);
    }
}
- (void)evalJs:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* data = [call arguments];
    if (![self evalJs:data]) {
        result([FlutterError errorWithCode:@"evalJs_failed"
                                   message:@"Failed parsing the URL"
                                   details:[NSString stringWithFormat:@"URL was: '%@'", data]]);
    } else {
        result(nil);
    }
}
- (void)onloadData:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* url = [call arguments];
    if (![self loadData:url]) {
        result([FlutterError errorWithCode:@"loadData_failed"
                                   message:@"Failed parsing the URL"
                                   details:[NSString stringWithFormat:@"URL was: '%@'", url]]);
    } else {
        result(nil);
    }
}
- (void)onLoadUrl:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* url = [call arguments];
    if (![self loadUrl:url]) {
        result([FlutterError errorWithCode:@"loadUrl_failed"
                                   message:@"Failed parsing the URL"
                                   details:[NSString stringWithFormat:@"URL was: '%@'", url]]);
    } else {
        result(nil);
    }
}
-(bool)evalJs:(NSString *)data{
    if (!data) {
        return false;
    }
    data=[data stringByReplacingOccurrencesOfString:@"\""withString:@"'"];
    if([loadData containsString:@"'options'"]){
        loadData= [loadData stringByReplacingOccurrencesOfString:@"'options'" withString:data];
        [_webView loadHTMLString:loadData baseURL:nil];
        
    }
    
    return true;
}
-(bool)loadData:(NSString *)data{
    if (!data) {
        return false;
    }
    loadData=data;
    [_webView loadHTMLString:data baseURL:nil];
    return true;
}
- (bool)loadUrl:(NSString*)url {
    NSURL* nsUrl = [NSURL URLWithString:url];
    if (!nsUrl) {
        return false;
    }
    NSURLRequest* req = [NSURLRequest requestWithURL:nsUrl];
    [_webView loadRequest:req];
    return true;
}
#pragma mark - <FlutterStreamHandler>
// // 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    //printf("%s", arguments);
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    if (events) {
        finishEventSink=events;
    }
    return nil;
}

/// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    return nil;
}
#pragma mark --WKWebView Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //[_onPageFinishEvenetChannel ]
    if(finishEventSink){
        NSLog(@"finish");
        finishEventSink(@"finish");
        
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(finishEventSink){
        NSLog(@"finish");
        finishEventSink(@"finish");
        
    }
}

@end
