import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/model_cart.dart';
import 'package:cua_hang_tien_loi/api/api_gio_hang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartHelper {
  static final ApiGioHang _apiGioHang = ApiGioHang();

  static Future<void> themVaoGioHang(BuildContext context, int maSP, int soLuong) async {
    String? maKH;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      maKH = prefs.getString('maKH');

      if (maKH == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8),
                Text('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng'),
              ],
            ),
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 16),
                  Text('Đang thêm vào giỏ hàng...'),
                ],
              ),
            ),
          ),
        ),
      );

      final gioHang = GioHang(
        maKH: int.parse(maKH),
        maSP: maSP,
        soLuong: soLuong,
      );

      final response = await _apiGioHang.themSanPham(gioHang);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                response['success'] == true ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(response['message']),
            ],
          ),
          backgroundColor: response['success'] == true ? Colors.green : Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Text('Lỗi: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}