import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  final String orderCode;
  final String store;
  final String time;
  final String trangThai;

  const OrderItemWidget({
    required this.orderCode,
    required this.store,
    required this.time,
    required this.trangThai,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Đơn hàng $orderCode', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(trangThai, style: TextStyle(color: _getTrangThaiColor(trangThai), fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.store, size: 18),
                const SizedBox(width: 4),
                Text(store),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text('Mua lúc: $time', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {
              // TODO: Xem chi tiết đơn hàng
            },
            child: const Text('Xem chi tiết >', style: TextStyle(color: Colors.green, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Color _getTrangThaiColor(String trangThai) {
    switch (trangThai) {
      case 'Đã mua':
        return Colors.green;
      case 'Đang chờ duyệt':
        return Colors.orange;
      case 'Đang vận chuyển':
        return Colors.blue;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}