import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/model_order.dart';
import '../api/api_services_DonHang.dart';
import 'lich_su_mua_hang.dart';
import 'orderstatustimeline.dart';
import '../view/HomePage.dart'; 
import '../view/SettingPage.dart'; 

class OrderScreen extends StatefulWidget {
  final int maKH;
  const OrderScreen({super.key, required this.maKH});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<DonHangGroup> donHangList = [];
  bool isLoading = true;
  final steps = [
    'Đang chờ',
    'Đang xử lý',
    'Đang giao',
    'Hoàn thành',
  ];

  @override
  void initState() {
    super.initState();
    loadDonHang();
  }

  void loadDonHang() async {
    try {
      List<DonHang> list = await fetchTheoDoiDonHang(widget.maKH);
      setState(() {
        donHangList = groupDonHang(list);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _confirmDaNhanHang(int maDH) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn đã nhận được hàng?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xác nhận')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await updateTrangThaiGiaoHang(maDH, 'Hoàn thành');
        loadDonHang(); // Reload lại danh sách
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi cập nhật trạng thái: $e')),
        );
      }
    }
  }

  void _cancelOrder(int maDH) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xác nhận')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await updateTrangThaiGiaoHang(maDH, 'Đã hủy');
        loadDonHang(); // Reload lại danh sách
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi cập nhật trạng thái: $e')),
        );
      }
    }
  }

  void _showOrderDetail(DonHangGroup order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết đơn hàng #${order.maDH}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('Ngày đặt: ${order.ngayDat}'),
              Text('Tổng tiền: ${order.thanhTien} đ'),
              Text('Trạng thái thanh toán: ${order.trangThaiTT}'),
              Text('Trạng thái giao hàng: ${order.trangThaiGH}'),
              const SizedBox(height: 8),
              const Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...order.sanPhams.map<Widget>((sp) => Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      sp['anh'] ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 50),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('- ${sp['tenSP']}', style: const TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      child: Text('- Số lượng: ${sp['soLuong']}', style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : donHangList.isEmpty
              ? const Center(child: Text("Không có đơn hàng"))
              : ListView.builder(
                  itemCount: donHangList.length,
                  itemBuilder: (context, index) {
                    final order = donHangList[index];
                    return GestureDetector(
                      onTap: () => _showOrderDetail(order),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OrderStatusTimeline(
                                steps: steps,
                                currentStatus: order.trangThaiGH!,
                              ),
                              Text('Mã đơn hàng: ${order.maDH}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Ngày đặt: ${order.ngayDat}'),
                              Text('Tổng tiền: ${order.thanhTien} đ'),
                              Text('Trạng thái thanh toán: ${order.trangThaiTT}'),
                              Text('Trạng thái giao hàng: ${order.trangThaiGH}'),
                              const SizedBox(height: 8),
                              const Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
                              ...order.sanPhams.map<Widget>((sp) => Padding(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      sp['anh'] ?? '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported, size: 50),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text('- ${sp['tenSP']}', style: const TextStyle(fontSize: 14)),
                                    ),
                                  ],
                                ),
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Liên hệ nhân viên: 0387190127', style: const TextStyle(fontSize: 12)),
                                  if (order.trangThaiGH == 'Đang chờ')
                                    ElevatedButton(
                                      onPressed: () => _cancelOrder(order.maDH),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        side: const BorderSide(color: Colors.black),
                                      ),
                                      child: const Text('Hủy đơn', style: TextStyle(color: Colors.black)),
                                    ),
                                  if (order.trangThaiGH == 'Đang giao')
                                    ElevatedButton(
                                      onPressed: () => _confirmDaNhanHang(order.maDH),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightBlue,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      child: const Text('Đã nhận hàng', style: TextStyle(color: Colors.black)),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Khuyến mãi'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Quét tích điểm'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        ],
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 3) {
            // Ở lại trang đơn hàng
            return;
          } else if (index == 0) {
            // Điều hướng về HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 4) {
            // Điều hướng về trang User (SettingsPage)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          } else {
            // TODO: Xử lý các tab khác (Khuyến mãi, Quét tích điểm)
            print('Tab $index chưa được triển khai');
          }
        },
      ),
    );
  }
}