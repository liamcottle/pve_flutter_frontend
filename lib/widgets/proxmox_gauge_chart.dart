import 'dart:math';

import 'package:flutter/material.dart';

class ProxmoxGaugeChartPainter extends CustomPainter {
  final num value;
  final num maxValue;
  final EdgeInsets padding;
  final double strokeWidth;
  final Color foreGroundColor;
  final Color backgroundGroundColor;

  ProxmoxGaugeChartPainter({
    @required this.value,
    @required this.maxValue,
    this.padding = EdgeInsets.zero,
    @required this.strokeWidth,
    @required this.foreGroundColor,
    @required this.backgroundGroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final foregroundPaint = Paint()
      ..color = foreGroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint()
      ..color = backgroundGroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final circleRect = Rect.fromCenter(
        center: size.center(Offset(0, size.height / 2)),
        height: size.width,
        width: size.width);
    canvas.drawArc(
        circleRect, -pi, pi * (value / maxValue), false, foregroundPaint);

    canvas.drawArc(circleRect, -pi, pi, false, backgroundPaint);
  }

  @override
  bool shouldRepaint(ProxmoxGaugeChartPainter oldDelegate) {
    if (oldDelegate.value != value || oldDelegate.maxValue != maxValue) {
      return true;
    }
    return false;
  }
}

class ProxmoxGaugeChart extends StatefulWidget {
  final double value;
  final double maxValue;
  final EdgeInsets padding;
  final Widget info;
  final double strokeWidth;
  final Color foreGroundColor;
  final Color backgroundGroundColor;

  const ProxmoxGaugeChart({
    Key key,
    this.value,
    this.maxValue,
    this.padding = const EdgeInsets.all(6.0),
    this.info,
    this.strokeWidth = 6,
    this.foreGroundColor = Colors.blue,
    this.backgroundGroundColor = Colors.black12,
  }) : super(key: key);
  @override
  _ProxmoxGaugeChartState createState() => _ProxmoxGaugeChartState();
}

class _ProxmoxGaugeChartState extends State<ProxmoxGaugeChart>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Tween<double> _rotationTween;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _rotationTween = Tween(begin: 0, end: widget.value);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.stop();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void didUpdateWidget(ProxmoxGaugeChart oldWidget) {
    if (oldWidget.value != widget.value) {
      _rotationTween.begin = oldWidget.value;
      _rotationTween.end = widget.value;
      controller.reset();
      controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: widget.padding,
        child: CustomPaint(
          painter: ProxmoxGaugeChartPainter(
              value: animation.value,
              maxValue: widget.maxValue,
              padding: widget.padding,
              strokeWidth: widget.strokeWidth,
              foreGroundColor: widget.foreGroundColor,
              backgroundGroundColor: widget.backgroundGroundColor),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedDefaultTextStyle(
              style: Theme.of(context).textTheme.caption,
              duration: kThemeChangeDuration,
              child: widget.info,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ProxmoxGaugeChartListTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget legend;
  final num value;
  final num maxValue;

  const ProxmoxGaugeChartListTile({
    Key key,
    this.title,
    this.subtitle,
    this.legend,
    this.value,
    this.maxValue,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedDefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle1,
                  duration: kThemeChangeDuration,
                  child: title ?? const SizedBox(),
                ),
                AnimatedDefaultTextStyle(
                  style: Theme.of(context).textTheme.caption,
                  duration: kThemeChangeDuration,
                  child: subtitle ?? const SizedBox(),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 50,
            child: ProxmoxGaugeChart(
              value: value ?? 0.0,
              maxValue: maxValue ?? 100.0,
              info: legend ?? const SizedBox(),
            ),
          )
        ],
      ),
    );
  }
}
