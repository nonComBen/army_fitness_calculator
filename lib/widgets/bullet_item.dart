import 'package:flutter/material.dart';

class BulletItem extends StatelessWidget {
  const BulletItem({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('- '),
          Expanded(
            child: Text(
              text!,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
