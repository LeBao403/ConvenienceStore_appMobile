import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/api/api_KhachHang.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> customerData;

  const EditProfilePage({Key? key, required this.customerData}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tenKHController;
  late TextEditingController _sdtController;
  late TextEditingController _diaChiController;
  late TextEditingController _matKhauController;
  late TextEditingController _confirmMatKhauController;
  late String _gioiTinh;
  bool _isLoading = false;
  bool _obscureMatKhau = true;
  bool _obscureConfirmMatKhau = true;

  @override
  void initState() {
    super.initState();
    _tenKHController = TextEditingController(text: widget.customerData['tenkh'] ?? '');
    _sdtController = TextEditingController(text: widget.customerData['sdt'] ?? '');
    _diaChiController = TextEditingController(text: widget.customerData['diachi'] ?? '');
    _matKhauController = TextEditingController();
    _confirmMatKhauController = TextEditingController();
    _gioiTinh = widget.customerData['gioitinh'] ?? 'Nam';
  }

  @override
  void dispose() {
    _tenKHController.dispose();
    _sdtController.dispose();
    _diaChiController.dispose();
    _matKhauController.dispose();
    _confirmMatKhauController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedData = {
        'makh': widget.customerData['makh'],
        'tenkh': _tenKHController.text.trim(),
        'sdt': _sdtController.text.trim(),
        'diachi': _diaChiController.text.trim(),
        'gioitinh': _gioiTinh,
        'hinhanh': widget.customerData['hinhanh'],
        'matkhau': _matKhauController.text.trim().isNotEmpty ? _matKhauController.text.trim() : null,
      };

      print('Data sent to server: $updatedData'); 

      final response = await apiService.updateKhachHang(widget.customerData['makh'], updatedData);

      setState(() {
        _isLoading = false;
      });

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${response['message'] ?? 'Không xác định'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
          'Chỉnh Sửa Thông Tin',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tenKHController,
                label: 'Họ và tên',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _sdtController,
                label: 'Số điện thoại',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Số điện thoại không hợp lệ (10 chữ số)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _diaChiController,
                label: 'Địa chỉ',
                icon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _matKhauController,
                label: 'Mật khẩu mới (để trống nếu không đổi)',
                icon: Icons.lock_outline,
                obscureText: _obscureMatKhau,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureMatKhau ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureMatKhau = !_obscureMatKhau;
                    });
                  },
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _confirmMatKhauController,
                label: 'Xác nhận mật khẩu',
                icon: Icons.lock_outline,
                obscureText: _obscureConfirmMatKhau,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmMatKhau ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmMatKhau = !_obscureConfirmMatKhau;
                    });
                  },
                ),
                validator: (value) {
                  if (_matKhauController.text.trim().isNotEmpty) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    }
                    if (value != _matKhauController.text.trim()) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildGenderDropdown(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _gioiTinh,
        decoration: const InputDecoration(
          labelText: 'Giới tính',
          prefixIcon: Icon(Icons.transgender_outlined, color: Colors.grey),
          border: InputBorder.none,
        ),
        items: ['Nam', 'Nữ', 'Khác'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _gioiTinh = newValue!;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng chọn giới tính';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : const Text(
                'Lưu Thay Đổi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}