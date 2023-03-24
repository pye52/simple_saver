import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_saver/simple_saver.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save image to gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Save image to gallery"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15),
                width: 200,
                height: 44,
                child: ElevatedButton(
                  onPressed: _getHttp,
                  child: const Text("Save network image"),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15),
                width: 200,
                height: 44,
                child: ElevatedButton(
                  onPressed: _saveVideo,
                  child: const Text("Save network video"),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15),
                width: 200,
                height: 44,
                child: ElevatedButton(
                  onPressed: _saveGif,
                  child: const Text("Save Gif to gallery"),
                ),
              ),
            ],
          ),
        ));
  }

  _requestPermission() async {
    bool storageStatuses;
    if (Platform.isAndroid) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;
      storageStatuses =
          sdkInt < 29 ? await Permission.storage.request().isGranted : true;
    } else {
      storageStatuses = await Permission.photosAddOnly.request().isGranted;
    }
    _toastInfo('requestPermission result: $storageStatuses');
  }

  _getHttp() async {
    final dir = await getTemporaryDirectory();
    String savePath =
        "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
    String fileUrl =
        "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
    await Dio().download(
      fileUrl,
      savePath,
      options: Options(
        sendTimeout: 10 * 60 * 1000,
        receiveTimeout: 10 * 60 * 1000,
      ),
      onReceiveProgress: (count, total) {
        debugPrint("${(count / total * 100).toStringAsFixed(0)}%");
      },
    );
    debugPrint(savePath);
    final result = await SimpleSaver.saveFile(path: savePath);
    debugPrint(result.toString());
    _toastInfo("$result");
  }

  _saveGif() async {
    final dir = await getTemporaryDirectory();
    String savePath =
        "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.gif";
    String fileUrl =
        "https://hyjdoc.oss-cn-beijing.aliyuncs.com/hyj-doc-flutter-demo-run.gif";
    await Dio().download(
      fileUrl,
      savePath,
      options: Options(
        sendTimeout: 10 * 60 * 1000,
        receiveTimeout: 10 * 60 * 1000,
      ),
      onReceiveProgress: (count, total) {
        debugPrint("${(count / total * 100).toStringAsFixed(0)}%");
      },
    );
    debugPrint(savePath);
    final result = await SimpleSaver.saveFile(path: savePath);
    debugPrint(result.toString());
    _toastInfo("$result");
  }

  _saveVideo() async {
    final dir = await getTemporaryDirectory();
    String savePath =
        "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4";
    String fileUrl =
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";
    await Dio().download(
      fileUrl,
      savePath,
      options: Options(
        sendTimeout: 10 * 60 * 1000,
        receiveTimeout: 10 * 60 * 1000,
      ),
      onReceiveProgress: (count, total) {
        debugPrint("${(count / total * 100).toStringAsFixed(0)}%");
      },
    );
    final result = await SimpleSaver.saveFile(path: savePath);
    debugPrint(result.toString());
    _toastInfo("$result");
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
