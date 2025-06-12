import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cua_hang_tien_loi/model/model_cart.dart';

class ApiGioHang {
  static const String baseUrl = 'https://10.0.2.2:7199/api/GioHang'; // URL API của bạn

Future<Map<String, dynamic>> themSanPham(GioHang gioHang) async {
  print('Gửi yêu cầu đến API: ${jsonEncode(gioHang.toJson())}');
  final response = await http.post(
    Uri.parse('$baseUrl/them'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(gioHang.toJson()),
  );

  print('Mã trạng thái HTTP: ${response.statusCode}');
  print('Phản hồi API: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    return jsonDecode(response.body); // Giả sử 400 trả về JSON lỗi
  } else {
    throw Exception('Lỗi khi gọi API: ${response.statusCode}, Nội dung: ${response.body}');
  }
}
}

