import 'package:custom_charts/doughnut_chart/doughnut_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Doughnut Chart'),
        ),
        body:
            // Center(
            //   child: BarChart(
            //     data: [
            //       BarChartSection(
            //         value: 240,
            //         xLabel: "week 1",
            //       ),
            //       BarChartSection(
            //         value: 560,
            //         xLabel: "week 2",
            //       ),
            //       BarChartSection(
            //         value: 680,
            //         xLabel: "week 3",
            //       ),
            //       BarChartSection(
            //         value: 700,
            //         xLabel: "week 4",
            //       ),
            //     ],
            //     height: 270,
            //     width: 560,
            //   ),
            // ),
            Center(
          child: DoughnutChart(
            height: 300,
            width: 300,
            strokeWidth: 20,
            doughnutChartSections: [
              DoughnutChartSection(
                value: 30,
                color: Colors.red,
                hoverWidget: const Text('a'),
              ),
              DoughnutChartSection(
                value: 50,
                color: Colors.blue,
                hoverWidget: const Text('b'),
              ),
              DoughnutChartSection(
                value: 30,
                color: Colors.green,
                hoverWidget: const Text('c'),
              ),
              DoughnutChartSection(
                value: 30,
                color: Colors.yellow,
                hoverWidget: const Text('d'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
