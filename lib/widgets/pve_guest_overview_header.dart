import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'package:pve_flutter_frontend/widgets/pve_guest_icon_widget.dart';

import 'package:pve_flutter_frontend/widgets/pve_resource_status_chip_widget.dart';
import 'package:pve_flutter_frontend/widgets/pve_rrd_chart_widget.dart';

class PveGuestOverviewHeader extends StatelessWidget {
  const PveGuestOverviewHeader({
    Key key,
    @required this.width,
    @required this.guestID,
    @required this.guestStatus,
    @required this.guestName,
    @required this.guestNodeID,
    @required this.guestType,
    @required this.template,
    @required this.ha,
    this.background,
  })  : assert(guestName != null),
        super(key: key);

  final double width;
  final String guestID;
  final String guestType;
  final PveResourceStatusType guestStatus;
  final String guestName;
  final String guestNodeID;
  final Widget background;
  final PveHAMangerServiceStatusModel ha;
  final bool template;
  @override
  Widget build(BuildContext context) {
    final haError = ha?.state == 'error';
    return Container(
      height: 250,
      width: width,
      decoration: BoxDecoration(
        color: Color(0xFF00617F),
      ),
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            if (background != null) background,
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
                          offlineColor: Colors.black38,
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
                        color: Colors.white54,
                        templateColor: Colors.white54,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          guestID,
                          style: TextStyle(
                            color: Colors.white54,
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
                        color: Colors.white54,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          guestNodeID,
                          style: TextStyle(
                            color: Colors.white54,
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
                          color: haError ? Colors.red : Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "HA State",
                            style: TextStyle(
                              color: Colors.white54,
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
  final BuiltList<PveGuestRRDdataModel> rrdData;

  PveGuestHeaderRRDPageView({Key key, this.rrdData}) : super(key: key);

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
    if (widget.rrdData != null && widget.rrdData.isNotEmpty) {
      return PageView.builder(
          controller: controller,
          itemCount: 2,
          itemBuilder: (context, item) {
            final page = item + 1;
            final pageIndicator = Text(
              '$page of 2',
              style: TextStyle(
                color: Colors.white54,
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
                      title: 'CPU (${widget.rrdData.last.maxcpu ?? '-'})',
                      subtitle:
                          (widget.rrdData.last?.cpu ?? 0).toStringAsFixed(2) +
                              "%",
                      data: widget.rrdData.map(
                          (e) => Point(e.time.millisecondsSinceEpoch, e.cpu)),
                      icon: Icon(Icons.memory),
                      bottomRight: pageIndicator,
                      dataRenderer: (data) =>
                          '${data?.toStringAsFixed(2) ?? 0} %',
                    ),
                  ),
                if (item == 1)
                  Expanded(
                    child: PveRRDChart(
                      titlePadding: EdgeInsets.only(bottom: 80),
                      titleWidth: 200,
                      titleAlginment: CrossAxisAlignment.end,
                      title: 'Memory',
                      subtitle:
                          Renderers.formatSize(widget.rrdData.last.mem ?? 0),
                      data: widget.rrdData.map(
                          (e) => Point(e.time.millisecondsSinceEpoch, e.mem)),
                      icon: Icon(Icons.timer),
                      bottomRight: pageIndicator,
                      dataRenderer: (data) => Renderers.formatSize(data ?? 0),
                    ),
                  ),
              ],
            );
          });
    }
    return Container(
      height: 200,
      child: Center(
        child: Text('no rrd data'),
      ),
    );
  }
}
