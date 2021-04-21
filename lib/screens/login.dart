import 'dart:convert';
import 'package:centraldashboard/util/basicAuth.dart';
import 'package:centraldashboard/util/url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'mainmenu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<LoginScreen> {
  TextStyle style = TextStyle(fontFamily: 'Open Sans', fontSize: 15.0);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _passwordVisible = true;
  bool checkValue = false;

  //Login Method
  _loginuser() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      String user = username.text;
      String pass = password.text;
      final formData = jsonEncode({
        "primaryKeys": ["$user", "$pass"]
      });
      Response response =
          await ioClient.post(LOGIN_URL, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> userid = list["dataValue"];
        if (userid[0][0] != '0') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("username", userid[0][0]);
          return Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainMenu()),
          );
        } else {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xffecbabf),
                  title: Text("Please Enter Valid Username and Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xff50040b))),
                );
              });
        }
      } else {
        throw Exception('Failed to load data');
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
    super.initState();
    getCredential();
  }

// Store Username/password in App State
  _onChanged(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      prefs.setBool("check", checkValue);
      prefs.setString("username", username.text);
      prefs.setString("password", password.text);
      getCredential();
    });
  }

// Get Credential
  getCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkValue = prefs.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          username.text = prefs.getString("username");
          password.text = prefs.getString("password");
        } else {
          username.clear();
          password.clear();
          prefs.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
      obscureText: false,
      // initialValue: checkValue == true ? rememberUsername.toString() : null,
      style: style,
      controller: username,
      validator: (value) {
        if (value.isEmpty) {
          return 'Username is Mandatory';
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextFormField(
      obscureText: _passwordVisible,
      style: style,
      controller: password,
      validator: (value) {
        if (value.isEmpty) {
          return 'Password is Mandatory';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
    final rememberMe = new CheckboxListTile(
      value: checkValue,
      onChanged: _onChanged,
      title: new Text("Remember me"),
      controlAffinity: ListTileControlAffinity.leading,
    );
    final loginButon = Builder(
      builder: (context) => Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff283643),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _loginuser();
              }
            },
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Open Sans')),
          )),
    );

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: Builder(
          builder: (context) => new Container(
            decoration: BoxDecoration(
              color: const Color(0xff000000b3),
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: new SingleChildScrollView(
                child: new Container(
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            child: Text('WELCOME \n TO \n CENTRAL DASHBOARD',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff283643))),
                          ),
                          SizedBox(height: 45.0),
                          usernameField,
                          SizedBox(height: 25.0),
                          passwordField,
                          rememberMe,
                          SizedBox(height: 35.0),
                          loginButon
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
