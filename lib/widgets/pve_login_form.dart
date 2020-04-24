import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/pve_login_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_login_events.dart';
import 'package:pve_flutter_frontend/states/pve_login_state.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_package_info_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_builder_widget.dart';
import 'package:pve_flutter_frontend/widgets/proxmox_stream_listener.dart';
import 'package:provider/provider.dart';
import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';

class PveLoginForm extends StatefulWidget {
  final String savedOrigin;
  PveLoginForm({
    Key key,
    this.savedOrigin,
  }) : super(key: key);

  @override
  State<PveLoginForm> createState() => _PveLoginFormState();
}

class _PveLoginFormState extends State<PveLoginForm> {
  final _originController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  PveLoginBloc lBloc;
  @override
  void initState() {
    super.initState();
    lBloc = Provider.of<PveLoginBloc>(context, listen: false);
    _passwordController.addListener(_onPasswordChanged);
    _usernameController.addListener(_onUsernameChanged);
    _originController.addListener(_onOriginChanged);
    _originController.text = widget.savedOrigin;
  }

  @override
  Widget build(BuildContext context) {
    final aBloc = Provider.of<PveAuthenticationBloc>(context);
    return StreamListener(
      stream: lBloc.state.where((state) => state.isSuccess),
      onStateChange: (newState) {
        aBloc.events.add(LoggedIn(newState.apiClient));
      },
      child: StreamListener(
        stream: aBloc.state.where((state) => state is Authenticated),
        onStateChange: (newState) =>
            Navigator.of(context).pushReplacementNamed('/'),
        child: ProxmoxStreamBuilder<PveLoginBloc, PveLoginState>(
          errorHandler: false,
          bloc: lBloc,
          builder: (context, state) {
            return Theme(
              data: ThemeData.dark().copyWith(accentColor: Color(0xFFE47225)),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        'assets/images/Proxmox_logo_white_orange_800.png'),
                    SizedBox(height: 20),
                    //TODO change this when there's a more official way to determine web e.g. Platform.isWeb or similar
                    if (!kIsWeb)
                      TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.domain),
                            labelText: 'Origin',
                            hintText: 'e.g. https://ip-of-your-pve-host:8006'),
                        controller: _originController,
                        autovalidate: true,
                        validator: (v) =>
                            state.isOriginValid ? null : state.originFieldError,
                      ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Username',
                      ),
                      controller: _usernameController,
                      autovalidate: true,
                      validator: (v) => state.isUsernameValid
                          ? null
                          : state.userNameFieldError,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                      ),
                      controller: _passwordController,
                      obscureText: true,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (v) => state.isPasswordValid
                          ? null
                          : state.passwordFieldError,
                      onFieldSubmitted: (text) => isLoginButtonEnabled(state)
                          ? _onLoginButtonPressed()
                          : null,
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      onPressed: isLoginButtonEnabled(state)
                          ? _onLoginButtonPressed
                          : null,
                      color: Color(0xFFE47225),
                      child: Text('Login'),
                    ),
                    Container(
                      child:
                          state.isLoading ? CircularProgressIndicator() : null,
                    ),
                    ProxmoxPackageInfo()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool get isPopulated =>
      _usernameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(PveLoginState state) {
    return state.isFormValid && isPopulated && !state.isLoading;
  }

  void _onUsernameChanged() {
    // _loginBloc.events.add(
    //   UsernameChanged(username: _usernameController.text),
    // );
  }

  void _onPasswordChanged() {
    lBloc.events.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onOriginChanged() {
    lBloc.events.add(
      OriginChanged(origin: _originController.text),
    );
  }

  _onLoginButtonPressed() {
    lBloc.events.add(LoginWithCredentialsPressed(
        username: _usernameController.text.trim() + "@pam",
        password: _passwordController.text,
        origin: _originController.text.trim()));
  }
}
