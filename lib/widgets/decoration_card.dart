import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/award_decoration.dart';

class DecorationCard extends StatefulWidget {
  DecorationCard(
      {Key key,
      this.onLongPressed,
      this.decoration,
      this.onAwardChosen,
      this.onAwardNumberChanged})
      : super(key: key);
  final Function onLongPressed;
  final AwardDecoration decoration;
  final Function(String) onAwardChosen;
  final Function(String) onAwardNumberChanged;

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
    _awardNumberController.text = widget.decoration.number.toString();
  }

  @override
  void dispose() {
    _awardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPressed,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: widget.decoration.name,
                  decoration: const InputDecoration(labelText: 'Decoration'),
                  items: DecorationCard.awards.map((award) {
                    return DropdownMenuItem(
                      child: Text(
                        award,
                        overflow: TextOverflow.ellipsis,
                      ),
                      value: award,
                    );
                  }).toList(),
                  onChanged: widget.onAwardChosen,
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 60,
                  child: TextField(
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
