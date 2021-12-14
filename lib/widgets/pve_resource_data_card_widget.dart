import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/utils/proxmox_colors.dart';

class PveResourceDataCardWidget extends StatelessWidget {
  final bool showTitleTrailing;
  final bool expandable;
  final Widget title;
  final Widget? titleTrailing;
  final Widget? subtitle;
  final EdgeInsets padding;
  final List<Widget> children;

  const PveResourceDataCardWidget({
    Key? key,
    this.showTitleTrailing = false,
    required this.title,
    this.titleTrailing,
    this.subtitle,
    required this.children,
    this.padding = const EdgeInsets.all(8.0),
    this.expandable = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Theme(
        data: theme.copyWith(
          listTileTheme: theme.listTileTheme.copyWith(
            textColor: theme.colorScheme.onSurface,
            selectedColor: theme.colorScheme.onSurface,
          ),
        ),
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          child: Builder(
            builder: (context) {
              if (expandable) {
                return ExpansionTile(
                  textColor: theme.colorScheme.onSurface,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      title,
                      if (showTitleTrailing) titleTrailing!,
                    ],
                  ),
                  subtitle: subtitle,
                  children: children,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        title,
                        if (showTitleTrailing) titleTrailing!,
                      ],
                    ),
                    subtitle: subtitle,
                  ),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                  ),
                  ...children
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
