
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/color_file.dart';


abstract class Algo {
  Algo._();

  static String dateChipText(DateTime date) => DateChipText(date).getText();
}

class DateChipText {
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');
  final DateTime date;

  DateChipText(this.date);

  String getText() {
    final DateTime now = DateTime.now();
    final String todayStr = _formatter.format(now);
    final String dateStr = _formatter.format(date);
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    final String yesterdayStr = _formatter.format(yesterday);

    if (todayStr == dateStr) {
      return 'Today';
    } else if (yesterdayStr == dateStr) {
      return 'Yesterday';
    }
    // Long-form fallback: e.g. "9 July 2024"
    return DateFormat('d MMMM y').format(date);
  }
}

class DateChip extends StatelessWidget {
  final DateTime date;
  final Color color;

  const DateChip({super.key, required this.date, this.color = ColorFile.chipBackgroundBlue});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Container(
          //
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: color),
          child: Padding(padding: const EdgeInsets.all(5.0), child: Text(Algo.dateChipText(date))),
        ),
      ),
    );
  }
}
