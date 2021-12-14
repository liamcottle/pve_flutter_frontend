import 'package:flutter/material.dart';

class ProxmoxCapacityIndicator extends StatelessWidget {
  final Icon? icon;
  final String totalValue;
  final String usedValue;
  final double? usedPercent;
  final Color? indicatorBackgroundColor;
  final Color? textColor;
  final Animation<Color>? valueColor;
  final bool selected;

  const ProxmoxCapacityIndicator(
      {Key? key,
      this.icon,
      required this.totalValue,
      required this.usedValue,
      required this.usedPercent,
      this.selected = false,
      this.indicatorBackgroundColor,
      this.textColor,
      this.valueColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (usedPercent == null || usedPercent!.isNaN || usedPercent!.isInfinite) {
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 8.0),
                    child: icon ??
                        Icon(Icons.storage,
                            color: (selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.75))),
                  ),
                  Text(usedValue,
                      style: TextStyle(
                          color: textColor ??
                              (selected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground)
                                  .withOpacity(0.66),
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Text("Total: $totalValue",
                  style: TextStyle(
                      color: textColor ??
                          (selected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onBackground)
                              .withOpacity(0.66),
                      fontWeight: FontWeight.bold))
            ],
          ),
          LinearProgressIndicator(
            backgroundColor: indicatorBackgroundColor ??
                Theme.of(context).colorScheme.onPrimary,
            valueColor: valueColor ?? getUsageAwareColor(usedPercent),
            value: usedPercent,
          )
        ],
      ),
    );
  }

  AlwaysStoppedAnimation<Color>? getUsageAwareColor(double? usedPercent) {
    if (usedPercent == null) {
      return null;
    }

    if (usedPercent < 0.75) {
      return AlwaysStoppedAnimation<Color>(Colors.green[400]!);
    } else if (usedPercent < 0.85) {
      return AlwaysStoppedAnimation<Color>(Colors.yellow);
    } else {
      return AlwaysStoppedAnimation<Color>(Colors.red);
    }
  }
}
