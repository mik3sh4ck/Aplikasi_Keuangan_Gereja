//ignore_for_file: todo, prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AdminAnggotaPage extends StatefulWidget {
  const AdminAnggotaPage({Key? key}) : super(key: key);

  @override
  State<AdminAnggotaPage> createState() => _AdminAnggotaPageState();
}

class _AdminAnggotaPageState extends State<AdminAnggotaPage> {
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
