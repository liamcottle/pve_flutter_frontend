import 'package:flutter/material.dart';

class ClusterStatus extends StatelessWidget {
  const ClusterStatus({
    Key key,
    @required this.isHealthy,
    this.healthyColor = Colors.greenAccent,
    this.warningColor = Colors.orangeAccent,
    this.backgroundColor = Colors.transparent,
    this.version
  }) : super(key: key);

  final bool isHealthy;
  final String version;
  final Color healthyColor;
  final Color warningColor;
  final Color backgroundColor;


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 150.0,
      height: 150.0,
      decoration: new BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
            width: 2.0, color: isHealthy ? healthyColor : warningColor),
        boxShadow: [
          BoxShadow(
            color: isHealthy ? healthyColor : warningColor,
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 3.0, // has the effect of extending the shadow
          )
        ],
      ),
      duration: Duration(seconds: 1),
      child: Center(
        child: Text(version ?? ""),
      ),
    );
  }
}