import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pve_flutter_frontend/utils/proxmox_colors.dart';

// goodbye
class PveWelcomePageLast extends StatelessWidget {
  const PveWelcomePageLast({Key? key, this.onDone}) : super(key: key);

  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(flex: 3),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Enjoy the app"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.emoji_people_rounded,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () => {onDone!()},
                          color: ProxmoxColors.orange,
                          textColor: Colors.white,
                          child: Text("Start"),
                        ),
                      ),
                    ],
                  ),
                  Spacer(flex: 1),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        Text(
                          'If you have suggestions or experience any problems, please contact us via',
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlineButton(
                              onPressed: () =>
                                  {launch('https://forum.proxmox.com')},
                              child: Text('Forum'),
                              borderSide:
                                  BorderSide(color: ProxmoxColors.supportGrey),
                              textColor: Colors.white,
                            ),
                            OutlineButton(
                              onPressed: () => {
                                launch(
                                    'https://lists.proxmox.com/cgi-bin/mailman/listinfo/pve-user')
                              },
                              child: Text('User Mailing List'),
                              borderSide:
                                  BorderSide(color: ProxmoxColors.supportGrey),
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }
}
