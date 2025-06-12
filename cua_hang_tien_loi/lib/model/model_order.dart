class DonHang {
  final int maDH;
  final int maKH;
  final int ptTT;
  final String ngayDat;
  final double thanhTien;
  final String? trangThaiTT;
  final String? trangThaiGH;
  final String tenSP;
  final String duongDan;
  final int soLuong;

  DonHang({
    required this.maDH,
    required this.maKH,
    required this.ptTT,
    required this.ngayDat,
    required this.thanhTien,
    this.trangThaiTT,
    this.trangThaiGH,
    required this.tenSP,
    required this.duongDan,
    required this.soLuong,
  });

  factory DonHang.fromJson(Map<String, dynamic> json) {
    return DonHang(
      maDH: json['maDH'],
      maKH: json['maKH'],
      ptTT: json['ptTT'],
      ngayDat: json['ngayDat'],
      thanhTien: (json['thanhTien'] as num).toDouble(),
      trangThaiTT: json['trangThaiTT'],
      trangThaiGH: json['trangThaiGH'],
      tenSP: json['tenSP'],
      duongDan: json['duongDan'],
      soLuong: json['soLuong'] ?? 1, // Mặc định là 1 nếu không có
    );
  }
}

class DonHangGroup {
  final int maDH;
  final int maKH;
  final int ptTT;
  final String ngayDat;
  final double thanhTien;
  final String? trangThaiTT;
  final String? trangThaiGH;
  final List<Map<String, dynamic>> sanPhams;

  DonHangGroup({
    required this.maDH,
    required this.maKH,
    required this.ptTT,
    required this.ngayDat,
    required this.thanhTien,
    this.trangThaiTT,
    this.trangThaiGH,
    required this.sanPhams,
  });
}

List<DonHangGroup> groupDonHang(List<DonHang> list) {
  Map<int, DonHangGroup> grouped = {};

  for (var dh in list) {
    if (!grouped.containsKey(dh.maDH)) {
      grouped[dh.maDH] = DonHangGroup(
        maDH: dh.maDH,
        maKH: dh.maKH,
        ptTT: dh.ptTT,
        ngayDat: dh.ngayDat,
        thanhTien: dh.thanhTien,
        trangThaiTT: dh.trangThaiTT,
        trangThaiGH: dh.trangThaiGH,
        sanPhams: [],
      );
    }
    grouped[dh.maDH]!.sanPhams.add({
      'tenSP': dh.tenSP,
      'anh': dh.duongDan,
      'soLuong': dh.soLuong,
    });
  }

  return grouped.values.toList();
}
