part of doughnut_chart;

class DoughnutChartSection {
  final double value;
  final Color color;
  final Widget hoverWidget;

  DoughnutChartSection({
    required this.value,
    required this.color,
    required this.hoverWidget,
  });
}

class AngleRange {
  final double start;
  final double end;
  AngleRange({
    required this.start,
    required this.end,
  });
}
