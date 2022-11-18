import 'dart:async';
import 'package:propview/config.dart';
import 'package:flutter/material.dart';
import 'package:propview/services/baseService.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:update_app/bean/download_process.dart';
import 'package:update_app/update_app.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    super.initState();
    getInitData();
  }

  bool isLoading = true;
  String getVersion;

  getInitData() async {
    setState(() {
      isLoading = true;
    });
    getVersion = await BaseService.getAppCurrentVersion();
    setState(() {
      isLoading = false;
    });
  }

  Timer timer;

  //下载进度
  double downloadProcess = 0;

  //下载状态
  String downloadStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Updates', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Latest Version: ${getVersion.split("+")[1]}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Current Version: ${Config.APP_VERISON.split("+")[1]}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    downloadStatus != ""
                        ? 'Download status: $downloadStatus'
                        : '',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: Color(0xff314B8C),
                    onPressed: () {
                      if (getVersion != Config.APP_VERISON) {
                        download();
                      } else {
                        showInSnackBar(context, "Already Updated!", 1600);
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void download() async {
    // ignore: missing_required_param
    var downloadId = await UpdateApp.updateApp(
      url: "https://propview.ap-south-1.linodeobjects.com/update.apk",
      title: "Propview Update",
      description: Config.APP_VERISON,
    );

    //本地已有一样的apk, 下载成功
    if (downloadId == 0) {
      setState(() {
        downloadProcess = 1;
        downloadStatus = ProcessState.STATUS_SUCCESSFUL.toString();
      });
      return;
    }

    //出现了错误, 下载失败
    if (downloadId == -1) {
      setState(() {
        downloadProcess = 1;
        downloadStatus = ProcessState.STATUS_FAILED.toString();
      });
      return;
    }

    //正在下载文件
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      var process = await UpdateApp.downloadProcess(downloadId: downloadId);
      //更新界面状态
      setState(() {
        downloadProcess = process.current / process.count;
        downloadStatus = process.status.toString();
      });

      if (process.status == ProcessState.STATUS_SUCCESSFUL ||
          process.status == ProcessState.STATUS_FAILED) {
        //如果已经下载成功, 取消计时
        timer.cancel();
      }
    });
  }
}
