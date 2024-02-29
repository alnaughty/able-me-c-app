import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkModeProvider = StateProvider<bool>((ref) =>
    SchedulerBinding.instance.platformDispatcher.platformBrightness ==
    Brightness.dark);
