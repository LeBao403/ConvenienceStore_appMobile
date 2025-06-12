import 'dart:convert';
import 'package:cua_hang_tien_loi/view/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/model_cartDetail.dart';
import '/view/confirmation_page.dart';
import '../model/model_address.dart';

Future<void> submitOrder({
  required List<ChiTietGioHang> cartItems,
  required int maKH,
  required AddressModel selectedAddress,
  required ShippingMethod shippingMethod,
  required BuildContext context,
}) async {
  final url = Uri.parse('https://10.0.2.2:7199/api/DonHang/tao-don-hang');

  final double totalPrice = cartItems.fold(
    0,
    (sum, item) => sum + (item.giaBan! * item.soLuong!),
  );

  final List<Map<String, dynamic>> chiTiet = cartItems.map((item) {
    return {
      'maSP': item.masp,
      'soLuong': item.soLuong,
      'donGia': item.giaBan,
      'tongTien': item.tongTien,
      'maKM': null,
    };
  }).toList();

  final body = {
    'maKH': maKH, // Sử dụng tham số maKH thay vì giá trị cứng
    'pttt': 1,
    'thanhTien': shippingMethod == ShippingMethod.delivery
        ? totalPrice + ConfirmationPage.costship
        : totalPrice,
    'maCN': selectedAddress.maChiNhanh.toString(),
    'ptNhanHang': shippingMethod == ShippingMethod.delivery
        ? 'Giao tận nơi'
        : 'Nhận tại cửa hàng',
    'trangThaiGH': 'Đang chờ', // Thêm trạng thái giao hàng
    'chiTietDonHang': chiTiet,
  };

  // final response = await http.post(
  //   url,
  //   headers: {'Content-Type': 'application/json'},
  //   body: jsonEncode(body),
  // );

  // if (response.statusCode == 200) {
  //   final json = jsonDecode(response.body);
  //   print("Đặt hàng thành công: Mã đơn hàng ${json['maDH']}");
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Đặt hàng thành công!")),
  //   );
  // } else {
  //   print("Lỗi đặt hàng: ${response.body}");
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Đặt hàng thất bại!")),
  //   );
  // }
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    print("Đặt hàng thành công: Mã đơn hàng ${json['maDH']}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đặt hàng thành công!")),
    );
    final deleteResponse = await http.delete(
        Uri.parse('https://10.0.2.2:7199/api/GioHang/$maKH'));

    if (deleteResponse.statusCode == 200) {
      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
    }
  } else {
    print("Lỗi đặt hàng: ${response.body}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đặt hàng thất bại!")),
    );
  }
}
