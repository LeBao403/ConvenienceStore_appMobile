import 'dart:io';
import 'package:cua_hang_tien_loi/view/signup.dart';
import 'package:flutter/material.dart';
import 'view/login.dart';
import 'view/SettingPage.dart';
import 'view/HomePage.dart';
import 'view/ProfileDetail.dart';
import 'view/cart.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Thêm để bỏ qua kiểm tra SSL
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng của bạn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home', 
      routes: {
        '/setting': (context) => SettingsPage(), 
        '/login': (context) => LoginPage(), 
        '/signup': (context) => SignUpPage(), 
        '/home': (context) => HomePage(), 
        '/profile_detail': (context) => ProfileDetail(customerId: 1), 
        '/cart': (context) => Cart(), 
      },
    );
  }
}
