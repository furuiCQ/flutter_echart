import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void WebViewCreatedCallback(WebController controller);

class FlutterNativeWeb extends StatefulWidget {

  const FlutterNativeWeb({
    Key key,
    @required this.onWebCreated,
  }) : super(key: key);

  final WebViewCreatedCallback onWebCreated;


  @override
  State createState() => new _FlutterNativeWebState();
}

class _FlutterNativeWebState extends State<FlutterNativeWeb> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {

      return AndroidView(
        viewType: 'flutter_echart',
        onPlatformViewCreated: onPlatformCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'flutter_echart',
        onPlatformViewCreated: onPlatformCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return new Text(
        '$defaultTargetPlatform is not yet supported by this plugin');
  }

  Future<void> onPlatformCreated(id)  async {
    if (widget.onWebCreated == null) {
      return;
    }
    widget.onWebCreated(new WebController.init(id));
  }
}


class WebController {

  WebController.
      init(int id) {
        _channel = new MethodChannel('flutter_echart_$id');
        _pageFinsihed = EventChannel('flutter_echart_stream_pagefinish_$id');
//        _pageStarted = EventChannel('flutter_echart_stream_pagestart_$id');
      }

  MethodChannel _channel;
  EventChannel _pageFinsihed;
  EventChannel _pageStarted;

  Future<void> loadUrl(String url) async {
    assert(url != null);
    return _channel.invokeMethod('loadUrl', url);
  }

  Future<void> loadData(String html) async {
    assert(html != null);
    return _channel.invokeMethod('loadData', html);
  }
  Future<void> evalJs(String code) async {
  assert(code != null);
  return _channel.invokeMethod('evalJs', code);
  }



  Stream<String> get onPageFinished {
    var url = _pageFinsihed
        .receiveBroadcastStream()
        .map<String>(
            (element) => element);
    return url;
  }

  Stream<String> get onPageStarted {
    var url = _pageStarted
        .receiveBroadcastStream()
        .map<String>(
            (element) => element);
    return url;
  }
}
