import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PveSubscriptionAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Subscription'),
      content: Text('One or more nodes do not have a valid subscription.\n\n'
          'The Proxmox team works very hard to make sure you are running the best'
          ' software and getting stable updates and security enhancements,'
          ' as well as quick enterprise support.\n\nPlease consider to buy a subscription.'),
      actions: [
        FlatButton(
            onPressed: () async {
              final url = 'https://www.proxmox.com/proxmox-ve/pricing';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text('Get subscription'))
      ],
    );
  }
}
