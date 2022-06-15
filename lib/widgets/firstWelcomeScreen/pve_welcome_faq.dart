import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pve_flutter_frontend/widgets/firstWelcomeScreen/pve_welcome_common.dart';
import 'package:pve_flutter_frontend/utils/proxmox_colors.dart';

// FAQ
class PveWelcomePageFAQ extends StatelessWidget {
  const PveWelcomePageFAQ({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PveWelcomePageContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PveQuestion(
              text:
                  "How do I connect if I am not using the default port 8006?"),
          PveAnswer(
              text:
                  "Add the port at the end, separated by a colon. For the default https port add 443."),
          PveAnswer(
            text: "For example: 192.168.1.10",
            spans: [
              TextSpan(
                  text: ":443",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
            ],
          ),
          PveQuestion(
            text: "What about remote consoles?",
          ),
          PveAnswer(
              text:
                  "Spice is currently supported. We plan to integrate VNC in the future."),
          PveQuestion(text: "Which Spice client works?"),
          PveAnswer(
              text:
                  'Currently only the following 3rd party Spice client works:'),
          Center(
            child: OutlinedButton(
              onPressed: () => {
                launch(
                    'https://play.google.com/store/apps/details?id=com.undatech.opaque')
              },
              child: Text('Opague', style: TextStyle(
                color: Colors.white,
              )),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ProxmoxColors.supportGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
