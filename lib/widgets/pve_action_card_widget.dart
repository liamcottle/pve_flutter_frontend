import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final Function onTap;
  final String title;
  final Widget icon;
  final Color color;

  const ActionCard({
    Key key,
    this.onTap,
    this.title,
    this.icon,
    this.color = const Color(0xFF00617F),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 80,
            child: Stack(children: [
              Center(
                child: icon,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
