# flutter_echart

A new Flutter plugin.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## About Echart
Apache ecarts (increasing) TM is a project in the incubation of Apache Software Foundation (ASF).

Apache ECharts (incubating)TM 是一个正在 Apache Software Foundation (ASF) 孵化中的项目。

Echart: https://echarts.apache.org/examples/zh/index.html

Echart本身用于web端显示各种类型的图表。

## 1.如何引用

在项目的pubspec.yaml文件中
声明如下
flutter_echart:
      git:
        url: git://github.com/furuiCQ/flutter_echart.git
        
## 2.复制example项目中的asset目录到自己的项目根目录中。

并在pubspec.yaml文件中
声明如下：
assets:
    - assets/echart.html
    
## 3.基本使用在example项目的main.dart已经写明。如有问题提Inssues
O(∩_∩)O

## 4.PS:当前echart版本4.0.1

## 5.运行效果如图：

![Image text](https://img-blog.csdnimg.cn/20201225140124303.gif)

## --2020年12月24日----

没想到时隔有两年多，获得了34个star，非常感谢star的朋友。
这里先道个歉，2年里面有很多变故，项目也就没有维护了，为了感谢曾经的这个34个star和18个fork，
近期将会花时间重新把这个项目维护起来，感谢大家。ღ( ´･ᴗ･` )比心

### 新增刷新功能。代码如下

```java
    //创建一个Provider
    CounterProvider _counterProvider = new CounterProvider();
  //在EchartView外面套一个ChangeNotifierProvider
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
   //刷新数据功能
   Builder(builder: (context) {
                     return RaisedButton(
                       child: Text("更改数据2"),
                       onPressed: () {
                         _counterProvider2.refresh(UniqueKey(), option);
                       },
                     );
                   }),
```
