import 'dart:io';
import 'package:cua_hang_tien_loi/api/my_class_https_drive.dart';
import 'package:cua_hang_tien_loi/view/SettingPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cua_hang_tien_loi/api/api_san_pham.dart';
import 'package:cua_hang_tien_loi/model/san_pham.dart';
import 'package:cua_hang_tien_loi/view/tim_kiem.dart';
import 'package:cua_hang_tien_loi/api/api_danh_muc.dart';
import 'package:cua_hang_tien_loi/model/danh_muc.dart';
import 'package:cua_hang_tien_loi/view/view_san_pham_theo_danh_muc.dart';
import 'package:cua_hang_tien_loi/view/chi_tiet_san_pham.dart';
import 'package:cua_hang_tien_loi/ultils/layout_chung.dart';
import 'package:cua_hang_tien_loi/ultils/theme_constants.dart';
import 'package:cua_hang_tien_loi/view/ProfileDetail.dart';
import 'package:cua_hang_tien_loi/view/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cua_hang_tien_loi/view/order_screen.dart';
import 'package:cua_hang_tien_loi/ultils/cart_helper.dart'; 
import 'login.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cửa Hàng Tiện Lợi',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String? maKH;
  bool isCheckingLogin = true;

  int selectedCategoryIndex = 0;
  int selectedTabIndex = 0;

  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  List<String> _productImages = [];
  Timer? _bannerTimer;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _startBannerAutoScroll();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maKH = prefs.getString('maKH');
      isCheckingLogin = false;
    });
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_productImages.isEmpty) return;

      if (_currentPage < _productImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _bannerTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() async {
    final tukhoa = _searchController.text.trim();
    if (tukhoa.isNotEmpty) {
      final results = await fetchSanPhamListSearch(tukhoa);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(results: results),
        ),
      );
    }
  }

  IconData _getIconForCategory(String? tendm, int? madm) {
    switch (tendm?.toLowerCase() ?? madm.toString()) {
      case 'nước giải khát':
      case '1':
        return Icons.local_drink_outlined;
      case 'sữa':
      case '2':
        return Icons.local_cafe_outlined;
      case 'củ quả':
      case '3':
        return Icons.eco_outlined;
      case 'trái cây tươi':
      case '4':
        return Icons.local_grocery_store_outlined;
      case 'thức phẩm khô':
      case '5':
        return Icons.restaurant_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  void _onCategoryTap(int maDM, String tenDM, int index) {
    setState(() {
      selectedCategoryIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsPage(maDM: maDM, tenDM: tenDM),
      ),
    );
  }

  void _onProductTap(SanPham sanPham) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChiTietSanPhamScreen(sanPham: sanPham),
      ),
    );
  }

  void _onAddToCart(SanPham sanPham) {
    CartHelper.themVaoGioHang(context, sanPham.masp!, 1); 
  }

  Widget buildBannerCarousel({
    required List<String> images,
    required PageController pageController,
    required int currentPage,
  }) {
    if (images.isEmpty) {
      return Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: AppShadows.medium,
        ),
        child: const Center(
          child: Text(
            'Không có banner để hiển thị',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    print('Lỗi tải hình ảnh: $url, error: $error');
                    return const Center(
                      child: Text(
                        'Lỗi tải hình',
                        style: AppTextStyles.bodyMedium,
                      ),
                    );
                  },
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index ? AppColors.primary : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildCommonAppBar(
        context: context,
        searchController: _searchController,
        onSearch: _onSearch,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Categories Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Text(
                          'Danh mục sản phẩm',
                          style: AppTextStyles.h3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 100,
                        child: FutureBuilder<List<DanhMuc>>(
                          future: fetchDanhMucList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final danhMucList = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                                itemCount: danhMucList.length,
                                itemBuilder: (context, index) {
                                  final danhMuc = danhMucList[index];
                                  return buildCategoryItem(
                                    icon: _getIconForCategory(danhMuc.tenDM, danhMuc.maDM),
                                    label: danhMuc.tenDM ?? 'Không có tên',
                                    onTap: () => _onCategoryTap(
                                      danhMuc.maDM ?? 0,
                                      danhMuc.tenDM ?? 'Không có tên',
                                      index,
                                    ),
                                    isSelected: selectedCategoryIndex == index,
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              print('Lỗi tải danh mục: ${snapshot.error}');
                              return buildErrorWidget('Không thể tải danh mục: ${snapshot.error}');
                            }
                            return buildLoadingWidget();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Banner Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: FutureBuilder<List<SanPham>>(
                    future: fetchSanPhamList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final sanPhamList = snapshot.data!.toList();
                        _productImages = sanPhamList
                            .where((sp) => sp.anh1 != null && sp.anh1!.isNotEmpty)
                            .map((sp) => sp.anh1!)
                            .take(5)
                            .toList();
                        print('Product Images: $_productImages');
                        return buildBannerCarousel(
                          images: _productImages,
                          pageController: _pageController,
                          currentPage: _currentPage,
                        );
                      } else if (snapshot.hasError) {
                        print('Lỗi tải banner: ${snapshot.error}');
                        return buildErrorWidget('Không thể tải banner: ${snapshot.error}');
                      }
                      return Container(
                        height: 180,
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: buildLoadingWidget(),
                      );
                    },
                  ),
                ),
              ),

              // Promotion Section Header
              SliverToBoxAdapter(
                child: buildSectionHeader(
                  title: 'KHUYẾN MÃI HOT',
                  subtitle: 'Giá tốt nhất cho bạn',
                  onSeeMore: () {
                  },
                ),
              ),

              // Products Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                sliver: FutureBuilder<List<SanPham>>(
                  future: fetchSanPhamList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final sanPhamList = snapshot.data!.toList();
                      return SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.sm,
                          mainAxisSpacing: AppSpacing.sm,
                          childAspectRatio: 0.65,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final sp = sanPhamList[index];
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 200 + (index * 100)),
                              curve: Curves.easeOutBack,
                              child: buildProductCard(
                                sanPham: sp,
                                onTap: () => _onProductTap(sp),
                                onAddToCart: () => _onAddToCart(sp),
                              ),
                            );
                          },
                          childCount: sanPhamList.length,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print('Lỗi tải sản phẩm: ${snapshot.error}');
                      return SliverFillRemaining(
                        child: buildErrorWidget('Không thể tải sản phẩm: ${snapshot.error}'),
                      );
                    }
                    return SliverFillRemaining(
                      child: buildLoadingWidget(),
                    );
                  },
                ),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildCommonBottomNavBar(
        currentIndex: selectedTabIndex,
        onTap: (index) {
          setState(() {
            selectedTabIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 1:
              break;
            case 2:
              // TODO: Navigate to QR scanner
              break;
            case 3:
              if (maKH != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderScreen(maKH: int.parse(maKH!))),
                );
              }
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (maKH == null) {
            _showLoginDialog();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Cart()),
            );
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Yêu cầu đăng nhập",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text("Bạn cần đăng nhập để xem giỏ hàng. Bạn có muốn đăng nhập ngay bây giờ không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Hủy",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Đăng nhập",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}