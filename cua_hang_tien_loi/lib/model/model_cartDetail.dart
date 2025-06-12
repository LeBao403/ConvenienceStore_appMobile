class ChiTietGioHang {
  final int? maGH;
  final int? masp; 
  final int? soLuong; 
  final double? giaBan;
  final double? tongTien; 
  final String? tenSP; 
  final String? anh1;
 

  ChiTietGioHang({
    this.maGH,
    this.masp,
    this.soLuong,
    this.giaBan,
    this.tongTien,
    this.tenSP,
    this.anh1,
  });

  factory ChiTietGioHang.fromJson(Map<String, dynamic> json) {
  return ChiTietGioHang(
    maGH: json['maGH'] as int?,
    masp: json['maSP'] as int?,
    soLuong: json['soLuong'] as int?,
    giaBan: (json['gia'] as num?)?.toDouble(),
    tongTien: (json['tongTien'] as num?)?.toDouble(),
    tenSP: json['tenSP'] as String?,
    anh1: json['duongDan'] as String?,
  );
}
  }