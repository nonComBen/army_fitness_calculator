import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:acft_calculator/widgets/platform_widgets/platform_outlined_button.dart';
import 'package:acft_calculator/widgets/platform_widgets/platform_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/award_decoration.dart';
import '../methods/platform_show_modal_bottom_sheet.dart';

class DecorationCard extends StatefulWidget {
  DecorationCard({
    Key? key,
    required this.context,
    this.onLongPressed,
    required this.decoration,
    this.onAwardChosen,
    this.onAwardNumberChanged,
    this.onSelectedItemChanged,
  }) : super(key: key);
  final BuildContext context;
  final Function? onLongPressed;
  final AwardDecoration? decoration;
  final void Function(dynamic)? onAwardChosen;
  final void Function(int)? onSelectedItemChanged;
  final void Function(String)? onAwardNumberChanged;

  static const List<String> awards = [
    'None',
    'Soldiers Medal',
    'Purple Heart',
    'BSM',
    'BSM w/V Device',
    'MSM/DMSM',
    'ARCOM/JSCOM/Equiv',
    'ARCOM/Air Medal w/V Device',
    'AAM/JSAM/Equiv',
    'MOVSM',
    'AGCM/AF Res Medal',
    'COA'
  ];

  @override
  State<DecorationCard> createState() => _DecorationCardState();
}

class _DecorationCardState extends State<DecorationCard> {
  var _awardNumberController = TextEditingController();
  // late String award;

  @override
  void initState() {
    super.initState();
    _awardNumberController.text = widget.decoration!.number.toString();
    // award = widget.decoration!.name.toString();
  }

  @override
  void dispose() {
    _awardNumberController.dispose();
    super.dispose();
  }

  _showDecorations() {
    showPlatformModalBottomSheet(
      context: widget.context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 2 / 3,
          padding: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom == 0
                  ? MediaQuery.of(context).padding.bottom
                  : MediaQuery.of(context).viewInsets.bottom),
          color: getBackgroundColor(context),
          child: ListView.builder(
            controller: ScrollController(),
            itemCount: DecorationCard.awards.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformOutlinedButton(
                    child: Text(
                      DecorationCard.awards[index],
                      style: TextStyle(
                        color: getTextColor(context),
                      ),
                    ),
                    onPressed: () {
                      widget.onAwardChosen!(DecorationCard.awards[index]);
                      Navigator.pop(context);
                    }),
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPressed as void Function()?,
      child: Card(
        color: getContrastingBackgroundColor(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: PlatformOutlinedButton(
                  child: Text(
                    widget.decoration!.name!,
                    style: TextStyle(
                      color: getTextColor(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: _showDecorations,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: PlatformTextField(
                    controller: _awardNumberController,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: getTextColor(context),
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: widget.onAwardNumberChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
