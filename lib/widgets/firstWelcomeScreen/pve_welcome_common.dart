import 'package:flutter/material.dart';

class PveQuestion extends StatelessWidget {
  final String text;

  const PveQuestion({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 0.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PveAnswer extends StatelessWidget {
  final String text;
  final List<TextSpan> spans;

  const PveAnswer({
    Key key,
    this.text,
    this.spans,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: DefaultTextStyle.of(context).style,
          children: spans,
        ),
      ),
    );
  }
}

class PveWelcomePageContent extends StatelessWidget {
  final Widget child;
  const PveWelcomePageContent({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500), child: child),
      )),
    );
  }
}
