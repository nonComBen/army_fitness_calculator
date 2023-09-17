import 'package:flutter/material.dart';

class Verbiage {
  Verbiage(this.isExpanded, this.header, this.body);
  bool isExpanded;
  final String header;
  final Widget body;
}
