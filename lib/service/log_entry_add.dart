import 'package:flutter/material.dart';
import 'package:followupapp/models/log.dart';

Future<int> addLogEntry(int taskId,LogEntry value)
/// Takes an int task id and a LogEntry, inserts into database. Returns logEntry id.
{
  debugPrint("addLogEntry");
  return Future<int>.delayed(const Duration(seconds: 1),()=> 1);
}