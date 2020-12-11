import 'package:flutter/material.dart';

// Big Logo
class PveWelcomePageLogo extends StatelessWidget {
  const PveWelcomePageLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: IntrinsicHeight(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 160, maxHeight: 180),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                          child: Image.asset(
                            'assets/images/Proxmox-logo-symbol-white-orange.png',
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Proxmox Virtual Environment',
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                    ]),
              ))));
    }));
  }
}
