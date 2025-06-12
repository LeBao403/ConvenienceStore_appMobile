
// Class SanPham
class DanhMuc {
  final int? maDM; // Thay đổi từ int sang int?
  final String? tenDM;
  

  DanhMuc({
    this.maDM,
    this.tenDM,

  });

  factory DanhMuc.fromJson(Map<String, dynamic> json) {
  return DanhMuc(
    maDM: json['maDM'] as int?,
    tenDM: json['tenDM'] as String?,
  );
}
  }
