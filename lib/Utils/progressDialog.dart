import 'package:flutter/material.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';


class PsProgressDialog {
  PsProgressDialog._();

  static FutureProgressDialog  _progressDialog;
  // static ProgressDialog _progressDownloadDialog;

  static Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 1));
      return 'Please Wait...';
    });
  }

  static Future<void> showProgressWithoutMsg(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(getFuture()));
    // showResultDialog(context, result);
  }


  static void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(result),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

}
