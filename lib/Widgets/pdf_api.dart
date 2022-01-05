import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';


class PdfApi {
  static Future<File> saveDocument({
    @required String name,
    @required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<Directory> getDownloadDirectory()async{
    if(Platform.isAndroid){
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return getApplicationDocumentsDirectory();
  }

  static Future<File> download({
    @required String name,
    @required Document pdf,
  })async{
    final dir=await getDownloadDirectory();
    final permissionStatus=await getRequestPermission();
    if(permissionStatus){
      final bytes = await pdf.save();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);

      // final savePath=path.join(dir.path,fileName);
      // await startDownload(savePath, fileUrl);
      return file;
    }else{
      print("Permission denied");
    }
  }

  //check permission status
  static Future getRequestPermission() async{
    final permission=await Permission.storage;
    if(permission!=PermissionStatus.granted){
      await Permission.storage.request().isGranted;
    }
    return permission==PermissionStatus.granted;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
