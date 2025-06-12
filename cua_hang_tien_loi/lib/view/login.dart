//import 'package:cua_hang_tien_loi/view/HomePage.dart';
import 'package:cua_hang_tien_loi/view/SettingPage.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'signup.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import '../api/api_KhachHang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_sdtController.text.isEmpty || _matKhauController.text.isEmpty) {
      _showError('Vui lòng nhập đầy đủ số điện thoại và mật khẩu');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await apiService.login(
        _sdtController.text.trim(),
        _matKhauController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      print('Full response: $response'); 

      if (response['success']) {

        String maKhachHang = response['user']?['maKH']?.toString() ?? '';
        String tenKH = response['user']?['tenKH']?.toString() ?? 'Unknown'; 
        print('TenKH after login: $tenKH');
        

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('maKH', maKhachHang);
        print('maKH saved: ${await prefs.getString('maKH')}');


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Đăng nhập thành công! ID: $maKhachHang, Tên: $tenKH'),
        //     backgroundColor: Colors.green,
        //   ),
        // );

        // // Kiểm tra stack điều hướng và quay về tab trước đó nếu có
        // if (Navigator.of(context).canPop()) {
        //   Navigator.pop(context); // Quay lại trang trước đó
        // } else {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => HomePage()), // Nếu không có trang trước, quay về HomePage
        //   );
        // }



      } else {
        _showError(response['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Đã có lỗi xảy ra: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.blue.shade700,
                    Colors.lightBlue.shade200,
                    Colors.lightBlue.shade100,
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 80),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        FadeInDown(
                          duration: Duration(milliseconds: 800),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            "Chào mừng trở lại",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 5),
                        FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: Text(
                            "Đăng nhập để tiếp tục",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 80),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(Colors.grey.shade200.value),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 10, top: 30, right: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                  ),
                                  child: TextField(
                                    controller: _sdtController,
                                    decoration: InputDecoration(
                                      hintText: "Phone number",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.phone, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                  ),
                                  child: TextField(
                                    controller: _matKhauController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.key, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Remember me", style: TextStyle(color: Colors.grey)),
                              Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          SizedBox(height: 120),
                          FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade700,
                                    Colors.lightBlue.shade200,
                                    Colors.lightBlue.shade100,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: _isLoading ? null : _login,
                                  child: Center(
                                    child: _isLoading
                                        ? CircularProgressIndicator(color: Colors.white)
                                        : Text(
                                            "Login",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: "SIGN UP",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                                    },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 60),
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}