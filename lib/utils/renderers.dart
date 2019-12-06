import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Renderers {
  static String formatSize(int size) {
    var converted = size.toDouble();
    var units = ['', 'Ki', 'Mi', 'Gi', 'Ti', 'Pi', 'Ei', 'Zi', 'Yi'];
    var num = 0;

    while (converted >= 1024 && ((num++) + 1) < units.length) {
      converted = converted / 1024;
    }

    return converted.toStringAsFixed((num > 0) ? 2 : 0) +
        " " +
        units[num] +
        "B";
  }

  static String renderStorageContent(String volid) {
    return volid.replaceAll(RegExp(r"^.*:(.*\/)?"), '');
  }

  static Icon getDefaultResourceIcon(String type, bool shared, String status) {
    switch (type) {
      case "node":
        return Icon(Icons.storage);
      case "qemu":
        return Icon(Icons.desktop_windows);

      case "lxc":
        return Icon(Icons.layers);
      case "storage":
        return shared
            ? Icon(
                Icons.folder_shared,
                color: status != 'available' ? Colors.orange : Colors.green,
              )
            : Icon(FontAwesomeIcons.database,
                color: status != 'available' ? Colors.orange : Colors.green);
      case "pool":
        return Icon(Icons.label);
      default:
        return Icon(Icons.build);
    }
  }
}
