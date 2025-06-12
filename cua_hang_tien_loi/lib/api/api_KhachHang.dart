import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://10.0.2.2:7199/api/KhachHang';

  Future<Map<String, dynamic>> login(String sdt, String matKhau) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'sdt': sdt, 'matKhau': matKhau}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<Map<String, dynamic>> register(String sdt, String matKhau, String tenKH) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'SDT': sdt,
          'MATKHAU': matKhau,
          'TENKH': tenKH,
          'DIACHI': null,
          'GIOITINH': null,
          'HINHANH': null,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  Future<Map<String, dynamic>> getKhachHangById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load customer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching customer: $e');
    }
  }

  Future<Map<String, dynamic>> updateKhachHang(int id, Map<String, dynamic> data) async {
    try {
      final updatedData = {
        'MAKH': id,
        'SDT': data['sdt'],
        'MATKHAU': data['matkhau'],
        'TENKH': data['tenkh'],
        'DIACHI': data['diachi'],
        'GIOITINH': data['gioitinh'],
        'HINHANH': data['hinhanh'],
      };
      print('API Request Data: $updatedData'); // Log dữ liệu gửi lên
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update customer: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating customer: $e');
    }
  }
}