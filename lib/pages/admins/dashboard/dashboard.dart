// ignore_for_file: prefer_const_constructors, todo

import 'package:aplikasi_keuangan_gereja/themes/themes.dart';
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: primaryMargin,
        child: Card(
          child: Text("Hello"),
        ),
      ),
    );
  }
}
