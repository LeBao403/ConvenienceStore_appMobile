import 'package:cua_hang_tien_loi/model/danh_gia.dart';
import 'package:cua_hang_tien_loi/model/danh_muc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<List<DanhMuc>> fetchDanhMucList() async {
  try {
    final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/DanhMuc'));
    print('Response body: ${response.body}'); // In JSON để debug

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      // Kiểm tra nếu JSON là danh sách trực tiếp
      if (jsonData is List) {
        return jsonData.map((item) => DanhMuc.fromJson(item)).toList();
      }
      // Kiểm tra nếu JSON có key "data"
      else if (jsonData is Map<String, dynamic> && jsonData['success'] == true) {
        final List<dynamic> data = jsonData['data'];
        return data.map((item) => DanhMuc.fromJson(item)).toList();
      } else {
        throw Exception('API returned success: false or invalid format - ${jsonData['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception('Failed to load sản phẩm - Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e'); // In lỗi để debug
    throw Exception('Error fetching sản phẩm: $e');
  }
}

