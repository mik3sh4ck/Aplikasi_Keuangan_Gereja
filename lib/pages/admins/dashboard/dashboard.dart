// ignore_for_file: todo
import 'package:aplikasi_keuangan_gereja/themes/colors.dart';
import 'package:aplikasi_keuangan_gereja/services/apiservices.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../globals.dart';

TextStyle welcomeText = GoogleFonts.nunito(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 36,
);

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  ServicesUser servicesUser = ServicesUser();
  String nama = "";

  @override
  void initState() {
    getUserName(kodeUser);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  cardSaldo(judul, jumlah) {
    return Container(
      width: 200,
      height: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          Text("$judul"),
          const Divider(
            color: Colors.black,
          ),
          const Spacer(),
          Text("Rp. $jumlah"),
        ],
      ),
    );
  }

  cardNews(judul, isi) {
    return Container(
      padding: const EdgeInsets.all(0),
      width: 350,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: primaryColor,
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Text("$judul"),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            border: Border.all(color: Colors.black),
          ),
          child: Text("$isi"),
        )
      ]),
    );
  }

  Future getUserName(userStatus) async {
    var response = await servicesUser.getSingleUser(userStatus);
    nama = response[1]['nama_lengkap_user'].toString();
  }

  @override
  Widget build(BuildContext context) {
    getUserName(kodeUser);
    List<LineChartBarData> lineChartBarData = [

      LineChartBarData(
        isCurved: true,
        spots: [
          FlSpot(1, 0),
          FlSpot(2, 12),
          FlSpot(3, 10),
          FlSpot(4, 7),
          FlSpot(5, 8),
          FlSpot(6, 10),
        ],
        color: primaryColor,
        barWidth: 3,
      )

    ];
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
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang',
                            style: welcomeText,
                          ),
                          Text(
                            nama,
                            style: welcomeText,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          cardNews('judul news',
                              'Telah diterima donasi sebesar 3.000.000 dari Gereja ABCDE, Tuhan Yesus memberkati.'),
                          const SizedBox(
                            height: 20,
                          ),
                          cardNews('judul news',
                              'Telah diterima donasi sebesar 3.000.000 dari Gereja ABCDE, Tuhan Yesus memberkati.'),
                          const SizedBox(
                            height: 20,
                          ),
                          cardNews('judul news',
                              'Telah diterima donasi sebesar 3.000.000 dari Gereja ABCDE, Tuhan Yesus memberkati.')
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cardSaldo('Saldo', '20000'),
                              const SizedBox(
                                width: 20,
                              ),
                              cardSaldo('Pemasukan', '20000'),
                              const SizedBox(
                                width: 20,
                              ),
                              cardSaldo('Pengeluaran', '20000'),
                            ],
                          ),
                          Container(

                              padding: EdgeInsets.all(20),
                              width: 800,
                              height: 500,
                              child: LineChart(
                                LineChartData(
                                  minX: 1,
                                  minY: 0,
                                  maxX: 6,
                                  maxY: 15,
                                  lineBarsData: lineChartBarData,
                                  gridData: FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                ),
                              ))

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
