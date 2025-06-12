import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/view/confirmation_page.dart';
import 'package:cua_hang_tien_loi/model/model_cartDetail.dart';
import '../api/api_services_GioHang.dart';
import 'addresspage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String? maKH; 
  //int? maGH; // Thêm biến maGH
  bool isCheckingLogin = true; 

  ChiTietGioHang? gioHang;
  bool isLoading = true;
  List<ChiTietGioHang> cartItems = [];
  ShippingMethod _shippingMethod = ShippingMethod.delivery;

  @override
  void initState() {
    super.initState();
    _loadMaKH(); 
  }

  Future<void> _loadMaKH() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maKH = prefs.getString('maKH');
      isCheckingLogin = false; // Đã load xong maKH
    });

    if (maKH != null) {
      loadData(); // Chỉ load dữ liệu giỏ hàng nếu có maKH
    }
  }

  void loadData() async {
    try {
      if (maKH == null) return; // Không load nếu không có maKH
      List<ChiTietGioHang> gh = await fetchGioHang(int.parse(maKH!)); // Dùng maKH
      setState(() {
        gioHang = gh.isNotEmpty ? gh.first : null;
       // maGH = gh.isNotEmpty ? gh.first.maGH : null;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading cart: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCheckingLogin) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Nếu không có maKH, không nên vào được Cart (đã kiểm soát ở HomePage)
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.green,
        toolbarHeight: 80,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : gioHang == null
              ? Center(child: Text("Không có sản phẩm trong giỏ hàng"))
              : FutureBuilder<List<ChiTietGioHang>>(
                  future: fetchGioHang(int.parse(maKH!)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final sanPhamList = snapshot.data!;
                      final double tongTien = sanPhamList.fold(0, (tong, item) => tong + (item.soLuong! * item.giaBan!));
                      return Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.arrow_back, color: Colors.black),
                                //   onPressed: () => Navigator.of(context).pop(),
                                // ),
                                // Expanded(
                                //   child: Center(
                                //     child: Text(
                                //       'Giỏ hàng',
                                //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(width: 48), // Để giữ cân bằng với IconButton bên trái
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: sanPhamList.length,
                              itemBuilder: (context, index) {
                                final sp = sanPhamList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        sp.anh1 ?? 'Không có ảnh',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.error, size: 50);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sp.tenSP.toString(),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text('Giá: ${sp.giaBan}₫'),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove),
                                                  onPressed: () async {
                                                    if (sp.soLuong! > 1) {
                                                      bool ok = await updateSoLuong(int.parse(maKH!) ,sp.masp!, sp.soLuong! - 1);
                                                      if (ok) loadData();
                                                    }
                                                  },
                                                ),
                                                Text('${sp.soLuong}'),
                                                IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () async {
                                                    bool ok = await updateSoLuong(int.parse(maKH!), sp.masp!, sp.soLuong! + 1);
                                                    if (ok) loadData();
                                                  },
                                                ),
                                                Text(
                                                  'Tổng: ${sp.soLuong! * sp.giaBan!}₫',
                                                  style: const TextStyle(color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          bool xacNhan = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Xác nhận xóa'),
                                              content: Text('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Hủy')),
                                                TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Xóa')),
                                              ],
                                            ),
                                          );
                                          if (xacNhan == true) {
                                            bool ok = await deleteSanPhamTrongGioHang(int.parse(maKH!), sp.masp!);
                                            if (ok) loadData();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chọn hình thức nhận hàng:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                RadioListTile<ShippingMethod>(
                                  title: const Text('Giao hàng tận nơi'),
                                  value: ShippingMethod.delivery,
                                  groupValue: _shippingMethod,
                                  onChanged: (ShippingMethod? value) {
                                    setState(() {
                                      _shippingMethod = value!;
                                    });
                                  },
                                ),
                                RadioListTile<ShippingMethod>(
                                  title: const Text('Nhận tại cửa hàng'),
                                  value: ShippingMethod.pickup,
                                  groupValue: _shippingMethod,
                                  onChanged: (ShippingMethod? value) {
                                    setState(() {
                                      _shippingMethod = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Thành tiền:',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${tongTien}₫',
                                      style: const TextStyle(fontSize: 14, color: Colors.red),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AddressPage(cartItems: sanPhamList, shippingMethod: _shippingMethod,),
                                          ),
                                        );
                                      },
                                      child: const Text('Mua hàng', style: TextStyle(fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),

                // FloatingActionButton để về HomePage
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 6,
                tooltip: 'Về trang chủ',
                child: const Icon(
                  Icons.home,
                  size: 28,
                ),
              ),
    );
  }
}