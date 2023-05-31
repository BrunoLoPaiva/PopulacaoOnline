import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RequestsPieChart extends StatefulWidget {
  RequestsPieChart(this.lista);

  var lista;
  @override
  State<RequestsPieChart> createState() => _RequestsPieChartState(lista);
}

class ChartData {
  ChartData(
    this.x,
    this.y,
    this.color,
  );
  final String x;
  final double y;
  final Color color;
}

class _RequestsPieChartState extends State<RequestsPieChart> {
  _RequestsPieChartState(this.listValue);
  var listValue;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Buraco', listValue[0], Color(0xFFfd7f6f)),
      ChartData('Denúncia', listValue[1], Color(0xFF7eb0d5)),
      ChartData('Entulho', listValue[2], Color(0xFFb2e061)),
      ChartData('Lixo', listValue[3], Color(0xFFfdcce5)),
      ChartData('Poda de árvore', listValue[4], Color(0xFFffb55a)),
      ChartData('Mato', listValue[5], Color(0xFFffee65)),
      ChartData('Outros', listValue[6], Color(0xFF8bd3c7)),
    ];

    print(listValue);
    return Container(
      // width: MediaQuery.of(context).size.width * .25,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(16.0)),
      //     color: Color.fromARGB(255, 61, 61, 61)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: SfCircularChart(
              series: <CircularSeries>[
                // Render pie chart
                PieSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text('Buraco',
                        style:
                            TextStyle(color: Color(0xFFfd7f6f), fontSize: 16)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Denúncia',
                        style:
                            TextStyle(color: Color(0xFF7eb0d5), fontSize: 16)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Entulho',
                        style:
                            TextStyle(color: Color(0xFFb2e061), fontSize: 16)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Lixo',
                        style:
                            TextStyle(color: Color(0xFFfdcce5), fontSize: 16)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Poda de árvore',
                        style:
                            TextStyle(color: Color(0xFFffb55a), fontSize: 16)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Mato',
                        style:
                            TextStyle(color: Color(0xFFffee65), fontSize: 16)),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Outros',
                        style:
                            TextStyle(color: Color(0xFF8bd3c7), fontSize: 16)),
                    SizedBox(
                      height: 8,
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
