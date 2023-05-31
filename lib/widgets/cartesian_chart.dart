import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianChart extends StatefulWidget {
  CartesianChart(this.list);
  var list = [];

  @override
  State<CartesianChart> createState() => _CartesianChartState(list);
}

class _Infections {
  _Infections(this.year, this.victims);

  final String year;
  final double victims;
}

class _RequestsCounter {
  _RequestsCounter(this.month, this.quantity);

  final String month;
  final double quantity;
}

class _CartesianChartState extends State<CartesianChart> {
  _CartesianChartState(this.list);
  var list = [];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(text: 'Solicitações Mensais'),
        // Enable legend
        legend: Legend(isVisible: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<_RequestsCounter, String>>[
          LineSeries<_RequestsCounter, String>(
              dataSource: <_RequestsCounter>[
                _RequestsCounter('Janeiro', list[0]),
                _RequestsCounter('Fevereiro', list[1]),
                _RequestsCounter('Março', list[2]),
                _RequestsCounter('Abril', list[3]),
                _RequestsCounter('Maio', list[4]),
                _RequestsCounter('Junho', list[5]),
                _RequestsCounter('Julho', list[6]),
                _RequestsCounter('Agosto', list[7]),
                _RequestsCounter('Setembro', list[8]),
                _RequestsCounter('Outubro', list[9]),
                _RequestsCounter('Novembro', list[10]),
                _RequestsCounter('Dezembro', list[11]),
              ],
              xValueMapper: (_RequestsCounter quantity, _) => quantity.month,
              yValueMapper: (_RequestsCounter quantity, _) => quantity.quantity,
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: true),
              name: 'Solicitações')
        ]);
  }
}
