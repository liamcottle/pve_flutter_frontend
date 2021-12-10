import 'package:flutter/material.dart';

class PveResourceDataCardWidget extends StatelessWidget {
  final bool showTitleTrailing;
  final bool expandable;
  final Widget? title;
  final Widget? titleTrailing;
  final Widget? subtitle;
  final EdgeInsets padding;
  final List<Widget>? children;

  const PveResourceDataCardWidget({
    Key? key,
    this.showTitleTrailing = false,
    this.title,
    this.titleTrailing,
    this.subtitle,
    this.children,
    this.padding = const EdgeInsets.all(8.0),
    this.expandable = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        color: Colors.white,
        child: Builder(
          builder: (context) {
            if (expandable) {
              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    title!,
                    if (showTitleTrailing) titleTrailing!,
                  ],
                ),
                subtitle: subtitle,
                children: children!,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      title!,
                      if (showTitleTrailing) titleTrailing!,
                    ],
                  ),
                  subtitle: subtitle,
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                ...children!
              ],
            );
          },
        ),
      ),
    );
  }
}
