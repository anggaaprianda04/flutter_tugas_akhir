// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_tugas_akhir/models/toko_model.dart';
import 'package:flutter_tugas_akhir/services/service.dart';
import 'package:http/http.dart' as http;

class TokoService {
  var dio = Dio();

  Future<TokoModel> fetchProfileToko({required int id}) async {
    try {
      var response = await http.get(Uri.parse(Service.apiUrl + '/market/$id'));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return TokoModel.fromJson(data);
      } else {
        throw Exception('Gagal ambil data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<TokoModel> updateProfileToko({
    required int id,
    required int usersId,
    required String nameStore,
    required String village,
    required String address,
    required String description,
    required String accountName,
    required int accountNumber,
    // required File image,
  }) async {
    try {
      var body = jsonEncode(
        {
          'users_id': usersId,
          'name_store': nameStore,
          'village': village,
          'address': address,
          'description': description,
          'account_name': accountName,
          'account_number': accountNumber
        },
      );
      var response =
          await dio.put(Service.apiUrl + '/updateMarket/$id', data: body);
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        return TokoModel.fromJson(response.data['data']);
      } else {
        throw Exception('Gagal update toko');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> uploadPhotoMarket(
      {required File file, required TokoModel tokoModel}) async {
    try {
      if (file == null) return;
      String filename = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: filename)
      });
      var response =
          await dio.post(Service.apiUrl + '/uploadPhotoMarket/${tokoModel.id}',
              options: Options(
                headers: {"Accept": "application/json;utf-8"},
                followRedirects: false,
                validateStatus: (status) => true,
              ),
              data: formData);
      if (response.statusCode == 200) {
        return TokoModel.fromJson(response.data['data']['image']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<TokoModel> createToko({
    required int usersId,
    required String nameStore,
    required String village,
    required String address,
    required String description,
    required String accountName,
    required int accountNumber,
  }) async {
    try {
      FormData formData = FormData.fromMap(
        {
          'users_id': usersId,
          'name_store': nameStore,
          'village': village,
          'address': address,
          'description': description,
          'account_name': accountName,
          'account_number': accountNumber,
        },
      );
      var response = await dio.post(Service.apiUrl + '/createMarket',
          options: Options(
            headers: {"Accept": "application/json;utf-8"},
            followRedirects: false,
            validateStatus: (status) => true,
          ),
          data: formData);
      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return TokoModel.fromJson(response.data['data']);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}