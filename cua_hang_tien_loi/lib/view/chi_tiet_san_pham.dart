import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/san_pham.dart';
import 'package:cua_hang_tien_loi/ultils/layout_chung.dart';
import 'package:cua_hang_tien_loi/model/danh_gia.dart';
import 'package:cua_hang_tien_loi/api/api_danh_gia.dart';
import 'package:cua_hang_tien_loi/view/from_danh_gia.dart';
import 'package:cua_hang_tien_loi/api/api_gio_hang.dart';
import 'package:cua_hang_tien_loi/model/model_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cua_hang_tien_loi/view/recommended_products_widget.dart';
import 'package:cua_hang_tien_loi/ultils/cart_helper.dart'; // Import mới

class ChiTietSanPhamScreen extends StatefulWidget {
  final SanPham sanPham;
  final int? maTK;

  const ChiTietSanPhamScreen({Key? key, required this.sanPham, this.maTK}) : super(key: key);

  @override
  _ChiTietSanPhamScreenState createState() => _ChiTietSanPhamScreenState();
}

class _ChiTietSanPhamScreenState extends State<ChiTietSanPhamScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<DanhGia>> _danhGiaFuture;
  int _quantity = 1;
  final ApiGioHang _apiGioHang = ApiGioHang();
  String? maKH;
  bool isCheckingLogin = true;

  @override
  void initState() {
    super.initState();
    _danhGiaFuture = fetchDanhGiaSanPham(widget.sanPham.masp!);
    _loadMaKH();
  }

  Future<void> _loadMaKH() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maKH = prefs.getString('maKH');
      isCheckingLogin = false;
    });
  }

  void _refreshReviews() {
    setState(() {
      _danhGiaFuture = fetchDanhGiaSanPham(widget.sanPham.masp!);
    });
  }

  void _increaseQuantity() {
    setState(() {
      if (_quantity < (widget.sanPham.soluongton ?? 0)) {
        _quantity++;
      }
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  // Thay bằng lời gọi hàm tĩnh từ CartHelper
  void _themVaoGioHang() {
    CartHelper.themVaoGioHang(context, widget.sanPham.masp!, _quantity);
  }

  String _getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return 'https://res.cloudinary.com/degzytdz5/image/upload/v1748762590/LoiHinhAnh_mkrxx9.jpg';
    }
    return imageUrl.trim();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      _getImageUrl(widget.sanPham.anh1),
      _getImageUrl(widget.sanPham.anh2),
      _getImageUrl(widget.sanPham.anh3),
    ].where((url) => url.isNotEmpty).toList();

    if (imageUrls.isEmpty) {
      imageUrls.add('https://res.cloudinary.com/degzytdz5/image/upload/v1748762590/LoiHinhAnh_mkrxx9.jpg');
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildCommonAppBar(
        context: context,
        searchController: _searchController,
        title: widget.sanPham.tensp ?? 'Chi tiết sản phẩm',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageUrls.isNotEmpty
                    ? PageView.builder(
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            imageUrls[index],
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator(color: Colors.green));
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.error, size: 50, color: Colors.grey),
                              );
                            },
                          );
                        },
                      )
                    : const Icon(Icons.error, size: 100),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Thông tin sản phẩm
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sanPham.tensp ?? 'Không có tên sản phẩm',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Mã SP: ${widget.sanPham.masp}', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green, size: 20),
                        Text(
                          '${widget.sanPham.giaban ?? 0} VND',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.inventory, color: Colors.blue, size: 18),
                        const SizedBox(width: 4),
                        Text('Còn lại: ${widget.sanPham.soluongton ?? 0}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    Text('Mô tả: ${widget.sanPham.mota ?? 'Không có mô tả'}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Chọn số lượng
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Số lượng: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _decreaseQuantity,
                        icon: const Icon(Icons.remove, color: Colors.grey),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _increaseQuantity,
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Nút thêm vào giỏ hàng
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _themVaoGioHang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Thêm vào giỏ hàng', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Gợi ý sản phẩm
            RecommendedProductsWidget(masp: widget.sanPham.masp!),

            const SizedBox(height: 24),
            
            // Phần đánh giá
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReviewForm(
                      maSP: widget.sanPham.masp!,
                      maTK: maKH != null ? int.parse(maKH!) : 4,
                      onReviewSubmitted: _refreshReviews,
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Đánh giá sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<List<DanhGia>>(
                      future: _danhGiaFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.green));
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Chưa có đánh giá nào cho sản phẩm này.'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final danhGia = snapshot.data![index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(5, (i) => Icon(
                                            i < (danhGia.soSao ?? 0) ? Icons.star : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          )),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          danhGia.tenKH ?? 'Người dùng',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        Text('${danhGia.soSao ?? 0}/5'),
                                        const Spacer(),
                                        Text(
                                          danhGia.ngayDanhGia != null
                                              ? '${danhGia.ngayDanhGia!.day}/${danhGia.ngayDanhGia!.month}/${danhGia.ngayDanhGia!.year}'
                                              : 'Không rõ ngày',
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(danhGia.binhLuan ?? 'Không có bình luận'),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}