import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_admin/Model/Lead.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LeadChart extends StatelessWidget {
  const LeadChart({super.key, required this.dateWiseLeads});

  final Map<DateTime, List<Lead>> dateWiseLeads;

  List<ChartXY> getData() {
    Set<ChartXY> list = {};

    for (int i = 0; i < 30; i++) {
      var date = DateTime.now().subtract(Duration(days: i)).trimTime();
      if (dateWiseLeads.keys.contains(date)) {
        list.add(ChartXY(dateWiseLeads[date]?.length ?? 0, date));
      } else {
        list.add(ChartXY(0, date));
      }
    }

    return list.toList();
  }

  getSeries() {
    return [
      charts.Series<ChartXY, DateTime>(
        id: 'PER DAY LEAD',
        domainFn: ((datum, index) => datum.date),
        measureFn: (datum, index) => datum.count,
        data: getData(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 2,
        child: charts.TimeSeriesChart(
          getSeries(),
          defaultRenderer: charts.BarRendererConfig<DateTime>(),
          defaultInteractions: false,
          behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
        ));
  }
}

class ChartXY {
  final int count;
  final DateTime date;
  ChartXY(this.count, this.date);

  @override
  bool operator ==(e) => e is ChartXY && date == e.date;
  @override
  int get hashCode => Object.hash(date, null);
}

extension DateTrim on DateTime {
  DateTime trimTime() {
    return DateTime(year, month, day);
  }
}
