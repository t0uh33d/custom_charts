library bar_chart;

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'dart:math' as math;

part 'bar_chart_controller.dart';
part 'bar_chart_section.dart';

class BarChart extends StatefulWidget {
  final List<BarChartSection> data;
  final double width;
  final double height;
  final double xLabelSpacing;
  final double yLabelSpacing;
  final double topClearance;
  final double initialBarGap;
  final double barWidth;
  final Color barColor;
  const BarChart({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.xLabelSpacing = 40,
    this.yLabelSpacing = 60,
    this.topClearance = 16,
    this.initialBarGap = 8,
    this.barWidth = 40,
    this.barColor = Colors.yellow,
  });

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  final BarChartController controller = BarChartController();

  @override
  void initState() {
    controller._init(
      data: widget.data,
      width: widget.width,
      height: widget.height,
      xLabelSpacing: widget.xLabelSpacing,
      yLabelSpacing: widget.yLabelSpacing,
      topClearance: widget.topClearance,
      initialBarGap: widget.initialBarGap,
      barWidth: widget.barWidth,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          color: Colors.red,
          child: CustomPaint(
            painter: BarChartCustomPainter(controller: controller),
          ),
        ),
        Positioned(
          left: 89,
          top: 146,
          child: Container(
            height: 20,
            width: 20,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }
}

class BarChartCustomPainter extends CustomPainter {
  final BarChartController controller;
  BarChartCustomPainter({
    required this.controller,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint chartSpacePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    /// providing space for a graph
    Size graphSpace = Size(size.width - controller._yLabelSpacing,
        size.height - controller._xLabelSpacing);

    // finding the min and max value from the data
    double minVal = controller._data.first.value;
    double maxVal = controller._data.first.value;

    for (int idx = 1; idx < controller._data.length; idx++) {
      minVal = math.min(minVal, controller._data[idx].value);
      maxVal = math.max(maxVal, controller._data[idx].value);
    }

    // generating nice labels for the given set of data
    List<double> labels = controller.getNiceChartLabels(minVal, maxVal, 5);

    /// plotting the chart space
    canvas.drawRect(
      Rect.fromLTWH(
        controller._yLabelSpacing,
        controller._topClearance,
        graphSpace.width,
        graphSpace.height,
      ),
      chartSpacePaint,
    );

    /// calculating the spacing between the indicator lines
    double indicatorLineSpacing = graphSpace.height / 5;

    double yEnd = graphSpace.height + controller._topClearance;
    double xStart = controller._yLabelSpacing;
    double xEnd = size.width;

    /// generating the y labels
    _generateYlabellings(
        canvas, yEnd, size, xStart, xEnd, indicatorLineSpacing, labels);

    /// calculating the space betwen the bars based on the given bar width
    double barSpacings =
        (graphSpace.width - (controller._barWidth * controller._data.length)) /
                controller._data.length -
            1;

    /// the space to be provided before rendering the idx'th bar
    double deltaSpacing = (barSpacings / 2) + controller._yLabelSpacing;

    for (int idx = 0; idx < controller._data.length; idx++) {
      Paint paint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.blue;

      // bar height based on the maxVal
      double barHeight =
          (controller._data[idx].value / maxVal) * graphSpace.height;

      /// plotting the bar here
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            deltaSpacing,
            controller._topClearance + graphSpace.height - barHeight,
            controller._barWidth,
            barHeight,
          ),
          topLeft: const Radius.circular(5),
          topRight: const Radius.circular(5),
        ),
        paint,
      );

      /// center offset for the bar
      Offset center =
          Offset(deltaSpacing + controller._barWidth / 5, yEnd - 100);
      print("${center.dx} ${center.dy}");

      /// plotting the x labels
      TextSpan textSpan = TextSpan(
        text: controller._data[idx].xLabel.toString(),
        style: const TextStyle(
          color: Colors.white,
          height: 1,
        ),
      );
      TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      double textHeight = textPainter.computeLineMetrics().first.height;
      double textWidth = textPainter.computeLineMetrics().first.width;

      textPainter.paint(
        canvas,
        Offset(
          deltaSpacing + (controller._barWidth / 2) - textWidth / 2,
          graphSpace.height + controller._topClearance + textHeight / 2,
        ),
      );

      deltaSpacing += controller._barWidth + barSpacings;
    }
  }

  void _generateYlabellings(
    Canvas canvas,
    double yEnd,
    Size size,
    double xStart,
    double xEnd,
    double indicatorLineSpacing,
    List<double> labels,
  ) {
    for (int idx = 0; idx < 6; idx++) {
      TextSpan textSpan = TextSpan(
        text: labels[idx].toString(),
        style: const TextStyle(
          color: Colors.white,
          height: 1,
        ),
      );
      TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      double textHeight = textPainter.computeLineMetrics().first.height;
      double textWidth = textPainter.computeLineMetrics().first.width;

      textPainter.paint(
        canvas,
        Offset(
          controller._yLabelSpacing - textWidth - 10,
          yEnd - textHeight / 2,
        ),
      );

      controller._dotterLine(
        size,
        canvas,
        start: Offset(xStart, yEnd),
        end: Offset(xEnd, yEnd),
        dashSpace: idx == 0 ? 2 : 5,
      );

      yEnd -= indicatorLineSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
