// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:unicons/unicons.dart';
import 'theme.dart';
import 'user.dart';

class Account extends StatelessWidget {
  Account({Key? key, required this.user}) : super(key: key);
  Student user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(13.0),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(UniconsLine.user,
                    size: 120.0, color: Theme.of(context).primaryColor)),
            SizedBox(height: 15.0),
            Text(user.name,
                style: TextStyle(fontSize: 32.0, color: Colors.white)),
            Text(user.id,
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 10.0, right: 10.0, bottom: 30.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text('系所')),
                              Text(user.department_name +
                                  " (${user.department_code}) "),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text('入學年份')),
                              Text(user.entry_year + " 年"),
                            ],
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text('版本')),
                              Text("V2.0"),
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("登出",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                elevation: 0.0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
