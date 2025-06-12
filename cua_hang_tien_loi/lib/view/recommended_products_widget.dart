import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/san_pham.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cua_hang_tien_loi/view/chi_tiet_san_pham.dart';

class RecommendedProductsWidget extends StatefulWidget {
  final int masp;

  const RecommendedProductsWidget({Key? key, required this.masp}) : super(key: key);

  @override
  _RecommendedProductsWidgetState createState() => _RecommendedProductsWidgetState();
}

class _RecommendedProductsWidgetState extends State<RecommendedProductsWidget> {
  late Future<List<SanPham>> _recommendedProductsFuture;

  @override
  void initState() {
    super.initState();
    _recommendedProductsFuture = _fetchRecommendedProducts();
  }

  Future<List<SanPham>> _fetchRecommendedProducts() async {
    List<Map<String, dynamic>> rules = await _loadRulesFromCsv();
    List<int> recommendedMasp = _getRecommendedMasp(widget.masp, rules);

    List<SanPham> recommendedProducts = [];
    for (int masp in recommendedMasp) {
      try {
        SanPham? product = await getSanPhamById(masp); 
        if (product != null) {
          recommendedProducts.add(product);
        }
      } catch (e) {
        print('Lỗi khi lấy sản phẩm gợi ý: $e');
      }
    }
    return recommendedProducts;
  }

  Future<List<Map<String, dynamic>>> _loadRulesFromCsv() async {
    String csvString = await DefaultAssetBundle.of(context).loadString('assets/association_rules.csv');
    
    List<Map<String, dynamic>> rules = [];
    List<String> lines = const LineSplitter().convert(csvString);
    bool isFirstLine = true;
    for (String line in lines) {
      if (isFirstLine) {
        isFirstLine = false;
        continue;
      }
      List<String> parts = line.split(',');
      if (parts.length == 4) {
        List<int> antecedent = _parseItemList(parts[0]);
        List<int> consequent = _parseItemList(parts[1]);
        rules.add({
          'antecedent': antecedent,
          'consequent': consequent,
          'support': int.parse(parts[2]),
          'confidence': double.parse(parts[3]),
        });
      }
    }
    return rules;
  }

  List<int> _parseItemList(String itemString) {
    String cleaned = itemString.trim().replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
    if (cleaned.isEmpty) return [];
    List<String> items = cleaned.split(',');
    return items.map((item) => int.parse(item.trim())).toList();
  }

  List<int> _getRecommendedMasp(int masp, List<Map<String, dynamic>> rules) {
    List<int> recommendedMasp = [];
    for (var rule in rules) {
      if (rule['antecedent'].length == 1 && rule['antecedent'][0] == masp) {
        int recommended = rule['consequent'][0];
        if (!recommendedMasp.contains(recommended)) {
          recommendedMasp.add(recommended);
        }
      }
    }
    return recommendedMasp;
  }

  Future<SanPham?> getSanPhamById(int masp) async {
    try {
      final response = await http.get(Uri.parse('https://10.0.2.2:7199/api/Product/$masp'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          return SanPham.fromJson(jsonData['data']);
        } else {
          throw Exception('API returned success: false or no data - ${jsonData['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load sản phẩm - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sản phẩm by ID: $e');
      return null;
    }
  }

  Widget _buildProductCard(SanPham product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChiTietSanPhamScreen(
              sanPham: product,
              maTK: null,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh với kích thước cố định
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                width: double.infinity,
                height: 120, // Chiều cao cố định
                child: Image.network(
                  product.anh1 ?? 'https://res.cloudinary.com/degzytdz5/image/upload/v1748762590/LoiHinhAnh_mkrxx9.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
            // Thông tin sản phẩm với chiều cao cố định
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.tensp ?? 'Không có tên',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.giaban ?? 0} ₫',
                      style: const TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '🛍️ Sản phẩm gợi ý',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<List<SanPham>>(
          future: _recommendedProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Lỗi: ${snapshot.error}'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Không có sản phẩm gợi ý nào.'),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 card mỗi hàng
                    crossAxisSpacing: 12, // Khoảng cách ngang
                    mainAxisSpacing: 12, // Khoảng cách dọc
                    childAspectRatio: 0.75, 
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(snapshot.data![index]);
                  },
                ),
              );
            }
          },
        ),
        const SizedBox(height: 16), 
      ],
    );
  }
}