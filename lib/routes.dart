import 'package:flutter/material.dart';
import 'screens/landing.dart';
import 'screens/login.dart';
import 'screens/mainmenu.dart';
import 'screens/submenu.dart';

final routes = {
  '/': (BuildContext context) => Landing(),
  '/login': (BuildContext context) => new LoginScreen(),
  '/home': (BuildContext context) => new MainMenu(),
  '/submenu': (BuildContext context) => new SubMenu(id: '', title: ''),
};
