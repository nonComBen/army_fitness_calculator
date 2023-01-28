import 'package:flutter/material.dart';

import '../constants/mdl_setup_table.dart';
import '../widgets/mdl_setup_card.dart';

class MdlSetupPage extends StatelessWidget {
  const MdlSetupPage({Key? key}) : super(key: key);

  static const String routeName = 'mdlSetupRoute';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('MDL Setup'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: width > 700 ? 2 : 1,
          childAspectRatio: width > 700 ? width / 430 : width / 215,
          shrinkWrap: true,
          primary: false,
          children: mdlSetupTable
              .map(
                (e) => MdlSetupCard(
                  title: e[0],
                  image: Image.asset('assets/mdl_images/${e[1]}.png'),
                  weights: e[2],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
