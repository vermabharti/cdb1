import 'package:flutter/material.dart'; 
import 'routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Central Dashboard',
      theme: ThemeData( 
        primarySwatch: Colors.blue,
        // primaryColorDark: Color(0xff283643),
        fontFamily: 'Open Sans'
      ),
      routes: routes,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    );
  }
}
  