
import 'package:centraldashboard/util/basicAuth.dart';
import 'package:centraldashboard/util/url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:ui';

import 'leafmenu.dart';



class SubMenu extends StatefulWidget {
  final String id;
  final String title;
  SubMenu({Key key, @required this.id, @required this.title}) : super(key: key);

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<SubMenu> {
  _fetchSubMenu() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final formData = jsonEncode({
        "primaryKeys": ["${widget.id}"]
      });
      Response response =
          await ioClient.post(SUB_MENU_URL, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> listid = list["dataValue"];
        print('$listid');
        return listid;
      } else {
        throw Exception('Failed to load Menu');
      }
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xffffffff),
              title: Text("Please Check your Internet Connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff000000))),
            );
          });
    }
  }

  @override
  void initState() {
    this._fetchSubMenu();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${widget.title}",
            style: TextStyle(
              color: Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Open Sans',
            )),
        backgroundColor: Color(0xff283643),
      ),
      body: new Container(
        color: Color(0xffDCDADA),
        child: new ListView(
          children: <Widget>[
            // Get Leaf Menu part
            new FutureBuilder<dynamic>(
              future: _fetchSubMenu(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return new Center(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(padding: new EdgeInsets.all(50.0)),
                        new CircularProgressIndicator(),
                      ],
                    ),
                  );
                } else if (snapshot.data.length == 0) {
                  return new Center(
                      child: Text('No Data Found',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20)));
                } else {
                  List<dynamic> posts = snapshot.data;
                  return new Column(
                      children: posts
                          .map((post) => new Column(
                                children: <Widget>[
                                  new GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LeafSubMenu(
                                                mid: post[0],
                                                id: post[1],
                                                title: post[2])),
                                      );
                                    },
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.fromLTRB(
                                          12, 10, 12, 5),
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(10.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Color(0xffBDBCBC)
                                                  .withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 20,
                                              offset: Offset(-1, -2),
                                            ),
                                          ],
                                          color: Colors.white),
                                      child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                              child: new Icon(Icons.dashboard,
                                                  color: Color(0xff283643),
                                                  size: 25),
                                            ),
                                            new Flexible(
                                              child: new Text(post[2],
                                                  style: TextStyle(
                                                      color: Color(0xff283643),
                                                      fontFamily: 'Open Sans',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14)),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ))
                          .toList());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
