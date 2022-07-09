// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:unicons/unicons.dart';
import 'package:requests/requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:hive/hive.dart';
import 'theme.dart';
import 'user.dart';

class Login extends StatefulWidget {
  Login({Key? key, required this.logindone(Student user)}) : super(key: key);
  Function logindone;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String account = "";
  String password = "";
  bool logging = false;
  void login() async {
    setState(() {
      logging = true;
    });
    var r =
        await Requests.post('https://nuk-app.herokuapp.com/login?token=777app',
            body: {
              'account': account,
              'password': password,
            },
            persistCookies: true,
            bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    if (r.statusCode == 200) {
      dynamic json = r.json();
      print(json.toString());
      if (r.json()["stats"] == "登入成功") {
        var userInfoResponse = await Requests.get(
            'https://nuk-app.herokuapp.com/api/v1/get_user_info',
            persistCookies: true,
            bodyEncoding: RequestBodyEncoding.FormURLEncoded);
        if (userInfoResponse.statusCode == 200) {
          Student user = Student(
            department_code: userInfoResponse.json()['student_department_code'],
            department_name: userInfoResponse.json()['student_department_name'],
            name: userInfoResponse.json()['student_name'],
            id: userInfoResponse.json()['student_id'],
            entry_year: userInfoResponse.json()['student_entrance_year'],
            isInitialized: true,
          );
          widget.logindone(user);
        }

        var snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            color: Theme.of(context).primaryColor.withBlue(190),
            title: '登入成功',
            message: '開始使用吧!',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      } else {
        var snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: '登入失敗',
            message: '帳號密碼錯誤或連線失敗。',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() {
      logging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('登入', style: TextStyle(fontSize: 38, color: Colors.white)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15.0),
                    child: Center(
                        child: Column(
                      children: [
                        SizedBox(height: 20),
                        TextField_(
                            hintText: "學號",
                            value: account,
                            onChange: (value) {
                              setState(() {
                                account = value;
                              });
                            }),
                        SizedBox(height: 20),
                        TextField_(
                            hintText: "密碼",
                            isPassword: true,
                            value: password,
                            onChange: (value) {
                              setState(() {
                                password = value;
                              });
                            }),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                              onPressed: logging ? null : login,
                              borderRadius: BorderRadius.circular(20),
                              disabledColor: Color.fromARGB(255, 151, 133, 231),
                              child: logging
                                  ? LoadingAnimationWidget.fourRotatingDots(
                                      color: Theme.of(context).backgroundColor,
                                      size: 28,
                                    )
                                  : Text("登入",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextField_ extends StatelessWidget {
  String hintText;
  bool isPassword;
  Function onChange;
  String value;
  TextField_(
      {Key? key,
      this.hintText = "",
      this.isPassword = false,
      required this.value,
      required this.onChange(value)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextField(
          onChanged: (value) => onChange(value),
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
