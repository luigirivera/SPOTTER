import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

///Making the Tasks object and filling it with some default values
///These are subjected to change by the user so pls don't add final tag
class Tasks {
  Icon icon = const Icon(Icons.arrow_forward_ios, color: Colors.orange);
  Text? text;
  int? taskGroup;

  ///Making this object linkable to use LinkedHashMap
  Tasks();

  @override
  String toString() => 'icon: ${icon}text: ${text}taskGroup: $taskGroup';
}



