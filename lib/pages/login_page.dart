import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_login_bloc.dart';
import 'package:pve_flutter_frontend/widgets/pve_login_form.dart';

class PveLoginPage extends StatefulWidget {
  final PveLoginBloc loginBloc;
  final PveAuthenticationBloc authenticationBloc;
  static const routeName = '/login';

  PveLoginPage({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<PveLoginPage> createState() => _PveLoginPageState();
}

class _PveLoginPageState extends State<PveLoginPage> {
  PveLoginBloc get _loginBloc => widget.loginBloc;
  PveAuthenticationBloc get _authenticationBloc => widget.authenticationBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc.state.where((state) => state.isSuccess).forEach(
        (loginSucceded) => _authenticationBloc.events.add(
            LoggedIn(loginSucceded.apiClient)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF2C3443), const Color(0xFF3A465F)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: PveLoginForm(
                loginBloc: _loginBloc,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
