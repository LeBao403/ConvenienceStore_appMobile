class DanhGia {
  final int? maDanhGia; // Thay đổi từ int sang int?
  final int? maTK;
  final int? maSP;
  final int? soSao; // Thay đổi từ double sang double?
  final String? binhLuan;
  final DateTime? ngayDanhGia; // Thay đổi từ int sang int?
  final String? tenKH; // Thêm trường tên sản phẩm nếu cần

  DanhGia({
    this.maDanhGia,
    this.maTK,
    this.maSP,
    this.soSao,
    this.binhLuan,
    this.ngayDanhGia,
    this.tenKH
  });

  factory DanhGia.fromJson(Map<String, dynamic> json) {
  return DanhGia(
    maDanhGia: json['maDanhGia'] as int?,
    maTK: json['maTK'] as int?,
    maSP: json['maSP'] as int?,
    soSao: json['soSao'] as int?,
    binhLuan: json['binhLuan'] as String?,
    tenKH: json['tenKH'] as String?, // Thêm trường tên sản phẩm nếu cần
    ngayDanhGia: json['ngayDanhGia'] != null
        ? DateTime.parse(json['ngayDanhGia'])
        : null,
   
  );
  }
  
}
  