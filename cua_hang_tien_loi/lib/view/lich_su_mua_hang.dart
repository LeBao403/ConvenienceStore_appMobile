import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/model_order.dart';
import '../api/api_services_DonHang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LichSuaMuaHang extends StatefulWidget {
  final int maKH;
  const LichSuaMuaHang({super.key, required this.maKH});

  @override
  State<LichSuaMuaHang> createState() => _LichSuaMuaHangState();
}

class _LichSuaMuaHangState extends State<LichSuaMuaHang> {
  List<DonHangGroup> donHangList = [];
  String? maKH;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadMaKH();
    await _loadDonHang();
  }

  Future<void> _loadMaKH() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => maKH = prefs.getString('maKH'));
  }

  Future<void> _loadDonHang() async {
    try {
      final customerID = maKH != null ? int.parse(maKH!) : widget.maKH;
      final orders = await fetchLichSuMuaHang(customerID);
      
      setState(() {
        donHangList = groupDonHang(orders);
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi tải đơn hàng: $e');
      setState(() => isLoading = false);
    }
  }

  void _showOrderDetail(DonHangGroup order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đơn hàng #${order.maDH}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOrderInfo(order),
              const Divider(),
              _buildProductList(order.sanPhams),
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

  Widget _buildOrderInfo(DonHangGroup order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📅 ${order.ngayDat}'),
        Text('💰 ${order.thanhTien} đ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('💳 ${order.trangThaiTT}'),
        Text('🚚 ${order.trangThaiGH}'),
      ],
    );
  }

  Widget _buildProductList(List<Map<String, dynamic>> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📦 Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...products.map((sp) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  sp['anh'] ?? '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(sp['tenSP'] ?? 'Sản phẩm')),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildOrderCard(DonHangGroup order) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showOrderDetail(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Đơn #${order.maDH}', 
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(order.ngayDat, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 8),
              Text('💰 ${order.thanhTien} đ', 
                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green)),
              const SizedBox(height: 4),
              Row(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue[50],
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Text(order.trangThaiTT ?? '', style: TextStyle(fontSize: 12, color: Colors.blue[700])),
                  // ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(order.trangThaiGH ?? '', style: TextStyle(fontSize: 12, color: Colors.orange[700])),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử mua hàng'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : donHangList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Chưa có đơn hàng nào', 
                           style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: donHangList.length,
                  itemBuilder: (context, index) => _buildOrderCard(donHangList[index]),
                ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Khuyến mãi'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Quét mã'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        onTap: (index) {
          // Xử lý navigation
        },
      ),
    );
  }
}