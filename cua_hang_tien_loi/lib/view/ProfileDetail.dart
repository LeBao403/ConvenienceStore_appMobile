import 'package:flutter/material.dart';
import '../api/api_KhachHang.dart';
import 'edit_profile_page.dart'; // Import EditProfilePage

class ProfileDetail extends StatefulWidget {
  static const routeName = "/profile-detail";
  final int customerId;

  const ProfileDetail({Key? key, required this.customerId}) : super(key: key);

  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  final ApiService apiService = ApiService();
  late Future<Map<String, dynamic>> _customerFuture;

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  void _loadCustomerData() {
    setState(() {
      _customerFuture = apiService.getKhachHangById(widget.customerId);
    });
  }

  void _navigateToEditProfile(Map<String, dynamic> customerData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(customerData: customerData),
      ),
    );

    if (result == true) {
      _loadCustomerData(); // Làm mới dữ liệu sau khi chỉnh sửa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông Tin Cá Nhân',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: () async {
              final snapshot = await _customerFuture;
              if (snapshot['success'] == true) {
                _navigateToEditProfile(snapshot['data']);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _customerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!['success']) {
            print('API Response: ${snapshot.data}');
            return Center(
                child: Text(snapshot.data?['message'] ?? 'Không tìm thấy thông tin khách hàng'));
          }

          final customerData = snapshot.data!['data'];
          print('Customer Data: $customerData');

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _getHeader(customerData['hinhanh']),
                const SizedBox(height: 24),
                _profileName(customerData['tenkh'] ?? 'Khách hàng'),
                const SizedBox(height: 8),
                _buildCustomerId(customerData['makh'].toString()),
                const SizedBox(height: 32),
                _buildSectionTitle("Thông Tin Cá Nhân"),
                const SizedBox(height: 12),
                _detailsCard(
                  customerData['tenkh'] ?? 'Chưa cập nhật',
                  customerData['sdt'] ?? 'Chưa cập nhật',
                  customerData['diachi'] ?? 'Chưa cập nhật',
                  customerData['gioitinh'] ?? 'Chưa cập nhật',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Tùy Chọn"),
                const SizedBox(height: 12),
                _buildOptionsCard(customerData),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getHeader(String? hinhAnh) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.orange[300]!, Colors.orange[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Container(
            height: 112,
            width: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: hinhAnh != null && hinhAnh.isNotEmpty
                    ? NetworkImage('https://10.0.2.2:7184/images/$hinhAnh')
                    : const NetworkImage(
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80"),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 8,
            child: InkWell(
              onTap: () {

                print("Thay đổi ảnh đại diện");
              },
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileName(String name) {
    return Text(
      name,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildCustomerId(String customerId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Text(
        'ID: $customerId',
        style: TextStyle(
          color: Colors.orange[700],
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _detailsCard(String tenKH, String sdt, String diaChi, String gioiTinh) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailItem(
            Icons.person_outline,
            "Họ và tên",
            tenKH,
            Colors.blue,
            isFirst: true,
          ),
          _buildDivider(),
          _buildDetailItem(
            Icons.phone_outlined,
            "Số điện thoại",
            sdt,
            Colors.green,
          ),
          _buildDivider(),
          _buildDetailItem(
            Icons.location_on_outlined,
            "Địa chỉ",
            diaChi,
            Colors.red,
          ),
          _buildDivider(),
          _buildDetailItem(
            Icons.transgender_outlined,
            "Giới tính",
            gioiTinh,
            Colors.purple,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsCard(Map<String, dynamic> customerData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOptionItem(
            Icons.edit_outlined,
            "Chỉnh sửa thông tin",
            Colors.orange,
            onTap: () => _navigateToEditProfile(customerData),
            isFirst: true,
          ),
          _buildDivider(),
          _buildOptionItem(
            Icons.lock_outline,
            "Đổi mật khẩu",
            Colors.blue,
            onTap: () {

              print("Đổi mật khẩu");
            },
          ),
          _buildDivider(),
          _buildOptionItem(
            Icons.notifications_outlined,
            "Cài đặt thông báo",
            Colors.green,
            onTap: () {
              print("Cài đặt thông báo");
            },
          ),
          _buildDivider(),
          _buildOptionItem(
            Icons.security_outlined,
            "Bảo mật & Quyền riêng tư",
            Colors.red,
            onTap: () {
              print("Bảo mật & Quyền riêng tư");
            },
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    Color iconColor, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: isFirst
              ? BorderSide.none
              : BorderSide(color: Colors.grey[100]!, width: 1),
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.grey[100]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    IconData icon,
    String title,
    Color iconColor, {
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(16) : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: isFirst
                ? BorderSide.none
                : BorderSide(color: Colors.grey[100]!, width: 1),
            bottom: isLast
                ? BorderSide.none
                : BorderSide(color: Colors.grey[100]!, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 80),
      height: 1,
      color: Colors.grey[100],
    );
  }
}