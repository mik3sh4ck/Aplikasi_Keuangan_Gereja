// ignore_for_file: prefer_const_constructors, todo

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../themes/colors.dart';

class TransaksiPages extends StatefulWidget {
  const TransaksiPages({Key? key}) : super(key: key);

  @override
  State<TransaksiPages> createState() => _TransaksiPagesState();
}

class _TransaksiPagesState extends State<TransaksiPages> {
  var stateOfDisable = true;
  DateTime selectedDate1 = DateTime.now();
  String formattedDate1 = "";
  DateTime selectedDate2 = DateTime.now();
  String formattedDate2 = "";
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

  responsiveText(text, double size, FontWeight fontweight, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: AutoSizeText(
        text,
        style: TextStyle(fontSize: size, fontWeight: fontweight, color: color),
        minFontSize: 12,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<void> selectDateFrom(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate1,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: primaryColor, secondary: primaryColorVariant),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate1) {
      if (mounted) {
        selectedDate1 = picked;
        formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDate1");
        setState(() {});
      }
    }
  }

  Future<void> selectDateTo(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: primaryColor, secondary: primaryColorVariant),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate2) {
      if (mounted) {
        selectedDate2 = picked;
        formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDate2");
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
