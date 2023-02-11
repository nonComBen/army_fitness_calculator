import 'package:acft_calculator/widgets/platform_widgets/platform_item_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../../constants/pt_age_group_table.dart';
import '../../widgets/acft_table.dart';

class AcftTablePage extends StatefulWidget {
  const AcftTablePage({Key? key, this.ageGroup, this.gender}) : super(key: key);
  final String? ageGroup;
  final String? gender;

  @override
  State<AcftTablePage> createState() => _AcftTablePageState();
}

class _AcftTablePageState extends State<AcftTablePage> {
  late String _ageGroup, _gender;
  List<String> _genders = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _ageGroup = widget.ageGroup!;
    _gender = widget.gender!;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PlatformScaffold(
      title: 'ACFT Table',
      body: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 8,
          left: 8,
          right: 8,
          top: 8,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: width > 700 ? 2 : 1,
                childAspectRatio: width > 700 ? width / 230 : width / 115,
                shrinkWrap: true,
                primary: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformItemPicker(
                      label: 'Age Group',
                      value: _ageGroup,
                      items: ptAgeGroups,
                      onSelectedItemChanged: (index) => setState(() {
                        _ageGroup = ptAgeGroups[index];
                      }),
                      onChanged: (dynamic value) {
                        setState(() {
                          _ageGroup = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformItemPicker(
                      label: 'Gender',
                      value: _gender,
                      items: _genders,
                      onSelectedItemChanged: (index) => setState(() {
                        _gender = _genders[index];
                      }),
                      onChanged: (dynamic value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              AcftTable(
                ageGroup: _ageGroup,
                gender: _gender,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
