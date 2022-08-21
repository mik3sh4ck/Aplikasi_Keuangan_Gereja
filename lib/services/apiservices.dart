import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dataclass/dataclass.dart';

var _linkPath = "http://cfin.crossnet.co.id:1323/";

class ServicesUser {
  Future getAllUser() async {
    final response = await http.get(
      Uri.parse("${_linkPath}user"),
    );
    if (response.statusCode == 200) {
      List jsonResp = json.decode(response.body)['data'];
      return jsonResp.map((e) => ClassUser.fromJSON(e)).toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

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

  Future getKodeGereja(kodeuser) async {
    final response = await http.get(
      Uri.parse("${_linkPath}get-kode-gereja?kode_user=$kodeuser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    }
  }
}
