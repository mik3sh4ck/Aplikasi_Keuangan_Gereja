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
import 'package:toggle_switch/toggle_switch.dart';
import '../../../themes/colors.dart';
import '../../../widgets/expandablefab.dart';
import '../../../widgets/loadingindicator.dart';
import '../../../widgets/responsivetext.dart';

final List _kodePerkiraan = List.empty(growable: true);
final List _kodeRefKegiatan = List.empty(growable: true);

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
        BuatKategoriPage(
          controllerPageKategori: _controllerPageKategori,
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

  final _controllerNominal = TextEditingController();
  final _controllerKeterangan = TextEditingController();

  final _controllerDropdownFilter = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String date = "Date";

  DateTime selectedDate1 = DateTime.now();
  String formattedDate1 = "";
  String dateFrom = "Date";

  DateTime selectedDate2 = DateTime.now();
  String formattedDate2 = "";
  String dateTo = "Date";

  DateTime selectedMonth = DateTime.now();
  String formattedMonth = "";
  String month = "Month";

  int dayOfWeek = DateTime.now().weekday - 1;
  DateTime firstDay = DateTime.now();
  DateTime lastDay = DateTime.now();

  String kategori = "";

  final List<DataRow> _rowList = List.empty(growable: true);

  int? _indexFilterTanggal;
  bool _kategoriNotEmpty = false;

  @override
  void initState() {
    // TODO: implement initState
    _getKodePerkiraan(kodeGereja);
    _getTransaksi(kodeGereja);

    formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
    dateFrom = formattedDate1;

    formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
    dateTo = formattedDate2;

    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;

    formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
    month = formattedMonth;

    dayOfWeek = DateTime.now().weekday - 1;
    firstDay = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - dayOfWeek);
    lastDay = firstDay.add(
      const Duration(days: 6, hours: 23, minutes: 59),
    );

    _controllerDropdownFilter.addListener(_changedSearch);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerDropdownFilter.dispose();
    _controllerNominal.dispose();
    _controllerKeterangan.dispose();
    super.dispose();
  }

  Future _getKodePerkiraan(kodeGereja) async {
    var response = await servicesUser.getKodePerkiraan(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodePerkiraan.add(
            "${element['kode_perkiraan']} - ${element['nama_kode_perkiraan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getKodeRefKegiatan() async {}

  Future _getTransaksi(kodeGereja) async {
    var response = await servicesUser.getTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_sub_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
      }
    }
  }

  Future _postTransaksi() async {}

  void _addRowTransaksi(kode, tanggal, deskripsi, jenis, nominal) {
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
                  tanggal.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  deskripsi.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  jenis == "pemasukan" ? nominal.toString() : "-",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  jenis == "pengeluaran" ? nominal.toString() : "-",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
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

  Future<void> selectMonth(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      initialDate: selectedMonth,
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
    if (picked != null && picked != selectedMonth) {
      if (mounted) {
        selectedMonth = picked;
        formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
        month = formattedMonth;
        debugPrint("Selected Month $month");
        setState(() {});
      }
    }
  }

  Future<void> selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
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
        debugPrint("Selected Date From $selectedDate");

        setState(() {});
      }
    }
  }

  Future<void> selectDateFrom(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDay,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
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
        dayOfWeek = picked.weekday - 1;
        firstDay = DateTime(picked.year, picked.month, picked.day - dayOfWeek);
        lastDay = firstDay.add(
          const Duration(days: 6, hours: 23, minutes: 59),
        );
        selectedDate1 = firstDay;
        selectedDate2 = lastDay;
        formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
        formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
        dateFrom = formattedDate1;
        dateTo = formattedDate2;
        debugPrint("$dateFrom, $dateTo");
        setState(() {});
      }
    }
  }

  Future<void> selectDateTo(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
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
        dayOfWeek = picked.weekday - 1;
        firstDay = DateTime(picked.year, picked.month, picked.day - dayOfWeek);
        lastDay = firstDay.add(
          const Duration(days: 6, hours: 23, minutes: 59),
        );
        selectedDate1 = firstDay;
        selectedDate2 = lastDay;
        formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
        formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
        dateFrom = formattedDate1;
        dateTo = formattedDate2;
        debugPrint("$dateFrom, $dateTo");
        setState(() {});
      }
    }
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Column(
                      children: [
                        Container(
                          width: dw < 800 ? dw * 0.8 : dw * 0.4,
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
                              responsiveText("Tambah Transaksi", 26,
                                  FontWeight.w700, darkText),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Kode Referensi Kegiatan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    color: surfaceColor,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: DropdownSearch<dynamic>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            hintText: "Cari Disini",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _controllerDropdownFilter
                                                    .clear();
                                              },
                                              icon: Icon(
                                                Icons.clear,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                          controller: _controllerDropdownFilter,
                                        ),
                                      ),
                                      items: _kodeRefKegiatan,
                                      onChanged: (val) {
                                        debugPrint(val);
                                        debugPrint(_splitString(val));
                                        debugPrint(_buatKodeGabungan(val));
                                      },
                                      selectedItem: "Kode Referensi Kegiatan",
                                    ),
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
                                    child: GestureDetector(
                                      onTap: () {
                                        selectDate(context).then(
                                          (value) => setState(() {}),
                                        );
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(date),
                                              const IconButton(
                                                onPressed: null,
                                                icon:
                                                    Icon(Icons.calendar_month),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Pilih Kategori", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    color: surfaceColor,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: DropdownSearch<dynamic>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            hintText: "Cari Disini",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _controllerDropdownFilter
                                                    .clear();
                                              },
                                              icon: Icon(
                                                Icons.clear,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                          controller: _controllerDropdownFilter,
                                        ),
                                      ),
                                      items: _kodePerkiraan,
                                      onChanged: (val) {},
                                      selectedItem: "Pilih Kategori",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: _kategoriNotEmpty,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        responsiveText("Pilih Sub Kategori", 16,
                                            FontWeight.w700, darkText),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          color: surfaceColor,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: DropdownSearch<dynamic>(
                                            popupProps: PopupProps.menu(
                                              showSearchBox: true,
                                              searchFieldProps: TextFieldProps(
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  hintText: "Cari Disini",
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      _controllerDropdownFilter
                                                          .clear();
                                                    },
                                                    icon: Icon(
                                                      Icons.clear,
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                controller:
                                                    _controllerDropdownFilter,
                                              ),
                                            ),
                                            items: _kodePerkiraan,
                                            onChanged: (val) {
                                              debugPrint(val);
                                              debugPrint(_splitString(val));
                                              debugPrint(
                                                  _buatKodeGabungan(val));
                                            },
                                            selectedItem: "Pilih Sub Kategori",
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  responsiveText(
                                      "Nominal", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: _controllerNominal,
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: surfaceColor,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 25),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Deskripsi", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKeterangan),
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
                                    _controllerKeterangan.clear();
                                    _controllerNominal.clear();
                                    kategori = "";
                                    date = formattedDate;
                                    _kategoriNotEmpty = false;
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
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          _showTambahDialog(deviceWidth, deviceHeight);
        },
        child: Column(
          children: [
            Text(
              "Tambah Transaksi",
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
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

  _filterTanggalField() {
    if (_indexFilterTanggal == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDate(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(date, 14, FontWeight.w700, darkText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_indexFilterTanggal == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Dari Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDateFrom(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(dateFrom, 14, FontWeight.w700, darkText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          responsiveText("Sampai Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDateTo(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(dateTo, 14, FontWeight.w700, darkText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_indexFilterTanggal == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Bulan", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectMonth(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(month, 14, FontWeight.w700, darkText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column();
    }
  }

  _showFilterTanggal() {
    return Visibility(
      visible: _indexFilterTanggal != null ? true : false,
      child: _filterTanggalField(),
    );
  }

  _cardInfo(title, nominal) {
    return Card(
      elevation: 3,
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
            responsiveText(title, 16, FontWeight.w700, darkText),
            Divider(
              color: navButtonPrimary.withOpacity(0.5),
              thickness: 1,
              height: 10,
            ),
            responsiveText(nominal, 16, FontWeight.w700, darkText),
          ],
        ),
      ),
    );
  }

  void _changedSearch() {
    debugPrint(_controllerDropdownFilter.text);
  }

  _splitString(val) {
    var value = val.toString();
    var split = value.indexOf(" ");
    var temp = value.substring(0, split);
    return temp;
  }

  _buatKodeGabungan(val) {
    var temp = kodeGereja + _splitString(val);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                responsiveText("Transaksi", 32, FontWeight.w800, darkText),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        widget.controllerPageKategori.animateToPage(1,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                      child: Text(
                        "Kode Keuangan",
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    _platformCheckAddTransaksi(deviceWidth, deviceHeight),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DataTable(
                              border: TableBorder.all(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.5),
                                style: BorderStyle.solid,
                              ),
                              headingRowHeight: 70,
                              dataRowHeight: 56,
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
                                    "Tanggal",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Deskripsi",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Debit",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Kredit",
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                _rowList.length,
                                (index) {
                                  return DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return index % 2 == 1
                                              ? Colors.white
                                              : primaryColor.withOpacity(0.2);
                                        },
                                      ),
                                      cells: _rowList[index].cells);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            width: 220,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ToggleSwitch(
                                  initialLabelIndex: _indexFilterTanggal,
                                  totalSwitches: 3,
                                  labels: const ['Hari', 'Minggu', 'Bulan'],
                                  activeBgColor: [primaryColorVariant],
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey[200],
                                  inactiveFgColor: Colors.black,
                                  dividerColor: Colors.white,
                                  animate: true,
                                  animationDuration: 250,
                                  onToggle: (index) {
                                    setState(() {
                                      _indexFilterTanggal = index;
                                    });
                                    debugPrint(
                                        'switched to: $_indexFilterTanggal');
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                _showFilterTanggal(),
                                const Divider(
                                  height: 56,
                                ),
                                responsiveText("Filter Kategori", 14,
                                    FontWeight.w700, darkText),
                                Card(
                                  color: primaryColor,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownSearch<dynamic>(
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: "Cari Disini",
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              _controllerDropdownFilter.clear();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        controller: _controllerDropdownFilter,
                                      ),
                                    ),
                                    items: _kodePerkiraan,
                                    onChanged: (val) {
                                      debugPrint(val);
                                      debugPrint(_splitString(val));
                                      debugPrint(_buatKodeGabungan(val));
                                    },
                                    selectedItem: "pilih kategori",
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                _cardInfo("Pemasukan", "15.000.000"),
                                const SizedBox(
                                  height: 25,
                                ),
                                _cardInfo("Pengeluaran", "15.000.000"),
                                const SizedBox(
                                  height: 25,
                                ),
                                _cardInfo("Saldo", "15.000.000"),
                                const SizedBox(
                                  height: 25,
                                ),
                                _cardInfo("Saldo Total", "15.000.000"),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: _platformCheckFAB(deviceWidth, deviceHeight),
    );
  }
}

enum RadioJenisTransaksi { pemasukan, pengeluaran }

//TODO: buat Kategori
class BuatKategoriPage extends StatefulWidget {
  final PageController controllerPageKategori;
  const BuatKategoriPage({Key? key, required this.controllerPageKategori})
      : super(key: key);

  @override
  State<BuatKategoriPage> createState() => _BuatKategoriPageState();
}

class _BuatKategoriPageState extends State<BuatKategoriPage> {
  ServicesUser servicesUser = ServicesUser();
  late Future kodePerkiraan;

  final _controllerKode = TextEditingController();
  final _controllerKategori = TextEditingController();
  String _status = "";
  @override
  void initState() {
    // TODO: implement initState
    kodePerkiraan = servicesUser.getKodePerkiraan(kodeGereja);
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
    RadioJenisTransaksi? radio;
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
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Column(
                      children: [
                        Container(
                          width: dw < 800 ? dw * 0.8 : dw * 0.4,
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
                                      dw, dh, _controllerKode, null),
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Radio(
                                            value:
                                                RadioJenisTransaksi.pemasukan,
                                            groupValue: radio,
                                            activeColor: primaryColorVariant,
                                            onChanged: (val) {
                                              radio =
                                                  val as RadioJenisTransaksi?;
                                              if (mounted) {
                                                setState(() {});
                                                _status = "pemasukan";
                                              }
                                            },
                                          ),
                                          responsiveText("Pemasukan", 14,
                                              FontWeight.w500, darkText),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Radio(
                                            value:
                                                RadioJenisTransaksi.pengeluaran,
                                            groupValue: radio,
                                            activeColor: primaryColorVariant,
                                            onChanged: (val) {
                                              radio =
                                                  val as RadioJenisTransaksi?;
                                              _status = "pengeluaran";

                                              if (mounted) {
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          responsiveText("Pengeluaran", 14,
                                              FontWeight.w500, darkText),
                                        ],
                                      )
                                    ],
                                  ),
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
                                    _status = "";
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
                                            _status,
                                            context)
                                        .then(
                                      (value) {
                                        _controllerKategori.clear();
                                        _controllerKode.clear();
                                        _status = "";
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
        kodePerkiraan = servicesUser
            .getKodePerkiraan(kodeGereja)
            .whenComplete(() => setState(() {}));
      }
    });
  }

  // _showBuatSubKategoriDialog(dw, dh, index) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: ScrollConfiguration(
  //               behavior: ScrollConfiguration.of(context).copyWith(
  //                 dragDevices: {
  //                   PointerDeviceKind.touch,
  //                   PointerDeviceKind.mouse,
  //                 },
  //               ),
  //               child: SingleChildScrollView(
  //                 physics: const ClampingScrollPhysics(),
  //                 controller: ScrollController(),
  //                 child: SizedBox(
  //                   width: dw < 800 ? dw * 0.8 : dw * 0.4,
  //                   child: Column(
  //                     children: [
  //                       Container(
  //                         width: dw < 800 ? dw * 0.8 : dw * 0.4,
  //                         decoration: BoxDecoration(
  //                           color: primaryColor,
  //                           borderRadius: const BorderRadius.only(
  //                             topLeft: Radius.circular(10),
  //                             topRight: Radius.circular(10),
  //                           ),
  //                         ),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             const SizedBox(
  //                               height: 16,
  //                             ),
  //                             responsiveText("Tambah Sub Kategori", 26,
  //                                 FontWeight.w700, darkText),
  //                             const SizedBox(
  //                               height: 16,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         padding: const EdgeInsets.all(16),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 responsiveText("Id : $_kodeTransaksi", 16,
  //                                     FontWeight.w700, darkText),
  //                                 const SizedBox(
  //                                   height: 10,
  //                                 ),
  //                                 responsiveText(
  //                                     "Kode", 16, FontWeight.w700, darkText),
  //                                 const SizedBox(
  //                                   height: 10,
  //                                 ),
  //                                 responsiveTextField(
  //                                     dw, dh, _controllerKode, null),
  //                                 const SizedBox(
  //                                   height: 10,
  //                                 ),
  //                                 responsiveText("Nama Kategori", 16,
  //                                     FontWeight.w700, darkText),
  //                                 const SizedBox(
  //                                   height: 10,
  //                                 ),
  //                                 responsiveTextField(
  //                                     dw, dh, _controllerKategori, null),
  //                               ],
  //                             ),
  //                             const SizedBox(
  //                               height: 25,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(16),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 if (mounted) {
  //                                   _kodeGabunganTransaksi = "";
  //                                   _kodeTransaksi = "";
  //                                   _controllerKode.clear();
  //                                   _controllerKategori.clear();
  //                                   setState(() {});
  //                                 }
  //                                 Navigator.pop(context);
  //                               },
  //                               child: const Text("Batal"),
  //                             ),
  //                             const SizedBox(
  //                               width: 25,
  //                             ),
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 if (mounted) {
  //                                   String temp =
  //                                       "$_kodeTransaksi-${_controllerKode.text}";
  //                                   postKodeSubTransaksi(
  //                                       _controllerKategori.text,
  //                                       temp,
  //                                       _kodeGabunganTransaksi,
  //                                       context);

  //                                   _kodeGabunganTransaksi = "";
  //                                   _kodeTransaksi = "";
  //                                   _controllerKode.clear();
  //                                   _controllerKategori.clear();
  //                                   setState(() {});
  //                                 }

  //                                 Navigator.pop(context);
  //                               },
  //                               child: const Text("Tambah"),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 25,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future postKodeTransaksi(
      kodeGereja, namaKategori, kodeKategori, statusKategori, context) async {
    var response = await servicesUser.inputKodePerkiraan(
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

  // Future postKodeSubTransaksi(
  //     namaSubKategori, kodeSubKategori, idTransaksi, context) async {
  //   var response = await servicesUser.inputKodeSubTransaksi(
  //       idTransaksi, namaSubKategori, kodeSubKategori);

  //   if (response[0] != 404) {
  //     return true;
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(response[1]),
  //       ),
  //     );
  //   }
  // }

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: deviceWidth * 0.4,
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
                                          Text("Buat Kode Transaksi"),
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
                                      future: kodePerkiraan,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List snapData =
                                              snapshot.data! as List;
                                          debugPrint(snapData.toString());
                                          if (snapData[0] != 404) {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              controller: ScrollController(),
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snapData[1].length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  color:
                                                      scaffoldBackgroundColor,
                                                  child: ListTile(
                                                    dense: true,
                                                    minLeadingWidth: 85,
                                                    leading: Text(snapData[1]
                                                            [index]
                                                        ['kode_perkiraan']),
                                                    title: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 25,
                                                          child:
                                                              VerticalDivider(
                                                            color: dividerColor,
                                                          ),
                                                        ),
                                                        Text(snapData[1][index][
                                                            'nama_kode_perkiraan']),
                                                        const Spacer(),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(Icons
                                                              .delete_rounded),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else if (snapData[0] == 404) {
                                            return noData();
                                          }
                                        }
                                        return loadingIndicator();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: deviceWidth * 0.4,
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
                                          Text("Buat Kode Perkiraan"),
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
                                      future: kodePerkiraan,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List snapData =
                                              snapshot.data! as List;
                                          debugPrint(snapData.toString());
                                          if (snapData[0] != 404) {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              controller: ScrollController(),
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snapData[1].length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  color:
                                                      scaffoldBackgroundColor,
                                                  child: ListTile(
                                                    dense: true,
                                                    minLeadingWidth: 85,
                                                    leading: Text(snapData[1]
                                                            [index]
                                                        ['kode_perkiraan']),
                                                    title: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 25,
                                                          child:
                                                              VerticalDivider(
                                                            color: dividerColor,
                                                          ),
                                                        ),
                                                        Text(snapData[1][index][
                                                            'nama_kode_perkiraan']),
                                                        const Spacer(),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(Icons
                                                              .delete_rounded),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else if (snapData[0] == 404) {
                                            return noData();
                                          }
                                        }
                                        return loadingIndicator();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

//TODO: Lihat Sub Kategori
// class LihatSubKategori extends StatefulWidget {
//   final PageController controllerPageSubKategori;
//   const LihatSubKategori({Key? key, required this.controllerPageSubKategori})
//       : super(key: key);

//   @override
//   State<LihatSubKategori> createState() => _LihatSubKategoriState();
// }

// class _LihatSubKategoriState extends State<LihatSubKategori> {
//   ServicesUser servicesUser = ServicesUser();
//   late Future subKategoriTransaksi;

//   @override
//   void initState() {
//     // TODO: implement initState
//     subKategoriTransaksi =
//         servicesUser.getKodeSubTransaksi(_kodeGabunganTransaksi);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;
//     final deviceHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Stack(
//         children: [
//           ScrollConfiguration(
//             behavior: ScrollConfiguration.of(context).copyWith(
//               dragDevices: {
//                 PointerDeviceKind.touch,
//                 PointerDeviceKind.mouse,
//               },
//             ),
//             child: SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               controller: ScrollController(),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 width: deviceWidth,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_back_ios_new_rounded),
//                           onPressed: () {
//                             widget.controllerPageSubKategori.animateToPage(0,
//                                 duration: const Duration(milliseconds: 250),
//                                 curve: Curves.ease);
//                           },
//                         ),
//                         const SizedBox(
//                           width: 25,
//                         ),
//                         Text(
//                           "Sub Kategori",
//                           style: Theme.of(context).textTheme.headline5,
//                         ),
//                       ],
//                     ),
//                     const Divider(
//                       thickness: 1,
//                       height: 56,
//                     ),
//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(
//                           color: navButtonPrimary.withOpacity(0.4),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: FutureBuilder(
//                           future: subKategoriTransaksi,
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               List snapData = snapshot.data! as List;
//                               if (snapData[0] != 404) {
//                                 return ScrollConfiguration(
//                                   behavior:
//                                       ScrollConfiguration.of(context).copyWith(
//                                     dragDevices: {
//                                       PointerDeviceKind.touch,
//                                       PointerDeviceKind.mouse,
//                                     },
//                                   ),
//                                   child: ListView.builder(
//                                     shrinkWrap: true,
//                                     scrollDirection: Axis.vertical,
//                                     controller: ScrollController(),
//                                     physics: const ClampingScrollPhysics(),
//                                     itemCount: snapData[1].length,
//                                     itemBuilder: (context, index) {
//                                       return Card(
//                                         color: scaffoldBackgroundColor,
//                                         child: ListTile(
//                                           leading: Text(
//                                             snapData[1][index]
//                                                     ['kode_sub_transaksi']
//                                                 .toString(),
//                                           ),
//                                           title: Row(
//                                             children: [
//                                               const SizedBox(
//                                                 height: 25,
//                                                 child: VerticalDivider(),
//                                               ),
//                                               Text(
//                                                 snapData[1][index]
//                                                         ['nama_sub_transaksi']
//                                                     .toString(),
//                                               ),
//                                               const Spacer(),
//                                               IconButton(
//                                                 onPressed: () {
//                                                   debugPrint(
//                                                     index.toString(),
//                                                   );
//                                                 },
//                                                 icon: const Icon(
//                                                     Icons.delete_rounded),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 );
//                               } else if (snapData[0] == 404) {
//                                 return noData();
//                               }
//                             }
//                             return loadingIndicator();
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
