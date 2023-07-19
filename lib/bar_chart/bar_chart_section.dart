// ignore_for_file: public_member_api_docs, sort_constructors_first
part of bar_chart;

typedef LabelBuilder = void Function(double);

class BarChartSection {
  final double value;
  final String xLabel;
  final Widget? hoverWidget;
  final Offset? hoverWidgetOffset;

  BarChartSection({
    required this.value,
    required this.xLabel,
    this.hoverWidget,
    this.hoverWidgetOffset,
  });
}
