import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/widgets/firstWelcomeScreen/pve_welcome_common.dart';

// disable ssl validation hint
class PveWelcomePageSSLValidation extends StatelessWidget {
  const PveWelcomePageSSLValidation({
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
            text: "Are you using a self signed certificate?",
          ),
          PveAnswer(
              text: "Disable SSL Validation in the Login Manager settings."),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.5)),
                  child: Image.asset(
                    'assets/images/ssl_validate/login_manager_screen.png',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.5)),
                  child: Image.asset(
                    'assets/images/ssl_validate/login_manager_screen_settings.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
