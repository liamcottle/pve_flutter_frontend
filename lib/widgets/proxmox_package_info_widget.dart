import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class ProxmoxPackageInfo extends StatefulWidget {
  @override
  _ProxmoxPackageInfoState createState() => _ProxmoxPackageInfoState();
}

class _ProxmoxPackageInfoState extends State<ProxmoxPackageInfo> {
  Future<PackageInfo>? packageInfo;

  @override
  Widget build(BuildContext context) {
    packageInfo = PackageInfo.fromPlatform();
    return FutureBuilder<PackageInfo>(
      future: packageInfo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!.version + snapshot.data!.buildNumber,
            style: TextStyle(color: Colors.white30),
          );
        }
        return Container();
      },
    );
  }
}
