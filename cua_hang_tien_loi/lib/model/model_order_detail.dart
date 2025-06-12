class OrderDetail {
  final String tenSP;
  final String anh;
  final int soLuong;
  final num donGia;

  OrderDetail({
    required this.tenSP,
    required this.anh,
    required this.soLuong,
    required this.donGia,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      tenSP: json['tenSP'] ?? '',
      anh: json['anh'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      donGia: json['donGia'] ?? 0,
    );
  }
}