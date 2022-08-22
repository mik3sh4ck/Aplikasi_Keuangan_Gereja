// ignore_for_file: prefer_const_constructors, todo

import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../themes/colors.dart';
import '../../../widget.dart/expandablefab.dart';
import '../../../widget.dart/responsivetext.dart';

class AdminTransaksiPage extends StatefulWidget {
  const AdminTransaksiPage({Key? key}) : super(key: key);

  @override
  State<AdminTransaksiPage> createState() => _AdminTransaksiPageState();
}

class _AdminTransaksiPageState extends State<AdminTransaksiPage> {
  var stateOfDisable = true;
  DateTime selectedDate1 = DateTime.now();
  String formattedDate1 = "";
  String dateFrom = "Date";
  DateTime selectedDate2 = DateTime.now();
  String formattedDate2 = "";
  String dateTo = "Date";

  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String date = "Date";
  String jenisInput = "";
  final _controllerNominal = TextEditingController();
  final _controllerKeterangan = TextEditingController();
  String kategori = "";

  final List<DataRow> _rowList = List.empty(growable: true);

  List<String> dataDropdown = [
    "Kolekte",
    "Sumbangan",
    "Kas",
    "Sponsor",
    "Lainnya",
  ];

  @override
  void initState() {
    // TODO: implement initState
    formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
    dateFrom = formattedDate1;
    formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
    dateTo = formattedDate2;

    _generateRow();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controllerText,
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: surfaceColor,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.amber, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: primaryColorVariant, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate) {
      if (mounted) {
        selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        date = formattedDate;
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDate");

        setState(() {});
      }
    }
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
              colorScheme: ColorScheme.light(
                primary: Colors.amber, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: primaryColorVariant, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate1) {
      if (mounted) {
        selectedDate1 = picked;
        formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
        dateFrom = formattedDate1;
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
        dateTo = formattedDate2;
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDate2");
        setState(() {});
      }
    }
  }

  Future<void> filterKategori() async {
    
  }

  Future<void> _generateRow() async {
    for (int i = 0; i < 15; i++) {
      _addRow(
          "DN001-01", "aaaaaaaaaaaaaaaaaaa", "11-07-2022", 10000, "Pemasukan");
    }
  }

  void _addRow(kode, uraian, tanggal, nominal, jenis) {
    setState(
      () {
        _rowList.add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  kode.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  uraian.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  tanggal.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  "Rp. $nominal, -",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  jenis.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showTambahDialog(dw, dh) {
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: SizedBox(
                    width: dw * 0.8,
                    child: Column(
                      children: [
                        Container(
                          width: dw * 0.8,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              responsiveText("Tambah $jenisInput", 26,
                                  FontWeight.w900, darkText),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText(
                                      "Uraian", 16, FontWeight.w700, darkText),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKeterangan),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Pilih Kategori", 16,
                                      FontWeight.w700, darkText),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DropdownSearch(
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        suffixIcon: Icon(Icons
                                            .arrow_drop_down_circle_rounded),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 25),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: surfaceColor,
                                      ),
                                    ),
                                    items: dataDropdown,
                                    onChanged: (val) {
                                      kategori = val.toString();
                                    },
                                    selectedItem: "pilih kategori",
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText(
                                      "Tanggal", 16, FontWeight.w700, darkText),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: dw,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(date),
                                            IconButton(
                                              onPressed: () {
                                                selectDate(context).then(
                                                  (value) => setState(() {}),
                                                );
                                              },
                                              icon: Icon(Icons.calendar_month),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  responsiveText(
                                      "Nominal", 16, FontWeight.w700, darkText),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerNominal),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    kategori = "";
                                    _controllerKeterangan.clear();
                                    _controllerNominal.clear();
                                    date = "Date";
                                    jenisInput = "";
                                    setState(() {});
                                  }
                                  Navigator.pop(context);
                                },
                                child: Text("Batal"),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    _addRow(
                                        kategori,
                                        _controllerKeterangan.text,
                                        date,
                                        _controllerNominal.text,
                                        jenisInput);
                                    kategori = "";
                                    _controllerKeterangan.clear();
                                    _controllerNominal.clear();
                                    date = "Date";
                                    jenisInput = "";
                                    setState(() {});
                                  }

                                  Navigator.pop(context);
                                },
                                child: Text("Tambah"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
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
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  controller: ScrollController(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 220,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            responsiveText(
                                "Transaksi", 32, FontWeight.w800, darkText),
                            SizedBox(
                              height: 25,
                            ),
                            responsiveText(
                                "Dari Tanggal", 14, FontWeight.w700, darkText),
                            Card(
                              color: primaryColor,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    responsiveText(dateFrom, 14,
                                        FontWeight.w700, darkText),
                                    IconButton(
                                      onPressed: () {
                                        selectDateFrom(context);
                                      },
                                      icon: Icon(Icons.calendar_month),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            responsiveText("Sampai Tanggal", 14,
                                FontWeight.w700, darkText),
                            Card(
                              color: primaryColor,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    responsiveText(
                                        dateTo, 14, FontWeight.w700, darkText),
                                    IconButton(
                                      onPressed: () {
                                        selectDateTo(context);
                                      },
                                      icon: Icon(Icons.calendar_month),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text("Lihat Transaksi"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Card(
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: navButtonPrimary.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText(
                                        "Saldo", 16, FontWeight.w700, darkText),
                                    Divider(
                                      color: navButtonPrimary.withOpacity(0.5),
                                      thickness: 1,
                                      height: 10,
                                    ),
                                    responsiveText("Rp. 15.000.000", 16,
                                        FontWeight.w700, darkText),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Card(
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: navButtonPrimary.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText("Pemasukan", 16,
                                        FontWeight.w700, darkText),
                                    Divider(
                                      color: navButtonPrimary.withOpacity(0.5),
                                      thickness: 1,
                                      height: 10,
                                    ),
                                    responsiveText("Rp. 15.000.000", 16,
                                        FontWeight.w700, darkText),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Card(
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: navButtonPrimary.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    responsiveText("Pengeluaran", 16,
                                        FontWeight.w700, darkText),
                                    Divider(
                                      color: navButtonPrimary.withOpacity(0.5),
                                      thickness: 1,
                                      height: 10,
                                    ),
                                    responsiveText("Rp. 15.000.000", 16,
                                        FontWeight.w700, darkText),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Platform.isWindows ||
                                    Platform.isLinux ||
                                    Platform.isMacOS ||
                                    kIsWeb
                                ? Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          jenisInput = "Pemasukan";
                                          _showTambahDialog(
                                              deviceWidth, deviceHeight);
                                        },
                                        child: Text("+ Pemasukan"),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          jenisInput = "Pengeluaran";
                                          _showTambahDialog(
                                              deviceWidth, deviceHeight);
                                        },
                                        child: Text("+ Pengeluaran"),
                                      ),
                                    ],
                                  )
                                : Column(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Card(
                        color: scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: navButtonPrimary.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                responsiveText("Tabel Transaksi", 32,
                                    FontWeight.w900, darkText),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            DataTable(
                              border: TableBorder.all(
                                color: navButtonPrimary.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              columnSpacing: 60,
                              columns: [
                                DataColumn(
                                  label: Text(
                                    "Kode",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Uraian",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Tanggal",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Nominal",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Jenis",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                              rows: _rowList,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Platform.isAndroid || Platform.isIOS
          ? ExpandableFab(
              distance: 60,
              iconsOpen: Icon(Icons.add),
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: CircleBorder(),
                      primary: primaryColor),
                  onPressed: () {
                    jenisInput = "Pengeluaran";
                    _showTambahDialog(deviceWidth, deviceHeight);
                  },
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Image.asset("lib/assets/images/outcomeicons.png"),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: CircleBorder(),
                      primary: primaryColor),
                  onPressed: () {
                    jenisInput = "Pemasukan";
                    _showTambahDialog(deviceWidth, deviceHeight);
                  },
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Image.asset("lib/assets/images/incomeicons.png"),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
