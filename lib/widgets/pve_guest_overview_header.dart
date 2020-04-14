import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proxmox_dart_api_client/proxmox_dart_api_client.dart';
import 'package:pve_flutter_frontend/utils/renderers.dart';
import 'dart:math' as math;

import 'package:pve_flutter_frontend/widgets/pve_resource_status_chip_widget.dart';

class PveGuestOverviewHeader extends StatelessWidget {
  const PveGuestOverviewHeader({
    Key key,
    @required this.width,
    @required this.guestID,
    @required this.guestStatus,
    @required this.guestName,
    @required this.guestNodeID,
    @required this.guestType,
  })  : assert(guestName != null),
        super(key: key);

  final double width;
  final String guestID;
  final String guestType;
  final PveResourceStatusType guestStatus;
  final String guestName;
  final String guestNodeID;
  @override
  Widget build(BuildContext context) {
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
            Positioned(
              top: -100,
              child: Transform.rotate(
                angle: -math.pi / 4.0,
                child: Container(
                  height: 400,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -40,
              left: 90,
              child: Transform.rotate(
                angle: math.pi / 4.0,
                child: Container(
                  height: 400,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: width * 0.6,
                        child: Text(
                          guestName,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusChip(
                        status: guestStatus,
                        fontzsize: 15.0,
                        fontWeight: FontWeight.w500,
                        offlineColor: Colors.black38,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Renderers.getDefaultResourceIcon(guestType),
                        color: Colors.white54,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.heartbeat,
                        color: Colors.white54,
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
