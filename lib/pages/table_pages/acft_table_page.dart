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
  String? _ageGroup, _gender;

  @override
  void initState() {
    super.initState();
    _ageGroup = widget.ageGroup;
    _gender = widget.gender;
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
                    child: DropdownButtonFormField(
                      value: _ageGroup,
                      items: ptAgeGroups
                          .map((e) => DropdownMenuItem(
                                child: Text(e!),
                                value: e,
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        label: Text('Age Group'),
                      ),
                      onChanged: (dynamic value) {
                        setState(() {
                          _ageGroup = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      value: _gender,
                      items: ['Male', 'Female']
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        label: Text('Gender'),
                      ),
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
