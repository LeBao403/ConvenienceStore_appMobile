import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cua_hang_tien_loi/model/san_pham.dart';

// Hàm lấy danh sách sản phẩm từ API
Future<List<SanPham>> fetchSanPhamList() async {
  try {
    final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/Product'));
    //print('Response body: ${response.body}'); // In JSON để debug

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      // Kiểm tra nếu JSON là danh sách trực tiếp
      if (jsonData is List) {
        return jsonData.map((item) => SanPham.fromJson(item)).toList();
      }
      // Kiểm tra nếu JSON có key "data"
      else if (jsonData is Map<String, dynamic> && jsonData['success'] == true) {
        final List<dynamic> data = jsonData['data'];
        return data.map((item) => SanPham.fromJson(item)).toList();
      } else {
        throw Exception('API returned success: false or invalid format - ${jsonData['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception('Failed to load sản phẩm - Status code: ${response.statusCode}');
    }
  } catch (e) {
    //print('Error: $e'); // In lỗi để debug
    throw Exception('Error fetching sản phẩm: $e');
  }
}


//Danh sách sản phẩm theo từ khóa tìm kiếm
Future<List<SanPham>> fetchSanPhamListSearch(String tukhoa) async {
  try {
    final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/Product/search/$tukhoa'));
    //print('Response status: ${response.statusCode}'); // In mã trạng thái
    //print('Response body: ${response.body}'); // In nội dung phản hồi

    if (response.statusCode == 200) {
      // Parse JSON thành Map
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Kiểm tra success
      if (responseData['success'] != true) {
        throw Exception('API returned success: false - ${responseData['message'] ?? 'Unknown error'}');
      }

      // Lấy danh sách từ key 'data'
      final List<dynamic> jsonData = responseData['data'];

      // Ánh xạ danh sách thành List<SanPham>
      return jsonData.map((item) => SanPham.fromJson(item)).toList();
    } else if (response.statusCode == 400) {
      throw Exception('Vui lòng nhập từ khóa tìm kiếm');
    } else if (response.statusCode == 404) {
      return []; // Trả về danh sách rỗng nếu không tìm thấy sản phẩm
    } else {
      throw Exception('Failed to load sản phẩm - Status code: ${response.statusCode}');
    }
  } catch (e) {
    //print('Error fetching sản phẩm: $e'); // In lỗi chi tiết
    throw Exception('Error fetching sản phẩm: $e');
  }
}

// Danh sách sản phẩm theo mã danh mục
Future<List<SanPham>> fetchSanPhamDanhMuc(int maDM) async {
  try {
    final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/Product/DanhMuc/$maDM'));
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      //print('Parsed responseData: $responseData');

      if (responseData['success'] != true) {
        throw Exception('API returned success: false - ${responseData['message'] ?? 'Unknown error'}');
      }

      final dynamic data = responseData['data'];
      if (data == null) {
        throw Exception('No data field found in response');
      }
      if (data is! List) {
        throw Exception('Data field is not a list: $data');
      }
      final List<dynamic> jsonData = data;
      return jsonData.map((item) => SanPham.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load sản phẩm - Status code: ${response.statusCode}');
    }
  } catch (e) {
    //print('Error fetching sản phẩm: $e');
    throw Exception('Error fetching sản phẩm: $e');
  }
}