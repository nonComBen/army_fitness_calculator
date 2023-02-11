import 'package:acft_calculator/widgets/platform_widgets/platform_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/award_decoration.dart';
import 'platform_widgets/platform_item_picker.dart';

class DecorationCard extends StatefulWidget {
  DecorationCard({
    Key? key,
    this.onLongPressed,
    this.decoration,
    this.onAwardChosen,
    this.onAwardNumberChanged,
    this.onSelectedItemChanged,
  }) : super(key: key);
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

  @override
  void initState() {
    super.initState();
    _awardNumberController.text = widget.decoration!.number.toString();
  }

  @override
  void dispose() {
    _awardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPressed as void Function()?,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: PlatformItemPicker(
                  value: widget.decoration!.name!,
                  label: 'Decoration',
                  items: DecorationCard.awards,
                  onChanged: widget.onAwardChosen,
                  onSelectedItemChanged: widget.onSelectedItemChanged,
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 60,
                  child: PlatformTextField(
                    controller: _awardNumberController,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
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
