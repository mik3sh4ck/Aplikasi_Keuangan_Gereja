//ignore_for_file: todo

import 'dart:convert';
import 'package:http/http.dart' as http;

var _linkPath = "http://cfin.crossnet.co.id:1323/";

class ServicesUser {
  Future getAllUser(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}user?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: nambah user
  Future createUser(kodeGereja, namaLengkapUser, emailUser, noTelpUser) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-user?kode_gereja=$kodeGereja&nama_lengkap_user=$namaLengkapUser&email_user=$emailUser&no_telp_user=$noTelpUser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal edit data");
    }
  }

  //TODO: Update Profile User
  Future updateUserProfile(
      kodeUser,
      emailUser,
      jenisKelamin,
      tanggalUser,
      noTelpUser,
      alamatUser,
      kemampuanUser,
      namaLengkapUser,
      fotoProfileUser) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}update-user-profile?kode_user=$kodeUser&email_user=$emailUser&jenis_kelamin_user=$jenisKelamin&tanggal_lahir_user=$tanggalUser&no_telp_user=$noTelpUser&alamat_user=$alamatUser&kemampuan_user=$kemampuanUser&nama_lengkap_user=$namaLengkapUser&foto_profile=$fotoProfileUser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal edit data");
    }
  }

  //TODO: Get User
  Future getSingleUser(kodeuser) async {
    final response = await http.get(
      Uri.parse("${_linkPath}get-profile?kode_user=$kodeuser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getKodePrevilage(namaprevilage) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-single-previlage?nama_previlage=$namaprevilage"),
    );

    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future checkPrevilage(pv, kodegereja, koderoleuser) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}checking-previlage-role?previlage_value=$pv&kode_gereja=$kodegereja&user_role=$koderoleuser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Login
  Future getAuth(username, password) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}login?username=$username&password=$password&status1=2&status2=3"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Kode Gereja
  Future getKodeGereja(kodeuser) async {
    final response = await http.get(
      Uri.parse("${_linkPath}get-kode-gereja?kode_user=$kodeuser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Aktivasi OTP
  Future createOTP(noTelpUser) async {
    final response = await http.post(
      Uri.parse("${_linkPath}generate-otp?no_telp=$noTelpUser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

//TODO: Aktivasi AKun
  Future aktivasiAkun(userName, noTelp, kataSandi, kodeOtp) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}aktivasi-akun?nama_pengguna=$userName&no_telp=$noTelp&kata_sandi=$kataSandi&otp=$kodeOtp"),
    );

    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal Mengupdate data");
    }
  }

  //TODO: get Master kode Perkiraan
  Future getMasterKode(kodeGereja) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-header-kode-perkiraan?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Master Kode Perkiraan
  Future inputMasterKode(kodeGereja, namaMasterKode, masterKodePerkiraan,
      statusKode, statusNeraca) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-header-kode-perkiraan?kode_gereja=$kodeGereja&nama_header=$namaMasterKode&header_kode_perkiraan=$masterKodePerkiraan&status=$statusKode&status_neraca=$statusNeraca"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal memasukan data");
    }
  }

  //TODO: Delete Kode Master
  Future deleteKodePerkiraan(kodeGereja, kodePerkiraan, kodeMaster) async {
    final response = await http.delete(
      Uri.parse(
          "${_linkPath}delete-kode-perkiraan?kode_gereja=$kodeGereja&kode_perkiraan=$kodePerkiraan&header_kode_perkiraan=$kodeMaster"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal menghapus data");
    }
  }

  //TODO: get kode Perkiraan
  Future getKodePerkiraan(kodeGereja, headerKodePerkiraan) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}kode-perkiraan?kode_gereja=$kodeGereja&header_kode_perkiraan=$headerKodePerkiraan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Kode Perkiraan
  Future inputKodePerkiraan(
      kodeGereja, namaKodePerkiraan, kodePerkiraan, headerKodePerkiraan) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kode-perkiraan?kode_perkiraan=$kodePerkiraan&nama_kode_perkiraan=$namaKodePerkiraan&kode_gereja=$kodeGereja&header_kode_perkiraan=$headerKodePerkiraan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal memasukan data");
    }
  }

  Future inputSaldoAwal(
      kodeGereja, headerKodePerkiraan, kodePerkiraan, saldo) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-saldo-awal?kode_gereja=$kodeGereja&header_kode_perkiraan=$headerKodePerkiraan&kode_perkiraan=$kodePerkiraan&saldo_awal=$saldo"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal memasukan data");
    }
  }

  Future updateSaldoAwal(
      kodeGereja, headerKodePerkiraan, kodePerkiraan, saldo) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}update-saldo-awal?kode_gereja=$kodeGereja&header_kode_perkiraan=$headerKodePerkiraan&kode_perkiraan=$kodePerkiraan&saldo_awal=$saldo"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal memasukan data");
    }
  }

  //TODO: Delete Kode Perkiraan
  Future deleteKodeMaster(kodeGereja, kodeMaster) async {
    final response = await http.delete(
      Uri.parse(
          "${_linkPath}delete-header-kode-perkiraan?kode_gereja=$kodeGereja&header_kode_perkiraan=$kodeMaster"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal menghapus data");
    }
  }

  //TODO: get kode Perkiraan
  Future getKodePerkiraanSingleKegiatan(
      kodeGereja, kodeKegiatan, kodeTransaksi, status) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kode-perkiraan-single-kegiatan?kode_gereja=$kodeGereja&kode_kegiatan=$kodeKegiatan&kode_transaksi=$kodeTransaksi&status=$status"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get kode Transaksi
  Future getKodeTransaksi(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}kode-transaksi?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Kode Transaksi
  Future inputKodeTransaksi(
      kodeGereja, namaKodeTransaksi, kodeTransaksi) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kode-transaksi?kode_gereja=$kodeGereja&nama_transaksi=$namaKodeTransaksi&kode_transaksi=$kodeTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal memasukan data");
    }
  }

  //TODO: Delete Kode Transaksi
  Future deleteKodeTransaksi(kodeGereja, kodeTransaksi) async {
    final response = await http.delete(
      Uri.parse(
          "${_linkPath}delete-kode-transaksi?kode_gereja=$kodeGereja&kode_transaksi=$kodeTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal menghapus data");
    }
  }

  Future getSingleKodeTransaksi(kodeTransaksiGabungan) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kode-transaksi-single-row?kode_transaksi_gabungan=$kodeTransaksiGabungan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal memasukan data");
    }
  }

  //TODO: Get Transaksi
  Future getTransaksi(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}transaksi?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Transaksi
  Future inputTransaksi(
      kodeGereja,
      kodeTransaksi,
      kodeMaster,
      kodePerkiraan,
      kodeRefKegiatan,
      tanggalTransaksi,
      deskripsiTransaksi,
      nominalTransaksi,
      jenisTransaksi) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-transaksi?kode_transaksi=$kodeTransaksi&kode_perkiraan=$kodePerkiraan&kode_gereja=$kodeGereja&kode_kegiatan=$kodeRefKegiatan&uraian_transaksi=$deskripsiTransaksi&tanggal_transaksi=$tanggalTransaksi&nominal=$nominalTransaksi&header_kode_perkiraan=$kodeMaster&jenis_transaksi=$jenisTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      print(response.statusCode);
    }
  }

  //TODO: Update Count Kode Transaksi
  Future updateCountKodeTransaksi(kodeGereja, kodeTransaksi) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}update-count-kode-transaksi?kode_transaksi=$kodeTransaksi&kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengupdate data");
    }
  }

  //TODO: Get Transaksi
  Future getKodeTransaksiAdded(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}read-transaksi-distinc?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Saldo Akun
  Future getSaldoAkun(kodeGereja, kodePerkiraansync) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}filter-kas?kode_gereja=$kodeGereja&kode_perkiraan=$kodePerkiraansync"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Query Transaksi Berdasar Tanggal
  Future queryTransaksiTanggal(kodeGereja, kode, tanggal1, tanggal2) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}query-tanggal?tanggal_ke_1=$tanggal1&tanggal_ke_2=$tanggal2&kode_gereja=$kodeGereja&kode=$kode"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Query Transaksi Berdasar Tanggal
  Future queryTransaksiKode(kodeGereja, kodeTransaksi, kodePerkiraan) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}query-kode-transaksi?kode_transaksi=$kodeTransaksi&kode_perkiraan=$kodePerkiraan&kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Saldo Awal
  Future getSaldoAwal(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}saldo-awal?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Laporan Buku Besar
  Future getKodeBukuBesar(kodeGereja) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kode-perkiraan-buku-besar?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getItemBukuBesar(
      kodeGereja, tanggal, kodeMaster, kodePerkiraan) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}buku-besar?kode_gereja=$kodeGereja&tanggal=$tanggal&header_kode_perkiraan=$kodeMaster&kode_perkiraan=$kodePerkiraan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getNeraca(kodeGereja, tanggal, status, statusNeraca) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}neraca-saldo?kode_gereja=$kodeGereja&tanggal=$tanggal&status=$status&status_neraca=$statusNeraca"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getstatusNeraca(kodeGereja, tanggal) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-status?kode_gereja=$kodeGereja&tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getKodeKegiatanJurnal(kodeGereja, tanggal) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kode-transaksi-jurnal?kode_gereja=$kodeGereja&tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getJurnal(kodeGereja, tanggal, kodeTransaksi) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}jurnal?kode_gereja=$kodeGereja&tanggal=$tanggal&kode_transaksi=$kodeTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Chart Dashboard
  Future getPemasukanChart(kodeGereja, tanggal) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}chart-pemasukan?kode_gereja=$kodeGereja&tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getPengeluaranChart(kodeGereja, tanggal) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}chart-pengeluaran?kode_gereja=$kodeGereja&tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getSaldoChart(kodeGereja, tanggal) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}chart-saldo?kode_gereja=$kodeGereja&tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Role
  Future getRole(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}role?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Detail Role
  Future getDetailRole(kodeGereja, kodeRole) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-previlage-role?kode_gereja=$kodeGereja&kode_role=$kodeRole"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Role
  Future inputRole(kodeGereja, idPrivilege, namaRole) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-role?kode_gereja=$kodeGereja&id_previlage=$idPrivilege&nama_role=$namaRole"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Update Role
  Future updateRole(kodeGereja, idPrivilege, kodeRole, namaRole) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}update-role?kode_gereja=$kodeGereja&id_pevilage=$idPrivilege&kode_role=$kodeRole&nama_role=$namaRole"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengupdate data");
    }
  }

  //TODO: update assign role
  Future updateAssignRole(kodeGerejaass, kodeRoleass, kodeUserass) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}asaign-role?kode_gereja=$kodeGerejaass&kode_user=$kodeUserass&kode_role=$kodeRoleass"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengupdate data");
    }
  }

//TODO: Get Proposal Kegiatan
  Future getAllProposalKegiatan(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}proposal-kegiatan?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Item Proposal Kegiatan
  Future getAllItemProposalKegiatan(kodeKegiatangab, kodeKeg, kodeGer) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}item-proposal-kegiatan?kode_kegiatan_gabungan=$kodeKegiatangab&kode_kegiatan=$kodeKeg&kode_gereja=$kodeGer"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Kegiatan
  Future inputProposalKegiatan(
      kodekegiatan,
      kodegereja,
      namakegiatan,
      penanggungjawabkode,
      tanggalacaradimulai,
      tanggalacaraselesai,
      lokasikegiatan,
      keterangankegiatan,
      tanggalkegiatandimulai,
      tanggalkegiatanselesai) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-proposal-kegiatan?kode_kegiatan=$kodekegiatan&kode_gereja=$kodegereja&nama_kegiatan=$namakegiatan&penanggungjawab_1=$penanggungjawabkode&tanggal_acara_dimulai=$tanggalacaradimulai&tanggal_acara_selesai=$tanggalacaraselesai&lokasi_kegiatan=$lokasikegiatan&keterangan_kegiatan=$keterangankegiatan&tanggal_kegiatan_dimulai=$tanggalkegiatandimulai&tanggal_kegiatan_selesai=$tanggalkegiatanselesai"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Item Kebutuhan
  Future inputItemKebutuhan(kodeItemProposalPerkiraan, kodeItemProposalKegiatan,
      kodeProposalGereja, budgetKebutuhan, kodeItemProposalMaster) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-item-proposal-kegiatan?kode_perkiraan=$kodeItemProposalPerkiraan&kode_kegiatan=$kodeItemProposalKegiatan&kode_gereja=$kodeProposalGereja&budget_kebutuhan=$budgetKebutuhan&header_kode_perkiraan=$kodeItemProposalMaster"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get PIC
  Future getPIC(kodeKegiatanGabungan) async {
    final response = await http.get(
      Uri.parse("${_linkPath}PIC?kode_kegiatan_gabungan=$kodeKegiatanGabungan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input PIC
  Future inputPIC(kodeUserPIC, kodeKegiatanPIC, kodeGerejaPIC, peranPIC) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-PIC?kode_user=$kodeUserPIC&kode_kegiatan=$kodeKegiatanPIC&kode_gereja=$kodeGerejaPIC&peran=$peranPIC"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input kebutuhan kegiatan
  Future inputKebutuhanKegiatan(tanggalKebutuhan, keteranganPengeluaran,
      pengeluaranKebutuhan, kodeItemProposalKegiatan) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kebutuhan-kegiatan?tanggal_kebutuhan=$tanggalKebutuhan&keterangan_pengeluaran_kebutuhan=$keteranganPengeluaran&pengeluaran_kebutuhan=$pengeluaranKebutuhan&kode_item_proposal_gabungan=$kodeItemProposalKegiatan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get pengeluaran item kebutuhan
  Future getPengeluaranKebutuhan(kodeGabunganPengeluaran) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}kebutuhan-kegiatan?kode_item_proposal_gabungan=$kodeGabunganPengeluaran"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input kode kegiatan
  Future inputKodeKegiatan(
      kodeKategoriKegiatan, namaKategoriKegiatan, kodeGerejaKegiatan) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kategori-kegiatan?kode_kategori_kegiatan=$kodeKategoriKegiatan&nama_kategori_kegiatan=$namaKategoriKegiatan&kode_gereja=$kodeGerejaKegiatan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get kode kegiatan
  Future getKodeKegiatan(kodeGerejaAmbilKategori) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}kategori-kegiatan?kode_gereja=$kodeGerejaAmbilKategori"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Single Row
  Future getsingleRow(kodekategorikegiatangabungan) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kategori-kegiatan-single-row?kode_kategori_kegiatan_gabungan=$kodekategorikegiatangabungan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get persentase
  Future getPersentase(kodepregabungan, kodeprekeg, kodepregre) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}persentase-global?kode_kegiatan_gabungan=$kodepregabungan&kode_kegiatan=$kodeprekeg&kode_gereja=$kodepregre"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get kebutuhan kegiatan
  Future getDetailKebutuhanKegiatan(kodeKeg, kodeGer, kodePer, kodeMas) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}kebutuhan-kegiatan?kode_kegiatan=$kodeKeg&kode_gereja=$kodeGer&kode_perkiraan=$kodePer&header_kode_perkiraan=$kodeMas"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Update Count Kode Kegiatan
  Future updateCountKodeKegiatan(kodeGereja, kodeKegiatan) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}update-count-kategori-kegiatan?kode_kategori_kegiatan=$kodeKegiatan&kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengupdate data");
    }
  }

//TODO: Get riwayat Proposal Kegiatan
  Future getAllRiwayat(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}history?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Delete Kode Kegiatan
  Future deleteKodeKegiatan(kodeGereja, kodeKategoriKegiatan) async {
    final response = await http.delete(
      Uri.parse(
          "${_linkPath}delete-kategori-kegiatan?kode_gereja=$kodeGereja&kode_kategori_kegiatan=$kodeKategoriKegiatan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal menghapus data");
    }
  }

  // //TODO: Get detail pemasukan Kegiatan
  // Future getPemasukanDetail(kodeGerejaDetail, kodeKegiatanDetail) async {
  //   final response = await http.get(
  //     Uri.parse(
  //         "${_linkPath}pemasukan-kegiatan?kode_gereja=$kodeGerejaDetail&kode_kegiatan=$kodeKegiatanDetail"),
  //   );
  //   if (response.statusCode == 200) {
  //     var jsonRespStatus = json.decode(response.body)['status'];
  //     var jsonRespData = json.decode(response.body)['data'];

  //     return [jsonRespStatus, jsonRespData];
  //   } else {
  //     throw Exception("Gagal mengambil data");
  //   }
  // }

  //TODO: Get detail dan form pemasukan Kegiatan
  Future getPemasukanDetail(kodeGerejaDetail, kodeKegiatanDetail) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pemasukan-kegiatan?kode_gereja=$kodeGerejaDetail&kode_kegiatan=$kodeKegiatanDetail"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get detail dan form pengeluaran Kegiatan
  Future getPengeluaranForm(kodeGerejaDetail, kodeKegiatanDetail) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-all-pengeluaran-kegiatan?kode_gereja=$kodeGerejaDetail&kode_kegiatan=$kodeKegiatanDetail"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get kode Perkiraan
  Future getKodePerkiraanSingleKegiatanBudgeting(kodeGereja, kodeMaster) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kode-perkiraan-budgeting?header_kode_perkiraan=$kodeMaster&kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get tanggal absen
  Future getTanggalAbsen(kodeGereja, kodeKegiatan) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}tanggal-absen?kode_kegiatan=$kodeKegiatan&kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get user absensi
  Future getUserAbsen(kodeGereja, kodeKegiatan, tanggals) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}user-absensi?kode_kegiatan=$kodeKegiatan&kode_gereja=$kodeGereja&tanggal=$tanggals"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: update user absens
  Future updateUserAbsensi(kodeGereja, kodeKegiatan, tanggalAbsen, kodeUser,
      statusUserAbsensi) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}input-user-absensi?kode_gereja=$kodeGereja&kode_kegiatan=$kodeKegiatan&tanggal_absensi=$tanggalAbsen&kode_user=$kodeUser&status_user_absensi=$statusUserAbsensi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengupdate data");
    }
  }

  //TODO: get masuk akal
  Future getMasukAkal(kodeMasterAkal, kodeGerejaAkal, kodePerkiraanAkal) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}masuk-akal?header_kode_perkiraan=$kodeMasterAkal&kode_gereja=$kodeGerejaAkal&kode_perkiraan=$kodePerkiraanAkal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get Page Role
  Future getPageRole(kodeGerejaPage, namaPagePage) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}page-role?kode_gereja=$kodeGerejaPage&page_name=$namaPagePage"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input Page Role
  Future inputUpdatePageRole(kodeGereja, namaPage, rolePage) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-page-role?kode_gereja=$kodeGereja&page_name=$namaPage&role_user=$rolePage"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get Page Role
  Future getPageAccess(kodeGereja, namaPage, userRole) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}checking-page-role?kode_gereja=$kodeGereja&page_name=$namaPage&user_role=$userRole"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: update status riwayat
  Future updateStatusRiwayat(kodeKegGab) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}update-status-kegiatan?kode_kegiatan_gabungan=$kodeKegGab"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengupdate data");
    }
  }
}


// //Function di Flutter
// Future<String?> uploadImage(file, id) async {
//     String url = "http://keraton.crossnet.co.id:8080/upload?id=" + id;
//     var request = http.MultipartRequest('POST', Uri.parse(url));
//     request.files.add(await http.MultipartFile.fromPath('photo', file));
//     var res = await request.send();
//     return res.reasonPhrase;
//   }

// //Cara Panggil
// var file = await picker.pickImage(source: ImageSource.gallery);
// var res = await uploadImage(file!.path, global.id.toString());

// //Update Foto --> Tinggal menumpuk dengan nama file yang sama otomatis akan ke overwrite
// var file = await picker.pickImage(source: ImageSource.gallery);
// var res = await uploadImage(file!.path, global.id.toString());