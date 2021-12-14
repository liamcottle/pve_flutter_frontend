import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/utils/proxmox_colors.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_icon_widget.dart';

import 'package:pve_flutter_frontend/widgets/pve_resource_status_chip_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_rrd_chart_widget.dart';
import 'package:pve_flutter_frontend/utils/utils.dart';

class PveGuestOverviewHeader extends StatelessWidget {
  const PveGuestOverviewHeader({
    Key? key,
    required this.width,
    required this.guestID,
    required this.guestStatus,
    required this.guestName,
    required this.guestNodeID,
    required this.guestType,
    required this.template,
    required this.ha,
    this.background,
  })  : assert(guestName != null),
        super(key: key);

  final double width;
  final String guestID;
  final String guestType;
  final PveResourceStatusType? guestStatus;
  final String guestName;
  final String guestNodeID;
  final Widget? background;
  final PveHAMangerServiceStatusModel? ha;
  final bool template;
  @override
  Widget build(BuildContext context) {
    final haError = ha?.state == 'error';
    final fgColor = Theme.of(context).colorScheme.onPrimary.withOpacity(0.75);
    return Container(
      height: 250,
      width: width,
      decoration: BoxDecoration(
        //color: ProxmoxColors.supportBlue,
        //color: Theme.of(context).colorScheme.background,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            if (background != null) background!,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: StatusChip(
                          status: guestStatus,
                          fontzsize: 15.0,
                          fontWeight: FontWeight.w500,
                          offlineColor: fgColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      PveGuestIcon(
                        type: guestType,
                        template: template,
                        status: guestStatus,
                        color: fgColor,
                        templateColor: fgColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          guestID,
                          style: TextStyle(
                            color: fgColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.storage,
                        color: fgColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          guestNodeID,
                          style: TextStyle(
                            color: fgColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (ha?.managed ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.heartbeat,
                          color: haError ? Colors.red : Colors.green[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "HA State",
                            style: TextStyle(
                              color: fgColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ]),
    );
  }
}

class PveGuestHeaderRRDPageView extends StatefulWidget {
  final BuiltList<PveGuestRRDdataModel>? rrdData;

  PveGuestHeaderRRDPageView({Key? key, this.rrdData}) : super(key: key);

  @override
  _PveGuestHeaderRRDPageViewState createState() =>
      _PveGuestHeaderRRDPageViewState();
}

class _PveGuestHeaderRRDPageViewState extends State<PveGuestHeaderRRDPageView> {
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rrdData == null || widget.rrdData!.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text('no rrd data'),
        ),
      );
    }
    var rrdData = widget.rrdData! // safety: checked for null above...
        .where((e) => e.time != null);
    final fgColor = Theme.of(context).colorScheme.onPrimary.withOpacity(0.75);
    return ScrollConfiguration(
      behavior: PVEScrollBehavior(),
      child: PageView.builder(
        controller: controller,
        itemCount: 2,
        itemBuilder: (context, item) {
          final page = item + 1;
          final pageIndicator = Text(
            '$page of 2',
            style: TextStyle(
              color: fgColor,
              fontWeight: FontWeight.w500,
            ),
          );
          return Column(
            children: [
              if (item == 0)
                Expanded(
                  child: PveRRDChart(
                    titlePadding: EdgeInsets.only(bottom: 80),
                    titleWidth: 150,
                    titleAlginment: CrossAxisAlignment.end,
                    title: 'CPU (${rrdData.last.maxcpu ?? '-'})',
                    subtitle: (rrdData.last.cpu ?? 0).toStringAsFixed(2) + "%",
                    data: rrdData.where((e) => e.cpu != null).map(
                        (e) => Point(e.time!.millisecondsSinceEpoch, e.cpu!)),
                    icon: Icon(Icons.memory, color: fgColor),
                    bottomRight: pageIndicator,
                    dataRenderer: (data) => '${data.toStringAsFixed(2)} %',
                  ),
                ),
              if (item == 1)
                Expanded(
                  child: PveRRDChart(
                    titlePadding: EdgeInsets.only(bottom: 80),
                    titleWidth: 200,
                    titleAlginment: CrossAxisAlignment.end,
                    title: 'Memory',
                    subtitle: Renderers.formatSize(rrdData.last.mem ?? 0),
                    data: rrdData.where((e) => e.mem != null).map(
                        (e) => Point(e.time!.millisecondsSinceEpoch, e.mem!)),
                    icon: Icon(FontAwesomeIcons.memory, color: fgColor),
                    bottomRight: pageIndicator,
                    dataRenderer: (data) => Renderers.formatSize(data),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
