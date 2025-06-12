import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/san_pham.dart';
import 'package:cua_hang_tien_loi/api/api_san_pham.dart';


class DanhSachSanPhamPage extends StatelessWidget {
  const DanhSachSanPhamPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách sản phẩm')),
      body: FutureBuilder<List<SanPham>>(
        future: fetchSanPhamList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //final sanPhamList = snapshot.data!;
            final sanPhamList = snapshot.data!.toList(); // chỉ lấy 3 sản phẩm đầu tiên
            return ListView.builder(
              itemCount: sanPhamList.length,
              itemBuilder: (context, index) {
                final sp = sanPhamList[index];
                 String imageUrl = sp.anh1 ??'không có ảnh'; // Đây là đường dẫn ảnh từ API, ví dụ: https://cdn.tgdd.vn/Products/Images/8788/233096/bhx/xoai-keo-tui-1kg-202012311612450599.jpg
                //String imageUrl = 'https://cdn.tgdd.vn/Products/Images/8788/233096/bhx/xoai-keo-tui-1kg-202012311612450599.jpg';
// print('[' + imageUrl + ']');
// if (Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false) {
//   print(' URL hợp lệ');
// } else {
//   print(' URL KHÔNG hợp lệ');
// }

return Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image.network(
        //'https://cdn.tgdd.vn/Products/Images/8788/233096/bhx/xoai-keo-tui-1kg-202012311612450599.jpg',
        
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sp.tensp ??'không có ảnh', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Giá: ${sp.giaban} - Tồn: ${sp.soluongton}'),
          ],
        ),
      ),
    ],
  ),
);

              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
