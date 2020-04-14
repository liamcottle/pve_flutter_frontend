import 'dart:async';
import 'package:flutter/widgets.dart';
typedef StreamStateChange<T> = void Function(T newState);

class StreamListener<T> extends StatefulWidget {
  final Widget child;
  final StreamStateChange<T> onStateChange;
  final Stream<T> stream;

  const StreamListener({
    Key key,
    @required this.stream,
    @required this.child,
    @required this.onStateChange,
  });

  @override
  _StreamListenerState createState() => _StreamListenerState<T>();
}

class _StreamListenerState<T> extends State<StreamListener<T>> {
  Stream<T> get _stream => widget.stream;
  StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _stream.listen(
      onStateChanged,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void onStateChanged(T newState) {
    widget.onStateChange(newState);
  }
}