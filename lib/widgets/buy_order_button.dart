import 'package:flutter/material.dart';

class BuyOrderButton extends StatelessWidget {
  const BuyOrderButton({required this.onPressed, super.key});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Container(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Lägg till i varukorg'),
          ],
        ),
      ),

      onPressed: () {
        onPressed();
      },
    );
  }
}
