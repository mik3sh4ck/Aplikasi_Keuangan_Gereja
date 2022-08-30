// ignore_for_file: todo

import 'dart:io';

import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../themes/colors.dart';
import '../../../widgets/expandablefab.dart';
import '../../../widgets/loadingindicator.dart';
import '../../../widgets/responsivetext.dart';

final List<String> _idKode = List.empty(growable: true);
final List<String> _kategoriTransaksi = List.empty(growable: true);
final List<String> _kodeGereja = List.empty(growable: true);
final List<String> _namaTransaksi = List.empty(growable: true);
String _idKodeTransaksi = "";
String _kodeTransaksi = "";

class AdminControllerTransaksiPage extends StatefulWidget {
  const AdminControllerTransaksiPage({Key? key}) : super(key: key);

  @override
  State<AdminControllerTransaksiPage> createState() =>
      _AdminControllerTransaksiPageState();
}

class _AdminControllerTransaksiPageState
    extends State<AdminControllerTransaksiPage> {
  final _controllerPageKategori = PageController();
  final _controllerPageSubKategori = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPageKategori.dispose();
    _controllerPageSubKategori.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPageKategori,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AdminTransaksiPage(
          controllerPageKategori: _controllerPageKategori,
        ),
        PageView(
          controller: _controllerPageSubKategori,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            BuatKategoriPage(
              controllerPageSubKategori: _controllerPageSubKategori,
              controllerPageKategori: _controllerPageKategori,
            ),
            LihatSubKategori(
              controllerPageSubKategori: _controllerPageSubKategori,
            ),
          ],
        ),
      ],
    );
  }
}

class AdminTransaksiPage extends StatefulWidget {
  final PageController controllerPageKategori;
  const AdminTransaksiPage({Key? key, required this.controllerPageKategori})
      : super(key: key);

  @override
  State<AdminTransaksiPage> createState() => _AdminTransaksiPageState();
}

class _AdminTransaksiPageState extends State<AdminTransaksiPage> {
  ServicesUser servicesUser = ServicesUser();

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
    _getKodeKategori(kodeGereja);

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

  Future _getKodeKategori(kodeGereja) async {
    var response = await servicesUser.getKodeTransaksi(kodeGereja);
    if (response[0] != 404) {
      // kategoriTransaksi.map((e) => ClassKodeTransaksi.fromJSON(e)).toList();
      for (var element in response[1]) {
        _idKode.add(element['id'].toString());
        _kategoriTransaksi.add(element['kode_transaksi']);
        _kodeGereja.add(element['kode_gereja']);
        _namaTransaksi.add(element['nama_transaksi']);
      }
    } else {
      throw "Gagal Mengambil Data";
    }
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
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
              colorScheme: const ColorScheme.light(
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
              colorScheme: const ColorScheme.light(
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

  Future<void> filterKategori() async {}

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
      barrierDismissible: false,
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
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: SizedBox(
                    width: dw * 0.8,
                    child: Column(
                      children: [
                        Container(
                          width: dw * 0.8,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              responsiveText("Tambah $jenisInput", 26,
                                  FontWeight.w700, darkText),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText(
                                      "Uraian", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKeterangan),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Pilih Kategori", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DropdownSearch(
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        suffixIcon: const Icon(Icons
                                            .arrow_drop_down_circle_rounded),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                    items: _kategoriTransaksi,
                                    onChanged: (val) {
                                      kategori = val.toString();
                                    },
                                    selectedItem: "pilih kategori",
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText(
                                      "Tanggal", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: dw,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
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
                                              icon: const Icon(
                                                  Icons.calendar_month),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  responsiveText(
                                      "Nominal", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerNominal),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
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
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
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
                                child: const Text("Tambah"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
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

  _platformCheckAddTransaksi(deviceWidth, deviceHeight) {
    if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  textStyle: GoogleFonts.nunito(
                      color: lightText,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.125),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
          ),
          const SizedBox(
            width: 25,
          ),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  textStyle: GoogleFonts.nunito(
                      color: lightText,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.125),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
            ],
          ),
        ],
      );
    } else {
      return Column();
    }
  }

  _platformCheckFAB(deviceWidth, deviceHeight) {
    if (!kIsWeb && Platform.isAndroid || !kIsWeb && Platform.isIOS) {
      return ExpandableFab(
        distance: 60,
        iconsOpen: const Icon(Icons.add),
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                shape: const CircleBorder(),
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
                padding: const EdgeInsets.all(10),
                shape: const CircleBorder(),
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
      );
    } else {
      return null;
    }
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
          physics: const ClampingScrollPhysics(),
          controller: ScrollController(),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
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
                            const SizedBox(
                              height: 25,
                            ),
                            responsiveText(
                                "Dari Tanggal", 14, FontWeight.w700, darkText),
                            Card(
                              color: primaryColor,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                      icon: const Icon(Icons.calendar_month),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            responsiveText("Sampai Tanggal", 14,
                                FontWeight.w700, darkText),
                            Card(
                              color: primaryColor,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                      icon: const Icon(Icons.calendar_month),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            responsiveText("Filter Kategori", 14,
                                FontWeight.w700, darkText),
                            Card(
                              color: primaryColor,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownSearch(
                                items: _kategoriTransaksi,
                                onChanged: (val) {
                                  kategori = val.toString();
                                },
                                selectedItem: "pilih kategori",
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: buttonColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    textStyle: GoogleFonts.nunito(
                                        color: lightText,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 0.125),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.controllerPageKategori.animateToPage(
                                        1,
                                        duration:
                                            const Duration(milliseconds: 250),
                                        curve: Curves.ease);
                                  },
                                  child: Text(
                                    "Lihat Kategori",
                                    style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: buttonColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 34, vertical: 16),
                                    textStyle: GoogleFonts.nunito(
                                        color: lightText,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 0.125),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  //TODO: search btn
                                  onPressed: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.search),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Cari",
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
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
                                padding: const EdgeInsets.all(16),
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
                            const SizedBox(
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
                                padding: const EdgeInsets.all(16),
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
                            const SizedBox(
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
                                padding: const EdgeInsets.all(16),
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
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _platformCheckAddTransaksi(
                                    deviceWidth, deviceHeight),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        children: [
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
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    responsiveText("Tabel Transaksi", 32,
                                        FontWeight.w900, darkText),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                DataTable(
                                  border: TableBorder.all(
                                    color: navButtonPrimary.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
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
                          ),
                        ],
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
      floatingActionButton: _platformCheckFAB(deviceWidth, deviceHeight),
    );
  }
}

//TODO: buat Kategori
class BuatKategoriPage extends StatefulWidget {
  final PageController controllerPageKategori;
  final PageController controllerPageSubKategori;
  const BuatKategoriPage(
      {Key? key,
      required this.controllerPageKategori,
      required this.controllerPageSubKategori})
      : super(key: key);

  @override
  State<BuatKategoriPage> createState() => _BuatKategoriPageState();
}

class _BuatKategoriPageState extends State<BuatKategoriPage> {
  ServicesUser servicesUser = ServicesUser();
  late Future kategoriTransaksi;

  final _controllerKode = TextEditingController();
  final _controllerKategori = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    kategoriTransaksi = servicesUser.getKodeTransaksi(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerKode.dispose();
    _controllerKategori.dispose();
    super.dispose();
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText, mLength) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLength: mLength,
        controller: controllerText,
        autofocus: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: surfaceColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  _showBuatKategoriDialog(dw, dh) {
    showDialog(
      barrierDismissible: false,
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
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: SizedBox(
                    width: dw * 0.8,
                    child: Column(
                      children: [
                        Container(
                          width: dw * 0.8,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              responsiveText("Tambah Kategori", 26,
                                  FontWeight.w700, darkText),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText(
                                      "Kode", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKode, 6),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Nama Kategori", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKategori, null),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    _controllerKategori.clear();
                                    _controllerKode.clear();
                                    setState(() {});
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    postKodeTransaksi(
                                            kodeGereja,
                                            _controllerKategori.text,
                                            _controllerKode.text,
                                            context)
                                        .then(
                                      (value) {
                                        _controllerKategori.clear();
                                        _controllerKode.clear();
                                        Navigator.pop(context);
                                      },
                                    );
                                  }
                                },
                                child: const Text("Tambah"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
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
    ).then((value) {
      if (mounted) {
        kategoriTransaksi = servicesUser
            .getKodeTransaksi(kodeGereja)
            .whenComplete(() => setState(() {}));
      }
    });
  }

  _showBuatSubKategoriDialog(dw, dh, index) {
    showDialog(
      barrierDismissible: false,
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
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: SizedBox(
                    width: dw * 0.8,
                    child: Column(
                      children: [
                        Container(
                          width: dw * 0.8,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              responsiveText("Tambah Sub Kategori", 26,
                                  FontWeight.w700, darkText),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Id : $_kodeTransaksi", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText(
                                      "Kode", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKode, 3),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Nama Kategori", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKategori, null),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    _idKodeTransaksi = "";
                                    _kodeTransaksi = "";
                                    _controllerKode.clear();
                                    _controllerKategori.clear();
                                    setState(() {});
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    String temp =
                                        "$_kodeTransaksi-${_controllerKode.text}";
                                    postKodeSubTransaksi(
                                        _controllerKategori.text,
                                        temp,
                                        _idKodeTransaksi,
                                        context);

                                    _idKodeTransaksi = "";
                                    _kodeTransaksi = "";
                                    _controllerKode.clear();
                                    _controllerKategori.clear();
                                    setState(() {});
                                  }

                                  Navigator.pop(context);
                                },
                                child: const Text("Tambah"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
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

  Future postKodeTransaksi(
      kodeGereja, namaKategori, kodeKategori, context) async {
    var response = await servicesUser.inputKodeTransaksi(
        kodeGereja, namaKategori, kodeKategori);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  Future postKodeSubTransaksi(
      namaSubKategori, kodeSubKategori, idTransaksi, context) async {
    var response = await servicesUser.inputKodeSubTransaksi(
        idTransaksi, namaSubKategori, kodeSubKategori);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        widget.controllerPageKategori.animateToPage(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      "Kategori",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  height: 56,
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: ScrollController(),
                      child: SizedBox(
                        width: deviceWidth,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showBuatKategoriDialog(
                                        deviceWidth, deviceHeight);
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(Icons.add),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text("Buat Kategori"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: navButtonPrimary.withOpacity(0.4),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: FutureBuilder(
                                  future: kategoriTransaksi,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List snapData = snapshot.data! as List;
                                      if (snapData[0] != 404) {
                                        return ScrollConfiguration(
                                          behavior:
                                              ScrollConfiguration.of(context)
                                                  .copyWith(
                                            dragDevices: {
                                              PointerDeviceKind.touch,
                                              PointerDeviceKind.mouse,
                                            },
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            controller: ScrollController(),
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: snapData[1].length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                color: scaffoldBackgroundColor,
                                                child: ListTile(
                                                  leading: Text(snapData[1]
                                                          [index]
                                                      ['kode_transaksi']),
                                                  title: Row(
                                                    children: [
                                                      const SizedBox(
                                                        height: 25,
                                                        child:
                                                            VerticalDivider(),
                                                      ),
                                                      Text(snapData[1][index]
                                                          ['nama_transaksi']),
                                                      const Spacer(),
                                                      IconButton(
                                                        onPressed: () {
                                                          _idKodeTransaksi =
                                                              snapData[1][index]
                                                                      ['id']
                                                                  .toString();
                                                          _kodeTransaksi =
                                                              snapData[1][index]
                                                                      [
                                                                      'kode_transaksi']
                                                                  .toString();
                                                          setState(() {});
                                                          debugPrint(
                                                            _idKodeTransaksi
                                                                .toString(),
                                                          );
                                                          _showBuatSubKategoriDialog(
                                                              deviceWidth,
                                                              deviceHeight,
                                                              index);
                                                        },
                                                        icon: const Icon(
                                                            Icons.add),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          _idKodeTransaksi =
                                                              snapData[1][index]
                                                                      ['id']
                                                                  .toString();
                                                          setState(() {});
                                                          debugPrint(
                                                            _idKodeTransaksi
                                                                .toString(),
                                                          );
                                                        },
                                                        icon: const Icon(Icons
                                                            .delete_rounded),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          shape:
                                                              const CircleBorder(),
                                                        ),
                                                        onPressed: () {
                                                          _idKodeTransaksi =
                                                              snapData[1][index]
                                                                      ['id']
                                                                  .toString();
                                                          setState(() {});
                                                          debugPrint(
                                                            _idKodeTransaksi,
                                                          );
                                                          widget
                                                              .controllerPageSubKategori
                                                              .animateToPage(1,
                                                                  duration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              250),
                                                                  curve: Curves
                                                                      .ease);
                                                        },
                                                        child: const Icon(Icons
                                                            .arrow_forward_rounded),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    }
                                    return loadingIndicator(
                                        primaryColorVariant);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LihatSubKategori extends StatefulWidget {
  final PageController controllerPageSubKategori;
  const LihatSubKategori({Key? key, required this.controllerPageSubKategori})
      : super(key: key);

  @override
  State<LihatSubKategori> createState() => _LihatSubKategoriState();
}

class _LihatSubKategoriState extends State<LihatSubKategori> {
  ServicesUser servicesUser = ServicesUser();
  late Future subKategoriTransaksi;

  @override
  void initState() {
    // TODO: implement initState
    subKategoriTransaksi = servicesUser.getKodeSubTransaksi(_idKodeTransaksi);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: ScrollController(),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: deviceWidth,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () {
                            widget.controllerPageSubKategori.animateToPage(0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.ease);
                          },
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Text(
                          "Sub Kategori",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      height: 56,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: navButtonPrimary.withOpacity(0.4),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: FutureBuilder(
                          future: subKategoriTransaksi,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List snapData = snapshot.data! as List;
                              if (snapData[0] != 404) {
                                return ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
                                    dragDevices: {
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse,
                                    },
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    controller: ScrollController(),
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: snapData[1].length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: scaffoldBackgroundColor,
                                        child: ListTile(
                                          leading: Text(
                                            snapData[1][index]
                                                    ['kode_sub_transaksi']
                                                .toString(),
                                          ),
                                          title: Row(
                                            children: [
                                              const SizedBox(
                                                height: 25,
                                                child: VerticalDivider(),
                                              ),
                                              Text(
                                                snapData[1][index]
                                                        ['nama_sub_transaksi']
                                                    .toString(),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {
                                                  debugPrint(
                                                    index.toString(),
                                                  );
                                                },
                                                icon: const Icon(
                                                    Icons.delete_rounded),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            }
                            return loadingIndicator(primaryColorVariant);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
