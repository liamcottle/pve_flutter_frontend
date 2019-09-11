import 'package:flutter/material.dart';

enum ProxmoxLayout { slim, wide, ultrawide }


typedef ProxmoxLayoutLayoutWidgetBuilder = Widget Function(
    BuildContext context, ProxmoxLayout layout);

/// layout.
const double ultraWideLayoutThreshold = 1920;

const double wideLayoutThreshold = 800;

/// Builds a widget tree that can depend on the parent widget's width
class ProxmoxLayoutBuilder extends StatelessWidget {
  const ProxmoxLayoutBuilder({
    @required this.builder,
    Key key,
  })  : assert(builder != null),
        super(key: key);

  /// Builds the widgets below this widget given this widget's layout width.
  final ProxmoxLayoutLayoutWidgetBuilder builder;

  Widget _build(BuildContext context, BoxConstraints constraints) {
    var mediaWidth = MediaQuery.of(context).size.width;
    final ProxmoxLayout layout = mediaWidth >= ultraWideLayoutThreshold
        ? ProxmoxLayout.ultrawide
        : mediaWidth > wideLayoutThreshold ? ProxmoxLayout.wide : ProxmoxLayout.slim;
    return builder(context, layout);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }
}