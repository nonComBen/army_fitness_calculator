import 'package:flutter/material.dart';

import '../../methods/theme_methods.dart';
import 'bullet_item.dart';

class MdlSetupCard extends StatelessWidget {
  const MdlSetupCard({Key? key, this.title, this.image, this.weights})
      : super(key: key);
  final Image? image;
  final String? title;
  final List<String>? weights;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        color: getContrastingBackgroundColor(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        BulletItem(
                          text: '60 lb Hex Bar',
                        ),
                        ...weights!
                            .map((e) => BulletItem(
                                  text: e,
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 130,
                          ),
                          child: Center(child: image))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
