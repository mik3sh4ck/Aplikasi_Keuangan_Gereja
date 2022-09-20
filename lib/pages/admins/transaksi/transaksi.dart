// ignore_for_file: todo

import 'package:aplikasi_keuangan_gereja/globals.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';
import 'package:aplikasi_keuangan_gereja/widgets/string_extension.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../themes/colors.dart';
import '../../../widgets/loadingindicator.dart';
import '../../../widgets/responsivetext.dart';

final List _kodePerkiraan = List.empty(growable: true);
final List _kodeTransaksi = List.empty(growable: true);
final List _kodeRefKegiatan = List.empty(growable: true);
final List<DataRow> _rowList = List.empty(growable: true);

int _totalPemasukan = 0;
int _totalPengeluaran = 0;
int _totalSaldo = 0;

String _singleKodeTransaksi = "";
String _kodeTransaksiCount = "000";

int kodeQueryTanggal = 0;

class AdminControllerTransaksiPage extends StatefulWidget {
  const AdminControllerTransaksiPage({Key? key}) : super(key: key);

  @override
  State<AdminControllerTransaksiPage> createState() =>
      _AdminControllerTransaksiPageState();
}

class _AdminControllerTransaksiPageState
    extends State<AdminControllerTransaksiPage> {
  final _controllerPageKodeKeuangan = PageController();
  final _controllerPageBuatTransaksi = PageController();
  @override
  void initState() {
    // TODO: implement initState
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPageKodeKeuangan.dispose();
    _controllerPageBuatTransaksi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPageKodeKeuangan,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        PageView(
          controller: _controllerPageBuatTransaksi,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            AdminTransaksiPage(
              controllerPageKategori: _controllerPageKodeKeuangan,
              controllerPageBuatTransaksi: _controllerPageBuatTransaksi,
            ),
            AdminBuatTransaksiPage(
              controllerPageBuatTransaksi: _controllerPageBuatTransaksi,
            )
          ],
        ),
        BuatKodeKeuanganPage(
          controllerPageKategori: _controllerPageKodeKeuangan,
        ),
      ],
    );
  }
}

class AdminTransaksiPage extends StatefulWidget {
  final PageController controllerPageKategori;
  final PageController controllerPageBuatTransaksi;
  const AdminTransaksiPage(
      {Key? key,
      required this.controllerPageKategori,
      required this.controllerPageBuatTransaksi})
      : super(key: key);

  @override
  State<AdminTransaksiPage> createState() => _AdminTransaksiPageState();
}

class _AdminTransaksiPageState extends State<AdminTransaksiPage> {
  ServicesUser servicesUser = ServicesUser();

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

  int _indexFilterTanggal = 0;

  @override
  void initState() {
    // TODO: implement initState
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;

    widget.controllerPageBuatTransaksi.addListener(() {
      debugPrint("Refreshed");
      if (mounted) {
        setState(() {});
      }
    });

    _getKodePerkiraan(kodeGereja);
    // _getKodeTransaksi(kodeGereja);
    // _getKodeRefKegiatan(kodeGereja);
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

    super.dispose();
  }

  Future _getKodePerkiraan(kodeGereja) async {
    _kodePerkiraan.clear();

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

  Future _getKodeTransaksi(kodeGereja) async {
    _kodeTransaksi.clear();
    var response = await servicesUser.getKodeTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeTransaksi
            .add("${element['kode_transaksi']} - ${element['nama_transaksi']}");
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getKodeRefKegiatan(kodeGereja) async {
    _kodeRefKegiatan.clear();
    var response = await servicesUser.getAllProposalKegiatan(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeRefKegiatan
            .add("${element['kode_kegiatan']} - ${element['nama_kegiatan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getTransaksi(kodeGereja) async {
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    var response = await servicesUser.getTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
        if (element['jenis_transaksi'] == "pemasukan") {
          _totalPemasukan += element['nominal'] as int;
        } else {
          _totalPengeluaran += element['nominal'] as int;
        }
      }
      _totalSaldo = _totalPemasukan - _totalPengeluaran;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _queryTransaksiTanggal(kodeGereja, tanggal1, tanggal2, kode) async {
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    var response = await servicesUser.queryTransaksiTanggal(
        kodeGereja, kode, tanggal1, tanggal2);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
        if (element['jenis_transaksi'] == "pemasukan") {
          _totalPemasukan += element['nominal'] as int;
        } else {
          _totalPengeluaran += element['nominal'] as int;
        }
      }
      _totalSaldo = _totalPemasukan - _totalPengeluaran;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _queryTransaksiKode(kodeGereja, kodeTransaksi, kodePerkiraan) async {
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    var response = await servicesUser.queryTransaksiKode(
        kodeGereja, kodeTransaksi, kodePerkiraan);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
        if (element['jenis_transaksi'] == "pemasukan") {
          _totalPemasukan += element['nominal'] as int;
        } else {
          _totalPengeluaran += element['nominal'] as int;
        }
      }
      _totalSaldo = _totalPemasukan - _totalPengeluaran;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addRowTransaksi(kode, tanggal, deskripsi, jenis, nominal) {
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
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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

  _filterTanggalField() {
    if (_indexFilterTanggal == 0) {
      return Column(
        children: const [
          // ElevatedButton(
          //   //TODO: search btn
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //   ),
          //   onPressed: () {
          //     _getTransaksi(kodeGereja).whenComplete(() => setState(() {}));
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Icon(Icons.search),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       Text(
          //         "Cari",
          //         style: GoogleFonts.nunito(
          //             fontWeight: FontWeight.w700, fontSize: 16),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      );
    } else if (_indexFilterTanggal == 1) {
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
                    responsiveText(date, 14, FontWeight.w700, lightText),
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
            onPressed: () {
              _queryTransaksiTanggal(kodeGereja, date, "", _indexFilterTanggal)
                  .whenComplete(() => setState(() {}));
            },
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
                    responsiveText(dateFrom, 14, FontWeight.w700, lightText),
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
                    responsiveText(dateTo, 14, FontWeight.w700, lightText),
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
            onPressed: () {
              _queryTransaksiTanggal(
                      kodeGereja, dateFrom, dateTo, _indexFilterTanggal)
                  .whenComplete(() => setState(() {}));
            },
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
    } else if (_indexFilterTanggal == 3) {
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
                    responsiveText(month, 14, FontWeight.w700, lightText),
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
            onPressed: () {
              _queryTransaksiTanggal(kodeGereja, month, "", _indexFilterTanggal)
                  .whenComplete(() => setState(() {}));
            },
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

  _cardInfo(title, nominal) {
    return Card(
      elevation: 3,
      color: cardInfoColor,
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
            responsiveText(CurrencyFormat.convertToIdr(nominal, 2), 16,
                FontWeight.w700, darkText),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        widget.controllerPageBuatTransaksi.animateToPage(1,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                      child: Text(
                        "Buat Transaksi",
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
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
                            child: deviceWidth < 1280
                                ? SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: ScrollController(),
                                    scrollDirection: Axis.horizontal,
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
                                            "Pemasukan",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Pengeluaran",
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
                                              color: MaterialStateColor
                                                  .resolveWith(
                                                (states) {
                                                  return index % 2 == 1
                                                      ? Colors.white
                                                      : primaryColor
                                                          .withOpacity(0.2);
                                                },
                                              ),
                                              cells: _rowList[index].cells);
                                        },
                                      ),
                                    ),
                                  )
                                : DataTable(
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
                                          "Pemasukan",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Pengeluaran",
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
                                            color:
                                                MaterialStateColor.resolveWith(
                                              (states) {
                                                return index % 2 == 1
                                                    ? Colors.white
                                                    : primaryColor
                                                        .withOpacity(0.2);
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
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ToggleSwitch(
                                  initialLabelIndex: _indexFilterTanggal,
                                  totalSwitches: 4,
                                  labels: const [
                                    'Semua',
                                    'Hari',
                                    'Minggu',
                                    'Bulan'
                                  ],
                                  activeBgColor: [primaryColorVariant],
                                  activeFgColor: darkText,
                                  inactiveBgColor: Colors.grey[200],
                                  inactiveFgColor: darkText,
                                  dividerColor: Colors.white,
                                  animate: true,
                                  animationDuration: 250,
                                  onToggle: (index) {
                                    setState(() {
                                      _indexFilterTanggal = index!;
                                    });
                                    debugPrint(
                                        'switched to: $_indexFilterTanggal');
                                    if (_indexFilterTanggal == 0) {
                                      _getTransaksi(kodeGereja)
                                          .whenComplete(() => setState(() {}));
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                _filterTanggalField(),
                                const Divider(
                                  height: 56,
                                ),
                                responsiveText("Filter Kode Keuangan", 14,
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
                                    selectedItem: "pilih Kode Perkiraan",
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                _cardInfo(
                                  "Pemasukan",
                                  _totalPemasukan,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                _cardInfo(
                                  "Pengeluaran",
                                  _totalPengeluaran,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                _cardInfo(
                                  "Saldo",
                                  _totalSaldo,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                _cardInfo(
                                  "Saldo Total",
                                  _totalSaldo,
                                ),
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
    );
  }
}

enum RadioJenisTransaksi { pemasukan, pengeluaran }

//TODO: buat Kategori
class BuatKodeKeuanganPage extends StatefulWidget {
  final PageController controllerPageKategori;
  const BuatKodeKeuanganPage({Key? key, required this.controllerPageKategori})
      : super(key: key);

  @override
  State<BuatKodeKeuanganPage> createState() => _BuatKodeKeuanganPageState();
}

class _BuatKodeKeuanganPageState extends State<BuatKodeKeuanganPage> {
  ServicesUser servicesUser = ServicesUser();
  late Future kodePerkiraan;
  late Future kodeTransaksi;

  final _controllerKodePerkiraan = TextEditingController();
  final _controllerNamaKodePerkiraan = TextEditingController();

  final _controllerKodeTransaksi = TextEditingController();
  final _controllerNamaKodeTransaksi = TextEditingController();
  String _status = "";
  @override
  void initState() {
    // TODO: implement initState

    kodePerkiraan = servicesUser.getKodePerkiraan(kodeGereja);
    kodeTransaksi = servicesUser.getKodeTransaksi(kodeGereja);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerKodePerkiraan.dispose();
    _controllerNamaKodePerkiraan.dispose();
    _controllerKodeTransaksi.dispose();
    _controllerNamaKodeTransaksi.dispose();
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

  _showBuatKodePerkiraanDialog(dw, dh) {
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
                              responsiveText("Tambah Kode Perkiraan", 26,
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
                                  responsiveText("Kode Perkiraan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKodePerkiraan, null),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Nama Kode Perkiraan", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(dw, dh,
                                      _controllerNamaKodePerkiraan, null),
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
                                    _controllerKodePerkiraan.clear();
                                    _controllerNamaKodePerkiraan.clear();
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
                                    postKodePerkiraan(
                                            kodeGereja,
                                            _controllerNamaKodePerkiraan.text
                                                .capitalize(),
                                            _controllerKodePerkiraan.text
                                                .toUpperCase(),
                                            context)
                                        .then(
                                      (value) {
                                        _controllerKodePerkiraan.clear();
                                        _controllerNamaKodePerkiraan.clear();
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

  _showBuatKodeTransaksiDialog(dw, dh) {
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
                              responsiveText("Tambah Kode Transaksi", 26,
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
                                  responsiveText("Kode Transaksi", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKodeTransaksi, null),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveText("Nama Kode Transaksi", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(dw, dh,
                                      _controllerNamaKodeTransaksi, null),
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
                                              FontWeight.w700, darkText),
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
                                              FontWeight.w700, darkText),
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
                                    _controllerKodeTransaksi.clear();
                                    _controllerNamaKodeTransaksi.clear();
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
                                            _controllerNamaKodeTransaksi.text
                                                .capitalize(),
                                            _controllerKodeTransaksi.text
                                                .toUpperCase(),
                                            _status,
                                            context)
                                        .then(
                                      (value) {
                                        _controllerNamaKodeTransaksi.clear();
                                        _controllerKodeTransaksi.clear();
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
        kodeTransaksi = servicesUser
            .getKodeTransaksi(kodeGereja)
            .whenComplete(() => setState(() {}));
      }
    });
  }

  Future postKodePerkiraan(
      kodeGereja, namaKodePerkiraan, kodePerkiraan, context) async {
    var response = await servicesUser.inputKodePerkiraan(
        kodeGereja, namaKodePerkiraan, kodePerkiraan);

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

  Future deleteKodePerkiraan(kodeGereja, kodePerkiraan, context) async {
    var response =
        await servicesUser.deleteKodePerkiraan(kodeGereja, kodePerkiraan);

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

  Future postKodeTransaksi(
      kodeGereja, namaKodeTransaksi, kodeTransaksi, status, context) async {
    var response = await servicesUser.inputKodeTransaksi(
        kodeGereja, namaKodeTransaksi, kodeTransaksi, status);

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

  Future deleteKodeTransaksi(kodeGereja, kodeTransaksi, context) async {
    var response =
        await servicesUser.deleteKodeTransaksi(kodeGereja, kodeTransaksi);

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
                      onPressed: () {
                        widget.controllerPageKategori.animateToPage(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    responsiveText(
                        "Buat Kode Keuangan", 26, FontWeight.w900, darkText),
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
                      child: deviceWidth < 1280
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: deviceWidth,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          responsiveText("Kode Transaksi", 20,
                                              FontWeight.w700, darkText),
                                          ElevatedButton(
                                            onPressed: () {
                                              _showBuatKodeTransaksiDialog(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FutureBuilder(
                                            future: kodeTransaksi,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List snapData =
                                                    snapshot.data! as List;
                                                debugPrint(snapData.toString());
                                                if (snapData[0] != 404) {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    controller:
                                                        ScrollController(),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        snapData[1].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          dense: true,
                                                          minLeadingWidth: 85,
                                                          leading: responsiveText(
                                                              snapData[1][index]
                                                                  [
                                                                  'kode_transaksi'],
                                                              16,
                                                              FontWeight.w600,
                                                              darkText),
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    VerticalDivider(
                                                                  color:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              responsiveText(
                                                                  snapData[1][
                                                                          index]
                                                                      [
                                                                      'nama_transaksi'],
                                                                  16,
                                                                  FontWeight
                                                                      .w600,
                                                                  darkText),
                                                              const Spacer(),
                                                              IconButton(
                                                                onPressed: () {
                                                                  deleteKodeTransaksi(
                                                                          kodeGereja,
                                                                          snapData[1][index]
                                                                              [
                                                                              'kode_transaksi'],
                                                                          context)
                                                                      .whenComplete(
                                                                          () {
                                                                    kodeTransaksi =
                                                                        servicesUser
                                                                            .getKodeTransaksi(kodeGereja);
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                icon: const Icon(
                                                                    Icons
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
                                const SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: deviceWidth,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          responsiveText("Kode Perkiraan", 20,
                                              FontWeight.w700, darkText),
                                          ElevatedButton(
                                            onPressed: () {
                                              _showBuatKodePerkiraanDialog(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
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
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    controller:
                                                        ScrollController(),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        snapData[1].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          dense: true,
                                                          minLeadingWidth: 85,
                                                          leading: responsiveText(
                                                              snapData[1][index]
                                                                  [
                                                                  'kode_perkiraan'],
                                                              16,
                                                              FontWeight.w600,
                                                              darkText),
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    VerticalDivider(
                                                                  color:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              responsiveText(
                                                                  snapData[1][
                                                                          index]
                                                                      [
                                                                      'nama_kode_perkiraan'],
                                                                  16,
                                                                  FontWeight
                                                                      .w600,
                                                                  darkText),
                                                              const Spacer(),
                                                              IconButton(
                                                                onPressed: () {
                                                                  deleteKodePerkiraan(
                                                                          kodeGereja,
                                                                          snapData[1][index]
                                                                              [
                                                                              'kode_perkiraan'],
                                                                          context)
                                                                      .whenComplete(
                                                                          () {
                                                                    kodePerkiraan =
                                                                        servicesUser
                                                                            .getKodePerkiraan(kodeGereja);
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                icon: const Icon(
                                                                    Icons
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
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          responsiveText("Kode Transaksi", 20,
                                              FontWeight.w700, darkText),
                                          ElevatedButton(
                                            onPressed: () {
                                              _showBuatKodeTransaksiDialog(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FutureBuilder(
                                            future: kodeTransaksi,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List snapData =
                                                    snapshot.data! as List;
                                                debugPrint(snapData.toString());
                                                if (snapData[0] != 404) {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    controller:
                                                        ScrollController(),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        snapData[1].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          dense: true,
                                                          minLeadingWidth: 85,
                                                          leading: responsiveText(
                                                              snapData[1][index]
                                                                  [
                                                                  'kode_transaksi'],
                                                              16,
                                                              FontWeight.w600,
                                                              darkText),
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    VerticalDivider(
                                                                  color:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              responsiveText(
                                                                  snapData[1][
                                                                          index]
                                                                      [
                                                                      'nama_transaksi'],
                                                                  16,
                                                                  FontWeight
                                                                      .w600,
                                                                  darkText),
                                                              const Spacer(),
                                                              IconButton(
                                                                onPressed: () {
                                                                  deleteKodeTransaksi(
                                                                          kodeGereja,
                                                                          snapData[1][index]
                                                                              [
                                                                              'kode_transaksi'],
                                                                          context)
                                                                      .whenComplete(
                                                                          () {
                                                                    kodeTransaksi =
                                                                        servicesUser
                                                                            .getKodeTransaksi(kodeGereja);
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                icon: const Icon(
                                                                    Icons
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
                                const SizedBox(
                                  width: 25,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          responsiveText("Kode Perkiraan", 20,
                                              FontWeight.w700, darkText),
                                          ElevatedButton(
                                            onPressed: () {
                                              _showBuatKodePerkiraanDialog(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
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
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    controller:
                                                        ScrollController(),
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        snapData[1].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        color:
                                                            scaffoldBackgroundColor,
                                                        child: ListTile(
                                                          dense: true,
                                                          minLeadingWidth: 85,
                                                          leading: responsiveText(
                                                              snapData[1][index]
                                                                  [
                                                                  'kode_perkiraan'],
                                                              16,
                                                              FontWeight.w600,
                                                              darkText),
                                                          title: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    VerticalDivider(
                                                                  color:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              responsiveText(
                                                                  snapData[1][
                                                                          index]
                                                                      [
                                                                      'nama_kode_perkiraan'],
                                                                  16,
                                                                  FontWeight
                                                                      .w600,
                                                                  darkText),
                                                              const Spacer(),
                                                              IconButton(
                                                                onPressed: () {
                                                                  deleteKodePerkiraan(
                                                                          kodeGereja,
                                                                          snapData[1][index]
                                                                              [
                                                                              'kode_perkiraan'],
                                                                          context)
                                                                      .whenComplete(
                                                                          () {
                                                                    kodePerkiraan =
                                                                        servicesUser
                                                                            .getKodePerkiraan(kodeGereja);
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                icon: const Icon(
                                                                    Icons
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

//TODO: Buat Transaksi Page
class AdminBuatTransaksiPage extends StatefulWidget {
  final PageController controllerPageBuatTransaksi;
  const AdminBuatTransaksiPage(
      {super.key, required this.controllerPageBuatTransaksi});

  @override
  State<AdminBuatTransaksiPage> createState() => _AdminBuatTransaksiPageState();
}

class _AdminBuatTransaksiPageState extends State<AdminBuatTransaksiPage> {
  ServicesUser servicesUser = ServicesUser();

  final _controllerNominal = TextEditingController();
  final _controllerKeterangan = TextEditingController();
  String kodePerkiraan = "";
  String kodeRefKegiatan = "";

  final _controllerDropdownFilter = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String date = "Date";

  final itemTransaksi = List.empty(growable: true);
  final tempItemTransaksi = List.empty(growable: true);

  String selectedKodePerkiraan = "Pilih Kode Perkiraan";
  String selectedKodeRefKegiatan = "Pilih Kode Referensi";
  String selectedKodeTransaksi = "Pilih Kode Transaksi";

  @override
  void initState() {
    // TODO: implement initState
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    itemTransaksi.clear();
    selectedKodePerkiraan = "Pilih Kode Perkiraan";
    selectedKodeRefKegiatan = "Pilih Kode Referensi";
    selectedKodeTransaksi = "Pilih Kode Transaksi";

    _singleKodeTransaksi = "";
    _kodeTransaksiCount = "000";
    _getKodePerkiraan(kodeGereja);
    _getKodeTransaksi(kodeGereja);
    _getKodeRefKegiatan(kodeGereja);

    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerNominal.dispose();
    _controllerKeterangan.dispose();
    _controllerDropdownFilter.dispose();
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

  Future _getTransaksi(kodeGereja) async {
    _rowList.clear();
    _totalPemasukan = 0;
    _totalPengeluaran = 0;
    _totalSaldo = 0;
    var response = await servicesUser.getTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowTransaksi(
            element['kode_transaksi'],
            element['tanggal_transaksi'],
            element['uraian_transaksi'],
            element['jenis_transaksi'],
            element['nominal']);
        if (element['jenis_transaksi'] == "pemasukan") {
          _totalPemasukan += element['nominal'] as int;
        } else {
          _totalPengeluaran += element['nominal'] as int;
        }
      }
      _totalSaldo = _totalPemasukan - _totalPengeluaran;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addRowTransaksi(kode, tanggal, deskripsi, jenis, nominal) {
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
  }

  Future _getKodePerkiraan(kodeGereja) async {
    _kodePerkiraan.clear();

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

  Future _getKodeTransaksi(kodeGereja) async {
    _kodeTransaksi.clear();
    var response = await servicesUser.getKodeTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeTransaksi
            .add("${element['kode_transaksi']} - ${element['nama_transaksi']}");
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getKodeTransaksiCount(kodeTransaksiGabungan) async {
    _kodeTransaksiCount = "000";
    var response =
        await servicesUser.getSingleKodeTransaksi(kodeTransaksiGabungan);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element['count_kode_transaksi'].toString());
        _kodeTransaksiCount = element['count_kode_transaksi'].toString();
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _getKodeRefKegiatan(kodeGereja) async {
    _kodeRefKegiatan.clear();
    var response = await servicesUser.getAllProposalKegiatan(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        debugPrint(element.toString());
        _kodeRefKegiatan
            .add("${element['kode_kegiatan']} - ${element['nama_kegiatan']}");
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future _postTransaksi(
      kodeGereja,
      kodeTransaksi,
      kodePerkiraan,
      kodeRefKegiatan,
      tanggalTransaksi,
      deskripsiTransaksi,
      nominalTransaksi,
      context) async {
    var response = await servicesUser.inputTransaksi(
        kodeGereja,
        kodeTransaksi,
        kodePerkiraan,
        kodeRefKegiatan,
        tanggalTransaksi,
        deskripsiTransaksi,
        nominalTransaksi);
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

  Future _updateCountKodeTransaksi(kodeTransaksi, kodeGereja, context) async {
    var response =
        await servicesUser.updateCountKodeTransaksi(kodeGereja, kodeTransaksi);
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

  _splitString(val) {
    var value = val.toString();
    var split = value.indexOf(" ");
    var temp = value.substring(0, split);
    return temp;
  }

  _splitStringKode(val) {
    var value = val.toString();
    var split = value.indexOf("-");
    var temp = value.substring(0, split);
    return temp;
  }

  _buatKodeGabungan(val) {
    var temp = kodeGereja + _splitString(val);
    return temp;
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
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: navButtonPrimary, // button text color
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

//TODO: Show Tambah Transaksi Dialog
  _showTambahDialog(dw, dh, kodeTransaksi) {
    selectedKodePerkiraan = "Pilih Kode Perkiraan";
    selectedKodeRefKegiatan = "Pilih Kode Referensi";
    _controllerKeterangan.clear();
    _controllerNominal.clear();
    date = formattedDate;
    kodeRefKegiatan = "";
    kodePerkiraan = "";
    tempItemTransaksi.clear();

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
                              responsiveText("Tambah Item Transaksi", 26,
                                  FontWeight.w700, lightText),
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
                                  responsiveText("Kode Transaksi", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //TODO: Kode Transaksi
                                  responsiveText(kodeTransaksi, 16,
                                      FontWeight.w700, darkText),
                                  const Divider(
                                    height: 25,
                                  ),
                                  //TODO: Input Kode Perkiraan Dialog
                                  responsiveText("Kode Perkiraan", 16,
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
                                      onChanged: (val) {
                                        selectedKodePerkiraan = val;
                                        debugPrint(selectedKodePerkiraan);
                                        debugPrint(_splitString(
                                            selectedKodePerkiraan));
                                        debugPrint(_buatKodeGabungan(
                                            selectedKodePerkiraan));
                                        kodePerkiraan =
                                            _splitString(selectedKodePerkiraan);
                                        debugPrint(kodePerkiraan);
                                      },
                                      selectedItem: selectedKodePerkiraan,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //TODO: Input Kode Referensi Dialog
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
                                        selectedKodeRefKegiatan = val;
                                        debugPrint(selectedKodeRefKegiatan);
                                        debugPrint(_splitString(
                                            selectedKodeRefKegiatan));
                                        debugPrint(_buatKodeGabungan(
                                            selectedKodeRefKegiatan));
                                        kodeRefKegiatan = _splitString(
                                            selectedKodeRefKegiatan);
                                        debugPrint(kodeRefKegiatan);
                                      },
                                      selectedItem: selectedKodeRefKegiatan,
                                    ),
                                  ),
                                  responsiveText("*Biarkan Kalau Tidak Ada", 12,
                                      FontWeight.w700, Colors.red),

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
                                  debugPrint(kodeTransaksi);
                                  debugPrint(kodePerkiraan);
                                  debugPrint(kodeRefKegiatan);
                                  debugPrint(date);
                                  debugPrint(_controllerNominal.text);
                                  debugPrint(_controllerKeterangan.text);

                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  //Print
                                  debugPrint(kodeTransaksi);
                                  debugPrint(kodePerkiraan);
                                  debugPrint(kodeRefKegiatan);
                                  debugPrint(date);
                                  debugPrint(_controllerNominal.text);
                                  debugPrint(_controllerKeterangan.text);

                                  //Add
                                  tempItemTransaksi.add(kodeTransaksi);
                                  tempItemTransaksi.add(kodePerkiraan);
                                  tempItemTransaksi.add(kodeRefKegiatan);
                                  tempItemTransaksi.add(date);
                                  tempItemTransaksi
                                      .add(_controllerNominal.text);
                                  tempItemTransaksi
                                      .add(_controllerKeterangan.text);

                                  debugPrint(tempItemTransaksi.toString());
                                  itemTransaksi.add(tempItemTransaksi.toList());
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
    ).whenComplete(() {
      debugPrint(itemTransaksi.toString());
      setState(() {});
    });
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
              children: [
                IconButton(
                  onPressed: () {
                    _rowList.clear();
                    _totalPemasukan = 0;
                    _totalPengeluaran = 0;
                    _totalSaldo = 0;
                    _getTransaksi(kodeGereja).whenComplete(
                      () => widget.controllerPageBuatTransaksi.animateToPage(0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const SizedBox(
                  width: 25,
                ),
                responsiveText("Buat Transaksi", 26, FontWeight.w900, darkText),
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
                      //TODO: Input Kode Transaksi Dialog
                      responsiveText(
                          "Kode Transaksi", 16, FontWeight.w700, darkText),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: surfaceColor,
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    controller: _controllerDropdownFilter,
                                  ),
                                ),
                                items: _kodeTransaksi,
                                onChanged: (val) {
                                  selectedKodeTransaksi = val;
                                  itemTransaksi.clear();
                                  debugPrint(selectedKodeTransaksi);
                                  debugPrint(
                                      _splitString(selectedKodeTransaksi));
                                  debugPrint(
                                      _buatKodeGabungan(selectedKodeTransaksi));
                                  _singleKodeTransaksi =
                                      _splitString(selectedKodeTransaksi);
                                  String tempKodeGabungan =
                                      _buatKodeGabungan(selectedKodeTransaksi)
                                          .toString();
                                  _getKodeTransaksiCount(tempKodeGabungan)
                                      .whenComplete(() => setState(() {}));
                                },
                                selectedItem: selectedKodeTransaksi,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 10,
                            child: Divider(
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          responsiveText(_kodeTransaksiCount, 16,
                              FontWeight.w700, darkText),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              debugPrint(_singleKodeTransaksi);
                              if (_singleKodeTransaksi != "") {
                                _showTambahDialog(deviceWidth, deviceHeight,
                                    "$_singleKodeTransaksi-$_kodeTransaksiCount");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Silahkan Pilih Kode Transaksi Terlebih Dahulu"),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Tambah Item",
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            controller: ScrollController(),
                            physics: const ClampingScrollPhysics(),
                            itemCount: itemTransaksi.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: scaffoldBackgroundColor,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        dense: true,
                                        minLeadingWidth: 85,
                                        minVerticalPadding: 16,
                                        title: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: responsiveText(
                                                  "${itemTransaksi[index][0]}-${itemTransaksi[index][1]}",
                                                  16,
                                                  FontWeight.w600,
                                                  darkText),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: VerticalDivider(
                                                color: dividerColor,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: responsiveText(
                                                  itemTransaksi[index][3]
                                                      .toString(),
                                                  16,
                                                  FontWeight.w600,
                                                  darkText),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: VerticalDivider(
                                                color: dividerColor,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: responsiveText(
                                                  itemTransaksi[index][5]
                                                      .toString(),
                                                  16,
                                                  FontWeight.w600,
                                                  darkText),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: VerticalDivider(
                                                color: dividerColor,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: responsiveText(
                                                  CurrencyFormat.convertToIdr(
                                                      int.parse(
                                                          itemTransaksi[index]
                                                              [4]),
                                                      2),
                                                  16,
                                                  FontWeight.w600,
                                                  darkText),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: VerticalDivider(
                                                color: dividerColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            itemTransaksi.removeAt(index);
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          },
                                          icon:
                                              const Icon(Icons.delete_rounded),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          int ctr = 0;
                          String tempKodeTransaksi = "";
                          for (var element in itemTransaksi) {
                            tempKodeTransaksi = _splitStringKode(element[0]);
                            debugPrint(tempKodeTransaksi);
                            debugPrint(
                                "${element[0]} - ${element[1]} - ${element[2]} - ${element[3]} - ${element[4]} - ${element[5]}");

                            _postTransaksi(
                                    kodeGereja,
                                    element[0],
                                    element[1],
                                    element[2],
                                    element[3],
                                    element[5],
                                    element[4],
                                    context)
                                .whenComplete(
                              () {
                                ctr++;
                                if (ctr == itemTransaksi.length) {
                                  _updateCountKodeTransaksi(tempKodeTransaksi,
                                          kodeGereja, context)
                                      .whenComplete(
                                    () {
                                      _rowList.clear();
                                      _totalPemasukan = 0;
                                      _totalPengeluaran = 0;
                                      _totalSaldo = 0;
                                      _getTransaksi(kodeGereja).whenComplete(
                                        () => widget.controllerPageBuatTransaksi
                                            .animateToPage(0,
                                                duration: const Duration(
                                                    milliseconds: 250),
                                                curve: Curves.ease),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          }
                        },
                        child: Text(
                          "Simpan Transaksi",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700, fontSize: 14),
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
    );
  }
}
