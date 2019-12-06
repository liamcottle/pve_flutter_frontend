import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The [ProxmoxTreeWidget] serves as a starting point to represent tree data.
/// If any of the added tree items have children, those do render another subtree
/// currently represented as a [ExpansionTile].

typedef TreeItemClickCallback = void Function(String item);

class ProxmoxTreeItem {
  ProxmoxTreeItem(
      {
      this.id,
      this.headerValue,
      this.isExpanded = false,
      this.children = const <ProxmoxTreeItem>[],
      this.icon,
      this.progressValue,
      this.callback
      });
  String id;
  String headerValue;
  bool isExpanded;
  List<ProxmoxTreeItem> children;
  Icon icon;
  double progressValue;
  TreeItemClickCallback callback;
}


class ProxmoxTreeWidget extends StatefulWidget {
  final List<ProxmoxTreeItem> data;
  const ProxmoxTreeWidget({Key key, this.data,}) : super(key: key);

  @override
  _ProxmoxTreeWidgetState createState() => _ProxmoxTreeWidgetState();
}

class _ProxmoxTreeWidgetState extends State<ProxmoxTreeWidget> {
  List<ProxmoxTreeItem> _data;

  Widget _buildTiles(ProxmoxTreeItem root) {
    assert(root!=null);
    if (root.children.isEmpty)
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ListTile(title: Text(root.headerValue),
        subtitle: root.progressValue != null ? LinearProgressIndicator(
          value: root.progressValue,
          semanticsLabel: "Test",
          semanticsValue: NumberFormat.percentPattern().format(root.progressValue),
        ) : null,
        leading: root.icon,
        onTap: root.callback != null ? () => root.callback(root.id) : null),
      );
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ExpansionTile(
        key: PageStorageKey<String>(root.id),
        title: Text(root.headerValue),
        leading: root.icon,
        children: root.children.map<Widget>(_buildTiles).toList(),
        onExpansionChanged: root.callback != null ? (isExpaned) => root.callback(root.id) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _data = widget.data ?? [];
    return Card(
      child: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) => _buildTiles(_data[index]),
      ),
    );
  }
}
