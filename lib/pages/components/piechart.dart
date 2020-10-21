import 'package:charts_flutter/flutter.dart' as charts;

/// Bar chart with series legend example
import 'package:flutter/material.dart';

class SimpleDatumLegend extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleDatumLegend(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 40,
        arcRendererDecorators: [new charts.ArcLabelDecorator()],
      ),
      behaviors: [
        new charts.DatumLegend(
            position: charts.BehaviorPosition.start,
            outsideJustification: charts.OutsideJustification.endDrawArea)
      ],
    );
  }
}
