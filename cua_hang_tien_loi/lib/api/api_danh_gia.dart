// Danh sách sản phẩm theo mã danh mục
import 'package:cua_hang_tien_loi/model/danh_gia.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<DanhGia>> fetchDanhGiaSanPham(int maSP) async {
  try {
    final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/DanhGia/$maSP'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

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
      return jsonData.map((item) => DanhGia.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load đánh giá - Status code: ${response.statusCode}');
    }
  } catch (e) {
    //print('Error fetching sản phẩm: $e');
    throw Exception('Error fetching đánh giá: $e');
  }
}

// HÀM MỚI ĐỂ GỬI ĐÁNH GIÁ
Future<bool> postDanhGia(DanhGia danhGia) async {
  try {
    final response = await http.post(
      Uri.parse('https://10.0.2.2:7199/api/DanhGia'), // Endpoint để thêm đánh giá
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'maTK': danhGia.maTK, //
        'maSP': danhGia.maSP,
        'soSao': danhGia.soSao,
        'binhLuan': danhGia.binhLuan,
        'tenKH':danhGia.tenKH, // Thêm tên khách hàng nếu cần
        
        // 'ngayDanhGia' có thể được tạo ở backend hoặc gửi đi nếu cần
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) { // 200 OK or 201 Created
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['success'] ?? false; // Giả sử API trả về { "success": true/false }
    } else {
      print('Failed to post review. Status code: ${response.statusCode}, Body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error posting review: $e');
    return false;
  }
}