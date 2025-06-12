import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/model_cartDetail.dart';
import 'package:cua_hang_tien_loi/model/model_address.dart';
import '/api/api_services_submitOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ShippingMethod { delivery, pickup }

class ConfirmationPage extends StatefulWidget {
  final List<ChiTietGioHang> cartItems;
  final AddressModel selectedAddress;
  final ShippingMethod shippingMethod;
  static int costship = 15000;

  const ConfirmationPage({
    Key? key,
    required this.cartItems,
    required this.selectedAddress,
    required this.shippingMethod,
  }) : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  String? maKH;
  bool isCheckingLogin = true;

  @override
  void initState() {
    super.initState();
    _loadMaKH();
  }

  Future<void> _loadMaKH() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maKH = prefs.getString('maKH');
      isCheckingLogin = false;
    });
  }

  double get totalPrice => widget.cartItems.fold(
    0,
    (sum, item) => sum + (item.giaBan! * item.soLuong!),
  );

  Future<void> _handleSubmitOrder() async {
    if (maKH == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để đặt hàng')),
      );
      return;
    }

    await submitOrder(
      cartItems: widget.cartItems,
      maKH: int.parse(maKH!), // Chuyển maKH từ String thành int
      selectedAddress: widget.selectedAddress,
      shippingMethod: widget.shippingMethod,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCheckingLogin) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final double subtotal = totalPrice;
    final double finalTotal = widget.shippingMethod == ShippingMethod.delivery
        ? subtotal + ConfirmationPage.costship
        : subtotal;

    return Scaffold(
      appBar: AppBar(title: Text('Xác nhận đơn hàng')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sản phẩm:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (_, index) {
                  final item = widget.cartItems[index];
                  return ListTile(
                    leading: Image.network(item.anh1!, width: 50, height: 50),
                    title: Text(item.tenSP!),
                    subtitle: Text('Số lượng: ${item.soLuong}'),
                    trailing: Text('${item.tongTien!.toStringAsFixed(0)}đ'),
                  );
                },
              ),
            ),
            Divider(),
            if (widget.selectedAddress.street != null &&
                widget.selectedAddress.tenXa != null &&
                widget.selectedAddress.tenHuyen != null &&
                widget.selectedAddress.tenTinh != null) ...[
              Text("Địa chỉ giao hàng:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  "${widget.selectedAddress.street}, ${widget.selectedAddress.tenXa}, ${widget.selectedAddress.tenHuyen}, ${widget.selectedAddress.tenTinh}"),
            ],
            Text("Chi nhánh cửa hàng:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${widget.selectedAddress.chiNhanh}"),
            SizedBox(height: 10),
            Text("Tổng tiền: ${totalPrice.toStringAsFixed(0)}đ", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            if (widget.shippingMethod == ShippingMethod.delivery) ...[
              Text("Phí ship: ${ConfirmationPage.costship}đ", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text("Thành tiền: ${finalTotal.toStringAsFixed(0)}đ", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
            ] else ...[
              Text("Thành tiền: ${totalPrice.toStringAsFixed(0)}đ", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
            ],
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmitOrder,
                child: Text('Đặt hàng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
