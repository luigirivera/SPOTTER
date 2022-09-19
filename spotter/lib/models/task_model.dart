import 'package:flutter/material.dart';

///Making the Tasks object and filling it with some default values
///These are subjected to change by the user so pls don't add final tag
class Task {
  Icon? icon = const Icon(Icons.arrow_forward_ios, color: Colors.orange);
  String taskDescription;
  String? taskGroup;
  bool completed = false;

  Task({this.icon, required this.taskDescription, this.taskGroup, required this.completed});

  @override
  String toString() => 'icon: ${icon}text: ${taskDescription}taskGroup: $taskGroup completed: $completed';
}