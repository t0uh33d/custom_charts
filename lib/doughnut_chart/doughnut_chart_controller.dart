part of doughnut_chart;

typedef OnDoughnutChartControllerCreationCallBack = void Function(
    DoughnutChartController controller);

typedef ChartStateUpdator = void Function(void Function() fn);

class DoughnutChartController {
  int hoverIndex = -1;
  late double _radius;
  late double _innerRadius;
  late Offset _center;

  late double _height;
  late double _width;
  late double _strokeWidth;

  late List<DoughnutChartSection> _data;

  late ChartStateUpdator _chartStateUpdator;

  late double _strokeOffset;
  late double _hoverOffset;

  final Map<int, AngleRange> _angleRangeMap = {};

  void _init({
    required double height,
    required double width,
    required double strokeWidth,
    required List<DoughnutChartSection> doughnutChartSections,
    required double hoverOffset,
    required ChartStateUpdator stateUpdator,
  }) {
    _height = height;
    _width = width;
    _strokeWidth = strokeWidth;
    _data = doughnutChartSections;
    _chartStateUpdator = stateUpdator;
    _strokeOffset = strokeWidth / 2;
    _hoverOffset = hoverOffset;
    _computeProperties();
  }

  void _computeProperties() {
    _center = Offset(_width / 2, _height / 2);
    _radius = min(_height / 2, _width / 2) - _strokeOffset;
    _innerRadius = _radius - _strokeWidth;
  }

  void _chartInteractionListener(PointerHoverEvent event) {
    double x = event.localPosition.dx;
    double y = event.localPosition.dy;

    double distance = sqrt(pow(x - _center.dx, 2) + pow(y - _center.dy, 2)) -
        (_strokeWidth / 2);
    if (distance < _radius && distance > _innerRadius) {
      double angle = atan2(y - _center.dy, x - _center.dx);

      int index = _getIndex(_convertRange0to2pi(_convertToDegrees(angle)));

      if (index != hoverIndex) {
        _chartStateUpdator.call(() {
          hoverIndex = index;
        });
      }
    } else {
      if (hoverIndex != -1) {
        _chartStateUpdator.call(() {
          hoverIndex = -1;
        });
      }
    }
  }

  void _mapAngleToIndices(double startAngle, double sweepAngle, int idx) {
    double start = _convertToDegrees(startAngle);
    double sweep = _convertToDegrees(sweepAngle);

    _angleRangeMap[idx] = AngleRange(
      start: _convertRange0to2pi(start),
      end: _convertRange0to2pi(sweep),
    );

    print(
      "$idx : start -  ${_convertRange0to2pi(start).ceil()} : end - ${_convertRange0to2pi(sweep).ceil()}",
    );
  }

  double _convertToDegrees(double angle) {
    return angle * (180 / pi);
  }

  double _convertRange0to2pi(double angle) {
    if (angle < 0) {
      return 360 + angle;
    } else {
      return angle;
    }
  }

  double _normalizeAngle(double angle) {
    if (angle < -180) {
      angle += 360;
    }

    if (angle >= 180) {
      angle -= 360;
    }

    return angle;
  }

  int _getIndex(double angle) {
    for (int idx = 0; idx < _data.length; idx++) {
      AngleRange angleRange = _angleRangeMap[idx]!;

      if (angle > angleRange.start && angle < angleRange.end) {
        return idx;
      }
    }
    return -1;
  }
}
