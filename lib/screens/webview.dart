import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  WebViewScreen({Key key , @required this.url, @required this.title}) : super(key : key);
  
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<WebViewScreen>{
  bool _isLoadingPage ;

  @override
    void initState(){ 
      super.initState();
      _isLoadingPage = true;
    } 

  @override
  Widget build(BuildContext context) {     
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '${widget.title}',
          style:TextStyle(
            color:Color(0xffffffff),
            fontSize:20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Open Sans',
          )),
        backgroundColor: Color(0xff283643),
      ), 
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[          
          new Container( 
            child: new WebviewScaffold(
            url: '${widget.url}', 
            withZoom: true,
            withLocalStorage: true,
            hidden: true, 
            ),
          ),
          _isLoadingPage ? 
            Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(),
            ) : 
            Container(
              color: Colors.transparent,
            ),
        ],
      ),
    );
  }
}

