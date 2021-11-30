import 'dart:async';
import 'dart:io';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:http/http.dart' as http;
import 'package:orderly/Api/api.dart';

import 'package:shared_preferences/shared_preferences.dart';




class TermsOfUse extends StatefulWidget {

  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final String testotp="489871";
  String  termsUrl = Api.TERMS_URL;
  // https://greeto.in/backend/paytm_test



  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String status;

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();


    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          print("onStateChanged: ${state.type} ${state.url}");
        });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() async {
          print("URL changed: $url");
          if (url.contains('callback')) {
            flutterWebviewPlugin.getCookies().then((cookies) {
              print("cookies $cookies");
              print('TXNID ${cookies["TXNID"]}');
              print('STATUS ${cookies["STATUS"]}');
              print('RESPCODE ${cookies["RESPCODE"]}');
              print('RESPMSG ${cookies["RESPMSG"]}');
              print('TXNDATE ${cookies["TXNDATE"]}');
              // add logic to make show payment status
              flutterWebviewPlugin.close();
            });
          }else if(url.contains('success')){
            flutterWebviewPlugin.close();

          }else if(url.contains("error")){

          }
        });
      }
    });
  }

  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "PayTm",
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Ok",
              ),
              onPressed: () {



              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var queryParams;

    return WebviewScaffold(
        url: termsUrl,
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: new Text("Terms Of Use"
              ,style: TextStyle(
                  fontSize: 16.0,
                  color:Colors.white
              )),
        ));
  }
}
