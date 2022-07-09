// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Student {
  String name;
  String id;
  String entry_year;
  String department_name;
  String department_code;
  bool isInitialized = false;
  bool isAdmin = false;
  Student({
    Key? key,
    this.name = "",
    this.id = "",
    this.entry_year = "",
    this.department_name = "",
    this.department_code = "",
    this.isInitialized = false,
  });
}
