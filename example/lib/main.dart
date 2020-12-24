import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_echart/flutter_echart.dart';
import 'package:flutter_echart/echart_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CounterProvider _counterProvider = new CounterProvider();
  CounterProvider _counterProvider2 = new CounterProvider();

  var data1;
  var option = {
    "xAxis": {
      "type": "category",
      "data": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    },
    "yAxis": {"type": "value"},
    "series": [
      {
        "data": [820, 932, 901, 934, 1290, 1330, 1320],
        "type": "line"
      }
    ]
  };
  var option2 = {
    "tooltip": {"trigger": 'item', "formatter": '{a} <br/>{b}: {c} ({d}%)'},
    "legend": {
      "orient": 'vertical',
      "left": 10,
      "data": ['直接访问', '邮件营销', '联盟广告', '视频广告', '搜索引擎']
    },
    "series": [
      {
        "name": '访问来源',
        "type": 'pie',
        "radius": ['50%', '70%'],
        "avoidLabelOverlap": false,
        "label": {"show": false, "position": 'center'},
        "emphasis": {
          "label": {"show": true, "fontSize": '30', "fontWeight": 'bold'}
        },
        "labelLine": {"show": false},
        "data": [
          {"value": 335, "name": '直接访问'},
          {"value": 310, "name": '邮件营销'},
          {"value": 234, "name": '联盟广告'},
          {"value": 135, 'name': '视频广告'},
          {"value": 1548, "name": '搜索引擎'}
        ]
      }
    ]
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _counterProvider.refresh(UniqueKey(), option);
    _counterProvider2.refresh(UniqueKey(), option2);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Native WebView as Widget'),
          ),
          body: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Text('Native WebView as Widget\n\n'),
                ChangeNotifierProvider(
                    builder: (context) => _counterProvider,
                    child: Consumer(builder: (BuildContext context,
                        CounterProvider counterProvider, Widget child) {
                      print('EchartView。。。。。。');
                      return new Container(
                        child: EchartView(
                            key: _counterProvider.keyCount,
                            height: 300,
                            data: counterProvider.value),
                        height: 300.0,
                        width: 500.0,
                      );
                    })),
                Builder(builder: (context) {
                  return RaisedButton(
                    child: Text("更改数据"),
                    onPressed: () {
                      _counterProvider.refresh(UniqueKey(), option2);
                    },
                  );
                }),
                ChangeNotifierProvider(
                    builder: (context) => _counterProvider2,
                    child: Consumer(builder: (BuildContext context,
                        CounterProvider counterProvider, Widget child) {
                      print('EchartView2。。。。。。');
                      return new Container(
                        child: EchartView(
                            key: _counterProvider2.keyCount,
                            height: 300,
                            data: counterProvider.value),
                        height: 300.0,
                        width: 500.0,
                      );
                    })),
                Builder(builder: (context) {
                  return RaisedButton(
                    child: Text("更改数据2"),
                    onPressed: () {
                      _counterProvider2.refresh(UniqueKey(), option);
                    },
                  );
                }),
              ],
            ),
          )),
    );
  }
}
