import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuantityButton({
    Key? key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.remove, size: 18, color: Colors.blue),
          ),
          _verticalDivider(),
          Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          _verticalDivider(),
          GestureDetector(
            onTap: onAdd,
            child: const Icon(Icons.add, size: 18, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 20,
      width: 1,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.blue,
            width: 1,
            style: BorderStyle.solid, // for solid line
            // you can simulate dotted if needed separately
          ),
        ),
      ),
    );
  }
}
