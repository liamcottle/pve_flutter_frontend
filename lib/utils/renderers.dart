import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';

class Renderers {
  static const supportLevelMap = {
    'c': 'Community',
    'b': 'Basic',
    's': 'Standard',
    'p': 'Premium',
  };

  static String formatSize(num? size) {
    if (size == null) {
      return 'NaN';
    }
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

  static String renderStorageContent(PveNodesStorageContentModel content) {
    return content.volid!.replaceAll(RegExp(r"^.*?:(.*?\/)?"), '');
  }

  static IconData getDefaultResourceIcon(String type, {bool? shared = false}) {
    switch (type) {
      case "node":
        return Icons.storage;
      case "qemu":
        return Icons.desktop_windows;

      case "lxc":
        return FontAwesomeIcons.cube;
      case "storage":
        return (shared ?? false)
            ? Icons.folder_shared
            : FontAwesomeIcons.database;
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

    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inDays > 0) {
      return "${duration.inDays}d $hours:$minutes:$seconds";
    } else {
      return "$hours:$minutes:$seconds";
    }
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

  static String renderSupportLevel(String? level) {
    var lvl = level ?? 'none';
    return supportLevelMap[level!] ?? 'no support';
  }
}
