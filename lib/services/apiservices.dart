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

  //TODO: Login
  Future getAuth(username, password) async {
    final response = await http.get(
      Uri.parse("${_linkPath}login?username=$username&password=$password"),
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

  //TODO: get kode Perkiraan
  Future getKodePerkiraan(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}kode-perkiraan?kode_gereja=$kodeGereja"),
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
      kodeGereja, namaKodePerkiraan, kodePerkiraan) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kode-perkiraan?kode_perkiraan=$kodePerkiraan&nama_kode_perkiraan=$namaKodePerkiraan&kode_gereja=$kodeGereja"),
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
  Future deleteKodePerkiraan(kodeGereja, kodePerkiraan) async {
    final response = await http.delete(
      Uri.parse(
          "${_linkPath}delete-kode-perkiraan?kode_gereja=$kodeGereja&kode_perkiraan=$kodePerkiraan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal menghapus data");
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
      kodeGereja, namaKodeTransaksi, kodeTransaksi, status) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-kode-transaksi?kode_gereja=$kodeGereja&nama_transaksi=$namaKodeTransaksi&kode_transaksi=$kodeTransaksi&status=$status"),
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
      kodePerkiraan,
      kodeRefKegiatan,
      tanggalTransaksi,
      deskripsiTransaksi,
      nominalTransaksi) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-transaksi?kode_transaksi=$kodeTransaksi&kode_perkiraan=$kodePerkiraan&kode_gereja=$kodeGereja&kode_kegiatan=$kodeRefKegiatan&uraian_transaksi=$deskripsiTransaksi&tanggal_transaksi=$tanggalTransaksi&nominal=$nominalTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal menginput data");
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
      kodeProposalGereja, budgetKebutuhan) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}input-item-proposal-kegiatan?kode_perkiraan=$kodeItemProposalPerkiraan&kode_kegiatan=$kodeItemProposalKegiatan&kode_gereja=$kodeProposalGereja&budget_kebutuhan=$budgetKebutuhan"),
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
  Future getDetailKebutuhanKegiatan(kodeKeg, kodeGer, kodePer) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}kebutuhan-kegiatan?kode_kegiatan=$kodeKeg&kode_gereja=$kodeGer&kode_perkiraan=$kodePer"),
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
}
