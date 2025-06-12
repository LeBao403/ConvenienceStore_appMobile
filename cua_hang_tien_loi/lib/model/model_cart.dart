class GioHang {
  final int maKH;
  final int maSP;
  final int soLuong;

  GioHang({
    required this.maKH,
    required this.maSP,
    required this.soLuong,
  });

  Map<String, dynamic> toJson() {
    return {
      'MaKH': maKH,
      'MaSP': maSP,
      'SoLuong': soLuong,
    };
  }
}