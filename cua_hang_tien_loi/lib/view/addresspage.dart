import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cua_hang_tien_loi/model/model_cartDetail.dart';
import 'package:http/http.dart' as http;
import 'confirmation_page.dart';
import 'package:cua_hang_tien_loi/model/model_address.dart';

class AddressPage extends StatefulWidget {
  final List<ChiTietGioHang> cartItems;
  final ShippingMethod shippingMethod;
  const AddressPage({super.key, required this.cartItems, required this.shippingMethod});

  @override
  State<AddressPage> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressPage> {
  String? selectedTinh;
  String? selectedHuyen;
  String? selectedXa;
  AddressModel? addressModel;
  String? selectedChiNhanh;
  
  List<dynamic> dsTinh = [];
  List<dynamic> dsHuyen = [];
  List<dynamic> dsXa = [];
  List<dynamic> dsChiNhanh = [];

  final String apiBaseUrl = 'https://10.0.2.2:7199/api/DiaChi';
  final TextEditingController diaChiController = TextEditingController();

  @override
  void initState() {
    addressModel = AddressModel(
      tenTinh: null,
      tenHuyen: null,
      tenXa: null,
      street: null,
      chiNhanh: null,
    );
    super.initState();
    if (widget.shippingMethod == ShippingMethod.delivery) {
      fetchTinh();
    } 
    fetchChiNhanh();
  }

  @override
  void dispose() {
    diaChiController.dispose();
    super.dispose();
  }

  Future<void> fetchTinh() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/tinh'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dsTinh = data;
        });
      }
    } catch (e) {
      print("Lỗi khi lấy tỉnh: $e");
    }
  }

  Future<void> fetchHuyen(String maTinh) async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/huyen?maTinh=$maTinh'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dsHuyen = data;
          selectedHuyen = null;
          selectedXa = null;
          dsXa = [];
        });
      }
    } catch (e) {
      print("Lỗi khi lấy huyện: $e");
    }
  }

  Future<void> fetchXa(String maQuan) async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/xa?maQuan=$maQuan'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dsXa = data;
          selectedXa = null;
        });
      }
    } catch (e) {
      print("Lỗi khi lấy xã: $e");
    }
  }

  Future<void> fetchChiNhanh() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/chinhanh'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          dsChiNhanh = data;
        });
      }
    } catch (e) {
      print("Lỗi khi lấy chi nhánh: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn địa chỉ giao hàng'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.shippingMethod == ShippingMethod.delivery) ...[
                DropdownButtonFormField<String>(
                  value: selectedTinh,
                  decoration: const InputDecoration(labelText: 'Tỉnh/Thành phố'),
                  items: dsTinh.map<DropdownMenuItem<String>>((tinh) {
                    return DropdownMenuItem<String>(
                      value: tinh['maTinh'].toString(),
                      child: Text(tinh['tenTinh']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTinh = value;
                      addressModel?.tenTinh = dsTinh.firstWhere((e) => e['maTinh'].toString() == value)['tenTinh'];
                      selectedHuyen = null;
                      selectedXa = null;
                      addressModel?.tenHuyen = null;
                      addressModel?.tenXa = null;
                      dsHuyen = [];
                      dsXa = [];
                    });
                    fetchHuyen(value!);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedHuyen,
                  decoration: const InputDecoration(labelText: 'Quận/Huyện'),
                  items: dsHuyen.map<DropdownMenuItem<String>>((huyen) {
                    return DropdownMenuItem<String>(
                      value: huyen['maQuan'].toString(),
                      child: Text(huyen['tenQuan']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedHuyen = value;
                      addressModel?.tenHuyen = dsHuyen.firstWhere((e) => e['maQuan'].toString() == value)['tenQuan'];
                      selectedXa = null;
                      addressModel?.tenXa = null;
                      dsXa = [];
                    });
                    fetchXa(value!);
                  }
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedXa,
                  decoration: const InputDecoration(labelText: 'Phường/Xã'),
                  items: dsXa.map<DropdownMenuItem<String>>((xa) {
                    return DropdownMenuItem<String>(
                      value: xa['maPhuong'].toString(),
                      child: Text(xa['tenPhuong']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedXa = value;
                      addressModel?.tenXa = dsXa.firstWhere((e) => e['maPhuong'].toString() == value)['tenPhuong'];
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: diaChiController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ chi tiết (số nhà, đường...)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Chọn chi nhánh cửa hàng'),
                value: selectedChiNhanh,
                isExpanded: true,
                items: dsChiNhanh.map<DropdownMenuItem<String>>((cn) {
                  return DropdownMenuItem<String>(
                    value: cn['maChiNhanh'].toString(),
                    child: SizedBox(
                      child: Text(
                        cn['diaChi'] ?? 'Chi nhánh không rõ tên',
                        maxLines: null,
                        softWrap: true,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChiNhanh = value;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return dsChiNhanh.map<Widget>((cn) {
                    return Text(
                      cn['diaChi'] ?? 'Chi nhánh không rõ tên',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }).toList();
                },
              ),
              if (addressModel?.tenTinh != null && addressModel?.tenHuyen != null && addressModel?.tenXa != null && diaChiController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Địa chỉ của bạn: ${diaChiController.text}, ${addressModel?.tenXa}, ${addressModel?.tenHuyen}, ${addressModel?.tenTinh}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: (widget.shippingMethod == ShippingMethod.delivery &&
                          selectedTinh != null && selectedHuyen != null && selectedXa != null && diaChiController.text.isNotEmpty)
                    || (widget.shippingMethod == ShippingMethod.pickup && selectedChiNhanh != null)
                  ? () {
                      if (widget.shippingMethod == ShippingMethod.delivery) {
                        addressModel?.street = diaChiController.text;
                        addressModel?.chiNhanh = '${dsChiNhanh.firstWhere((e) => e['maChiNhanh'].toString() == selectedChiNhanh)['diaChi']}';
                        addressModel?.maChiNhanh = selectedChiNhanh.toString();
                      } else {
                        addressModel = AddressModel(
                          tenTinh: null,
                          tenHuyen: null,
                          tenXa: null,
                          street: null,
                          chiNhanh: '${dsChiNhanh.firstWhere((e) => e['maChiNhanh'].toString() == selectedChiNhanh)['diaChi']}',
                          maChiNhanh: selectedChiNhanh.toString(),
                        );
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ConfirmationPage(
                            cartItems: widget.cartItems,
                            selectedAddress: addressModel!,
                            shippingMethod: widget.shippingMethod,
                          ),
                        ),
                      );
                    }
                  : null,
                child: const Text('Xác nhận địa chỉ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
