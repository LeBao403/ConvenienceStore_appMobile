import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cua_hang_tien_loi/model/model_cartDetail.dart';

// Hàm lấy maGH từ maKH thông qua API
Future<int?> fetchMaGHFromMaKH(int maKH) async {
  try {
    final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/GioHang/getMaGHByMaKH/$maKH'));
    print('Response body for maGH: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        return jsonData['data'] as int?;
      } else {
        throw Exception('Không tìm thấy giỏ hàng: ${jsonData['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception('Failed to fetch maGH - Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching maGH: $e');
    throw Exception('Error fetching maGH: $e');
  }
}

Future<List<ChiTietGioHang>> fetchGioHang(int maKH) async {
    try {
final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/GioHang/$maKH'));
      print('Response body: ${response.body}'); // In JSON để debug

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData is List) {
          return jsonData.map((item) => ChiTietGioHang.fromJson(item)).toList();
        }
        else if (jsonData is Map<String, dynamic> && jsonData['success'] == true) {
          final List<dynamic> data = jsonData['data'];
          return data.map((item) => ChiTietGioHang.fromJson(item)).toList();
        } else {
          throw Exception('API returned success: false or invalid format - ${jsonData['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load sản phẩm - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); 
  throw Exception('Error fetching sản phẩm: $e');
    }
  }

//Cập nhật số lượng sản phẩm trong giỏ hàng
Future<bool> updateSoLuong(int maKH, int maSP, int soLuong) async {
  final url = Uri.parse('https://10.0.2.2:7199/api/GioHang/capnhat-soluong');
int? maGH = await fetchMaGHFromMaKH(maKH);
  if (maGH == null) {
    throw Exception('Không tìm thấy giỏ hàng để cập nhật');
  }
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'maGH': maGH, // Giả sử maGH là 1, bạn có thể thay đổi theo yêu cầu
      'maSP': maSP,
      'soLuong': soLuong,
    }),
  );

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return body['success'] == true;
  } else {
    throw Exception('Cập nhật số lượng thất bại');
  }
}


// Xóa sản phẩm trong giỏ hàng
Future<bool> deleteSanPhamTrongGioHang(int maKH, int maSP) async {
  // Lấy maGH từ maKH
  int? maGH = await fetchMaGHFromMaKH(maKH);
  if (maGH == null) {
    throw Exception('Không tìm thấy giỏ hàng để xóa');
  }
  final response = await http.delete(
    Uri.parse('https://10.0.2.2:7199/api/GioHang/xoa?maGH=$maGH&maSP=$maSP'),
  );

  return response.statusCode == 200;
}