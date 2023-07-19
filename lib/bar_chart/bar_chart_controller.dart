part of bar_chart;

class BarChartController {
  late List<BarChartSection> _data;
  late double _width;
  late double _height;
  late double _xLabelSpacing;
  late double _yLabelSpacing;
  late double _topClearance;
  late double _initialBarGap;
  late double _barWidth;

  void _init({
    required List<BarChartSection> data,
    required double width,
    required double height,
    required double xLabelSpacing,
    required double yLabelSpacing,
    required double topClearance,
    required double initialBarGap,
    required double barWidth,
  }) {
    _data = data;
    _width = width;
    _height = height;
    _xLabelSpacing = xLabelSpacing;
    _yLabelSpacing = yLabelSpacing;
    _topClearance = topClearance;
    _initialBarGap = initialBarGap;
    _barWidth = barWidth;
  }

  void _dotterLine(
    Size size,
    Canvas canvas, {
    required Offset start,
    required Offset end,
    int dashWidth = 5,
    int dashSpace = 5,
  }) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double startX = start.dx;
    while (startX < end.dx) {
      canvas.drawLine(
        Offset(startX, start.dy),
        Offset(startX + dashWidth, end.dy),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  List<double> getNiceChartLabels(
      double minValue, double maxValue, int labelCount) {
    List<double> labels = [];

    // Make sure labelCount is at least 2 to include 0 and maxValue
    labelCount = math.max(labelCount, 2);

    // Calculate the range and the step size between labels
    double range = maxValue - minValue;

    // Determine the order of magnitude of the range
    double orderOfMagnitude =
        math.pow(10, (math.log(range) / math.ln10).floor()).toDouble();

    // Determine the nice step size based on the order of magnitude
    double niceStepSize;
    if (range / (orderOfMagnitude * (labelCount - 1)) < 1.5) {
      niceStepSize = orderOfMagnitude;
    } else if (range / (orderOfMagnitude * 2.5 * (labelCount - 1)) < 1.5) {
      niceStepSize = orderOfMagnitude * 2;
    } else if (range / (orderOfMagnitude * 5 * (labelCount - 1)) < 1.5) {
      niceStepSize = orderOfMagnitude * 5;
    } else {
      niceStepSize = orderOfMagnitude * 10;
    }

    // Calculate the nice starting value based on the step size
    double niceMinValue = (minValue / niceStepSize).floor() * niceStepSize;

    // Adjust step size to fit the desired label count
    while ((maxValue - niceMinValue) / niceStepSize + 1 < labelCount) {
      niceStepSize /= 2;
      niceMinValue = (minValue / niceStepSize).floor() * niceStepSize;
    }

    // Add 0 as the starting label if it is within the range
    if (niceMinValue > 0) {
      labels.add(0.0);
    }

    // Generate the nice labels
    for (int i = 0; i < labelCount - 1; i++) {
      double label = niceMinValue + i * niceStepSize;
      labels.add(label);
    }

    // Include the maximum value as the last label
    labels.add(maxValue);

    if (labels.length == labelCount) {
      labels.add(maxValue + niceStepSize);
    }

    return labels;
  }
}
