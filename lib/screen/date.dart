import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  List<DateTime> blackoutDates = [DateTime(2023, 4, 25), DateTime(2023, 4, 26)];
  DateTimeRange? selectedDateRange; // example blackout dates
  bool dateRangesOverlap(DateTimeRange range1, DateTimeRange range2) {
    if (range1.start.isAfter(range2.end) || range1.end.isBefore(range2.start)) {
      return false;
    }
    return true;
  }

  DateTime? _startDate;
  DateTime? _endDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfDateRangePicker(
      view: DateRangePickerView.month,
      selectionMode: DateRangePickerSelectionMode.range,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        // get the selected date range
        DateTimeRange? selectedRange = args.value as DateTimeRange?;

        // check if the selected range overlaps with any blackout dates
        // if (selectedRange != null &&
        //     !blackoutDates.every((date) => !selectedRange
        //         .overlaps(DateTimeRange(start: date, end: date)))) {
        //   // if selected range overlaps with blackout dates, deselect the dates and show an error message
        //   _startDate = null;
        //   _endDate = null;
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //         content: Text("Selected range overlaps with blackout dates")),
        //   );
        // } else {
        //   // otherwise, update the selected dates
        //   _startDate = selectedRange?.start;
        //   _endDate = selectedRange?.end;
        // }
      },
      monthViewSettings: DateRangePickerMonthViewSettings(
        blackoutDates: blackoutDates,
      ),
    ));
  }
}
