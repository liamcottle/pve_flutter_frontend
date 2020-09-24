import 'package:flutter/material.dart';

class ProxmoxCapacityIndicator extends StatelessWidget {
  final Icon icon;
  final String totalValue;
  final String usedValue;
  final double usedPercent;
  final Color indicatorBackgroundColor;
  final Color textColor;
  final Animation<Color> valueColor;
  final bool selected;

  const ProxmoxCapacityIndicator(
      {Key key,
      this.icon,
      @required this.totalValue,
      @required this.usedValue,
      @required this.usedPercent,
      this.selected = false,
      this.indicatorBackgroundColor,
      this.textColor,
      this.valueColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (usedPercent == null || usedPercent.isNaN || usedPercent.isInfinite) {
      return Container();
    }
    return Theme(
      data: Theme.of(context).copyWith(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 10.0),
                    child: icon ??
                        Icon(
                          Icons.storage,
                          color: selected ? Colors.white : Colors.blueGrey[300],
                        ),
                  ),
                  Text(usedValue,
                      style: TextStyle(
                          color: textColor ?? selected
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Text("Total: $totalValue",
                  style: TextStyle(
                      color: textColor ?? selected
                          ? Colors.white70
                          : Colors.blueGrey[300],
                      fontWeight: FontWeight.bold))
            ],
          ),
          LinearProgressIndicator(
            backgroundColor:
                indicatorBackgroundColor ?? Color.fromARGB(255, 229, 226, 248),
            valueColor: valueColor ?? getUsageAwareColor(usedPercent),
            value: usedPercent,
          )
        ],
      ),
    );
  }

  AlwaysStoppedAnimation<Color> getUsageAwareColor(double usedPercent) {
    if (usedPercent == null) {
      return null;
    }
    if (usedPercent <= 0.5) {
      return AlwaysStoppedAnimation<Color>(Colors.greenAccent);
    }

    if (0.5 < usedPercent && usedPercent <= 0.75) {
      return AlwaysStoppedAnimation<Color>(Colors.yellow);
    }
    if (usedPercent > 0.75) {
      return AlwaysStoppedAnimation<Color>(Colors.red);
    }

    return null;
  }
}
