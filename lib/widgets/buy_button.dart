import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  const BuyButton({required this.onPressed, super.key});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.add), SizedBox(width: 8), Text('Köp')],
        ),
      ),

      onPressed: () {
        onPressed();
      },
    );
  }
}
