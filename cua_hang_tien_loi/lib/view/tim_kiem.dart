import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/san_pham.dart';
import 'package:cua_hang_tien_loi/view/chi_tiet_san_pham.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cua_hang_tien_loi/ultils/theme_constants.dart';

class SearchResultsPage extends StatelessWidget {
  final List<SanPham> results;

  const SearchResultsPage({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả tìm kiếm'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: results.isEmpty
            ? const Center(
                child: Text(
                  'Không tìm thấy sản phẩm',
                  style: AppTextStyles.bodyLarge,
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Hiển thị 3 sản phẩm trên một hàng
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 0.65, // Điều chỉnh tỷ lệ để phù hợp với 3 sản phẩm
                ),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final sp = results[index];
                  final imageUrl = sp.anh1?.isNotEmpty == true ? sp.anh1! : null;
                  print('Image URL for ${sp.tensp}: $imageUrl'); // Log để kiểm tra URL

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChiTietSanPhamScreen(sanPham: sp),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppBorderRadius.md),
                                topRight: Radius.circular(AppBorderRadius.md),
                              ),
                              child: imageUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) {
                                        print('Lỗi tải hình ảnh: $url, error: $error');
                                        return const Center(
                                          child: Icon(
                                            Icons.error,
                                            size: 40, // Giảm kích thước icon để phù hợp
                                            color: AppColors.error,
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Text(
                                        'Không có ảnh',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sp.tensp ?? 'Không có tên sản phẩm',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Giá: ${sp.giaban?.toStringAsFixed(0) ?? 0} VNĐ',
                                  style: AppTextStyles.caption,
                                ),
                                Text(
                                  'Tồn: ${sp.soluongton ?? 0}',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}