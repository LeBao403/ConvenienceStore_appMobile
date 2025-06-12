class SanPham {
final int? masp; 
  final String? tensp;
  final String? mota;
  final double? giaban; 
  final String? dvt;
  final int? soluongton; 
  final int? madm; 
  final String? mancc;
  final String? anh1;
  final String? anh2;
  final String? anh3;

  SanPham({
this.masp,
    this.tensp,
    this.mota,
    this.giaban,
    this.dvt,
    this.soluongton,
    this.madm,
    this.mancc,
    this.anh1,
    this.anh2,
    this.anh3,
  });

  factory SanPham.fromJson(Map<String, dynamic> json) {
  return SanPham(
    masp: json['masp'] as int?,
    tensp: json['tensp'] as String?,
    mota: json['mota'] as String?,
    giaban: json['giaban'] != null ? (json['giaban'] as num).toDouble() : null,
    dvt: json['dvt'] as String?,
    soluongton: json['soluongton'] as int?,
    madm: json['madm'] as int?,
    mancc: json['mancc'] as String?,
    anh1: json['anH1'] as String?,
    anh2: json['anH2'] as String?,
    anh3: json['anH3'] as String?,
  );
}
  }
