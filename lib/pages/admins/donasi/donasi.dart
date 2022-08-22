//ignore_for_file: todo, prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AdminDonasiPage extends StatefulWidget {
  const AdminDonasiPage({Key? key}) : super(key: key);

  @override
  State<AdminDonasiPage> createState() => _AdminDonasiPageState();
}

class _AdminDonasiPageState extends State<AdminDonasiPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          controller: ScrollController(),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}
