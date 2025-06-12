import 'dart:convert';
import 'package:http/http.dart' as http;
import '/model/model_order_detail.dart';
import '/model/model_order.dart';

Future<List<DonHang>> fetchLichSuMuaHang(int maKH) async {
  final response = await http.get(Uri.parse("https://10.0.2.2:7199/api/DonHang/getLichSuDonHang/$maKH"));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final List<dynamic> data = jsonResponse['data'];

    return data.map((item) => DonHang.fromJson(item)).toList();
  } else {
    throw Exception('Lỗi khi tải đơn hàng');
  }
}

Future<List<DonHang>> fetchTheoDoiDonHang(int maKH) async {
  final response = await http.get(Uri.parse("https://10.0.2.2:7199/api/DonHang/theoDoiDonHang/$maKH"));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final List<dynamic> data = jsonResponse['data'];

    return data.map((item) => DonHang.fromJson(item)).toList();
  } else {
    throw Exception('Lỗi khi tải đơn hàng');
  }
}

Future<void> updateTrangThaiGiaoHang(int maDH, String newStatus) async {
  final url = Uri.parse('https://10.0.2.2:7199/api/DonHang/capnhat-trangthai');
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json', 
    },
    body: jsonEncode({                
      'maDH': maDH,
      'trangThaiGH': newStatus,
    }),
  );
  if (response.statusCode != 200) {
    throw Exception('Lỗi cập nhật trạng thái');
  }
}



Future<List<OrderDetail>> fetchChiTietDonHang(int maDH) async {
  final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/DonHang/chi-tiet/$maDH'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData['success']) {
      final List<dynamic> data = jsonData['data'];
      return data.map((item) => OrderDetail.fromJson(item)).toList();
    } else {
      throw Exception('API returned success: false - ${jsonData['message']}');
    }
  } else {
    throw Exception('Failed to load chi tiết đơn hàng - Status code: ${response.statusCode}');
  }
}