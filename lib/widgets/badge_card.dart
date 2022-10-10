import 'package:flutter/material.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard(
      {Key key, this.onLongPressed, this.badgeName, this.onBadgeChosen})
      : super(key: key);
  final Function onLongPressed;
  final String badgeName;
  final ValueChanged<String> onBadgeChosen;

  static const List<String> badges = [
    'None',
    'EIB/EFMB/ESB',
    'CIB/CMB/CAB',
    'Master Parachute Badge',
    'Master EOD Badge',
    'Master/Gold Recruiter Badge',
    'Master Gunner Badge',
    'Divers Badge (First Class)',
    'Master Aviation Badge',
    'Master Instructor Badge',
    'Instructor Badge (Basic/Senior)',
    'Senior Parachute Badge',
    'Senior EOD Badge',
    'Presidential Service Badge',
    'VP Service Badge',
    'Drill Sergeant Badge',
    'Recruiter Badge (Basic)',
    'Divers Badge (Supervisor/Salvage)',
    'Parachute Combat Badge (Senior)',
    'Senior Aviation Badge',
    'Free Fall Badge (Master)',
    'Senior Space Badge',
    'Parachute Badge',
    'Parachute Combat Badge (Basic)',
    'Rigger Badge',
    'Divers Badge (SCUBA/2nd Class)',
    'EOD Badge (Basic)',
    'Pathfinder Badge',
    'Air Assault Badge',
    'Aviation Badge',
    'Army Staff ID Badge',
    'JCoS ID Badge',
    'SecDef Service Badge',
    'Space Badge',
    'Free Fall Badge (Basic)',
    'Special Operations Divers Badge (Basic)',
    'Tomb Guard ID Badge',
    'Military Horseman ID Badge',
    'Driver/Mech Badge',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPressed,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            isExpanded: true,
            value: badgeName,
            decoration: const InputDecoration(labelText: 'Badge'),
            items: badges.map((badge) {
              return DropdownMenuItem(
                child: Text(badge, overflow: TextOverflow.ellipsis),
                value: badge,
              );
            }).toList(),
            onChanged: onBadgeChosen,
          ),
        ),
      ),
    );
  }
}
