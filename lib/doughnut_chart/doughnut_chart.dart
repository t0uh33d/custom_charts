// ignore_for_file: public_member_api_docs, sort_constructors_first
library doughnut_chart;

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

part 'doughnut_chart_controller.dart';
part 'doughnut_chart_section.dart';

class DoughnutChart extends StatefulWidget {
  final List<DoughnutChartSection> doughnutChartSections;
  final double height;
  final double width;
  final double strokeWidth;
  final double hoverOffset;

  const DoughnutChart({
    super.key,
    required this.doughnutChartSections,
    required this.height,
    required this.width,
    this.strokeWidth = 40,
    this.hoverOffset = 7,
  });

  @override
  State<DoughnutChart> createState() => _DoughnutChartState();
}

class _DoughnutChartState extends State<DoughnutChart> {
  final DoughnutChartController controller = DoughnutChartController();

  @override
  void initState() {
    controller._init(
      height: widget.height,
      width: widget.width,
      strokeWidth: widget.strokeWidth,
      doughnutChartSections: widget.doughnutChartSections,
      stateUpdator: setState,
      hoverOffset: widget.hoverOffset,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow.shade50,
      height: widget.height,
      width: widget.width,
      child: Listener(
        onPointerHover: controller._chartInteractionListener,
        child: CustomPaint(
          painter: DoughnutChartPainter(controller: controller),
        ),
      ),
    );
  }
}

class DoughnutChartPainter extends CustomPainter {
  final DoughnutChartController controller;

  DoughnutChartPainter({
    required this.controller,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double total = 0;
    for (int idx = 0; idx < controller._data.length; idx++) {
      total += controller._data[idx].value;
    }

    double startAngle = 0;

    for (int idx = 0; idx < controller._data.length; idx++) {
      double sweepAngle = (controller._data[idx].value / total) * (2 * pi);
      double plotRadius = (idx == controller.hoverIndex)
          ? (controller._radius + controller._hoverOffset)
          : controller._radius;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = (idx == controller.hoverIndex)
            ? (controller._strokeWidth + controller._hoverOffset * 2)
            : controller._strokeWidth
        ..color = controller._data[idx].color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: plotRadius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      controller._mapAngleToIndices(startAngle, startAngle + sweepAngle, idx);

      startAngle += sweepAngle;
      // print("$i, start : $startAngle, sweep : $sweepAngle");
    }
  }

  @override
  bool shouldRepaint(covariant DoughnutChartPainter oldDelegate) {
    return true;
  }
}
