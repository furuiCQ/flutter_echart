package com.markfrain.flutterechart;

import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterEchartPlugin {

  public static void registerWith(Registrar registrar) {
    registrar
            .platformViewRegistry()
            .registerViewFactory(
                    "flutter_echart", new FlutterwebviewFactory(registrar));
  }
}
