class AddressModel {
  String? tenTinh;
  String? tenHuyen;
  String? tenXa;
  String? street;
  String? chiNhanh;
  String? maChiNhanh; 

  AddressModel({
    required this.tenTinh,
    required this.tenHuyen,
    required this.tenXa,
    required this.street,
    required this.chiNhanh,
    this.maChiNhanh,
  });
}