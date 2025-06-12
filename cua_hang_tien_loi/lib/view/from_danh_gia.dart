import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/danh_gia.dart';
import 'package:cua_hang_tien_loi/api/api_danh_gia.dart'; // Import API gửi đánh giá
import 'package:shared_preferences/shared_preferences.dart';

class ReviewForm extends StatefulWidget {
  final int maSP;
  final int? maTK; // Mã tài khoản của người dùng hiện tại (có thể null nếu chưa đăng nhập)
  final VoidCallback onReviewSubmitted; // Callback để làm mới danh sách đánh giá

  const ReviewForm({
    Key? key,
    required this.maSP,
    this.maTK, // Cho phép null, không cần giá trị mặc định
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  int _selectedStars = 0;
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? maKH;
  bool isCheckingLogin = true;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadMaKH() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maKH = prefs.getString('maKH');
      isCheckingLogin = false;
    });
  }


  void _submitReview() async {
    _loadMaKH();
    // Nếu maTK là null, gán mặc định là 2 để thử nghiệm
    //final effectiveMaTK = widget.maTK ?? 2;

    if (_formKey.currentState!.validate()) {
      if (_selectedStars == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn số sao.')),
        );
        return;
      }

      final newDanhGia = DanhGia(
        maTK: maKH != null ? int.tryParse(maKH!) : null, // Chuyển đổi String? sang int?
        maSP: widget.maSP,
        soSao: _selectedStars,
        binhLuan: _commentController.text,
        ngayDanhGia: DateTime.now(), // Ngày đánh giá hiện tại
      );

      bool success = await postDanhGia(newDanhGia);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đánh giá của bạn đã được gửi!')),
        );
        _commentController.clear();
        setState(() {
          _selectedStars = 0;
        });
        widget.onReviewSubmitted(); // Gọi callback để làm mới danh sách đánh giá
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thêm đánh giá của bạn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Chọn số sao
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedStars ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedStars = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              // Trường nhập bình luận
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Viết bình luận của bạn...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.all(12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bình luận không được để trống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Nút gửi đánh giá
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Gửi đánh giá'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}