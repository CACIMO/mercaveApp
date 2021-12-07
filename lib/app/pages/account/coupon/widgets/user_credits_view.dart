import 'package:flutter/material.dart';

class UserCreditsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                height: 100,
                child: Image.asset('assets/icons/coupon.png'),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Tienes', style: TextStyle(fontSize: 18.0)),
                FittedBox(
                  child: Text(
                    r'$0',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text('Para mercar', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
