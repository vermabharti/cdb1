import 'package:centraldashboard/screens/login.dart';
import 'package:centraldashboard/util/basicAuth.dart';
import 'package:centraldashboard/util/url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart'; 
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'submenu.dart';  


class MainMenu extends StatefulWidget { 
  @override
  _MyHomePageState createState() => new _MyHomePageState();}

class _MyHomePageState extends State<MainMenu> {
  String _id; 

// Main Menu Fetch method
  _fetchMainMenu() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _id = (prefs.getString('username') ?? "");        
  final formData = jsonEncode({"primaryKeys" :['$_id']}); 
  Response response = await ioClient.post(MENU_URL, headers: headers, body: formData); 
  if(response.statusCode == 200){
    Map<String, dynamic> list = json.decode(response.body);  
    List<dynamic> userid = list["dataValue"];         
    return userid; 
    }
  else{
      throw Exception('Failed to load Menu');   
    } 
  }  else{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
        return AlertDialog(
        backgroundColor: Color(0xffffffff),
        title: Text("Please Check your Internet Connection", textAlign: TextAlign.center,  style: TextStyle(fontSize:16, color: Color(0xff000000))),
        );});
  } }

  @override
   void initState(){
    super.initState();
    _fetchMainMenu(); 
  }

// Rendering part
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Main Menus',
          style:TextStyle(
            color:Color(0xffffffff),
            fontSize:20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Open Sans',
          )),
        backgroundColor: Color(0xff283643),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async { 
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("username");
              prefs.remove('password');
              prefs.remove('check'); 
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));     
           }, 
          )
        ],
      ), 
      body: new Container(
        color:Color(0xffDCDADA), 
        child: new ListView(
              children: <Widget>[
                // FutureBuilder part to show the list of main menu
                new FutureBuilder<dynamic>(
                  future: _fetchMainMenu(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData){
                      List<dynamic> posts = snapshot.data; 
                      return new Column(
                          children: posts.map((post) => new Column(                            
                            children: <Widget>[
                              new GestureDetector(
                              onTap: (){ 
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SubMenu(id : post[0] , title: post[1])),
                                );
                              },
                            child: new Container(                                                          
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.fromLTRB(12,10, 12, 5),
                              padding: const EdgeInsets.all(20.0), 
                              decoration: new BoxDecoration(borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                              boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Color(0xffBDBCBC).withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 20,
                                    offset: Offset(-1, -2), 
                                  ),
                                ],
                              color:Colors.white),           
                              child: new Row (
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: 
                                new Icon(Icons.dashboard,
                                color: Color(0xff283643),
                                size: 25),
                                ),
                                new Flexible(
                                child: new Text(
                                  post[1],
                                  style: TextStyle(
                                    color:Color(0xff283643),
                                    fontFamily: 'Open Sans',
                                    fontWeight:  FontWeight.w600,
                                    fontSize: 16
                                  )
                                ),),]
                              ),  
                          ),
                          ),                              
                          ],
                          )).toList()
                      );
                    }
                    else if(snapshot.hasError)
                    {
                      return snapshot.error;
                    }
                    return new Center(
                      child: new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(50.0)),
                          new CircularProgressIndicator(),
                        ],
                      ),
                    );
                  },
                ),

              ],
            ), 
      ),
    );     
  }
} 