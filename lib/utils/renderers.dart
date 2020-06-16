import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Renderers {
  static String formatSize(num size) {
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

  static IconData getDefaultResourceIcon(String type, {bool shared = false}) {
    switch (type) {
      case "node":
        return Icons.storage;
      case "qemu":
        return Icons.desktop_windows;

      case "lxc":
        return FontAwesomeIcons.cube;
      case "storage":
        return shared ? Icons.folder_shared : FontAwesomeIcons.database;
      case "pool":
        return Icons.label;
      default:
        return Icons.build;
    }
  }

  static String renderDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static IconData getStorageIcon(String storageType) {
    var icon = Icons.cloud;
    if (storageType == "dir") {
      icon = Icons.folder;
    }

    if (storageType == "nfs") {
      icon = Icons.folder_shared;
    }
    return icon;
  }
}
