import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/pve_login_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_login_events.dart';
import 'package:pve_flutter_frontend/states/pve_login_states.dart';

class PveLoginForm extends StatefulWidget {
  final PveLoginBloc loginBloc;

  PveLoginForm({
    Key key,
    @required this.loginBloc,
  }) : super(key: key);

  @override
  State<PveLoginForm> createState() => _PveLoginFormState();
}

class _PveLoginFormState extends State<PveLoginForm> {
  final _originController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  PveLoginBloc get _loginBloc => widget.loginBloc;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
    _usernameController.addListener(_onUsernameChanged);
    _originController.addListener(_onOriginChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginBloc.state
        .where((state) => state.isFailure)
        .listen((state) => Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                state.errorMessage ?? "Error",
                style: ThemeData.dark().textTheme.button,
              ),
              backgroundColor: ThemeData.dark().errorColor,
              behavior: SnackBarBehavior.floating,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PveLoginState>(
      stream: _loginBloc.state,
      initialData: PveLoginState.empty(),
      builder: (BuildContext context, AsyncSnapshot<PveLoginState> snapshot) {
        if (snapshot.hasData) {
          final state = snapshot.data;
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
                  if(!kIsWeb)
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.domain),
                        labelText: 'Origin',
                        hintText: 'e.g. https://ip-of-your-pve-host:8006'),
                    controller: _originController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Username',),
                    controller: _usernameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',),
                    controller: _passwordController,
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
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
                        state.isSubmitting ? CircularProgressIndicator() : null,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  bool get isPopulated =>
      _usernameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(PveLoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _onUsernameChanged() {
    // _loginBloc.events.add(
    //   UsernameChanged(username: _usernameController.text),
    // );
  }

  void _onPasswordChanged() {
    _loginBloc.events.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onOriginChanged() {
    _loginBloc.events.add(
      OriginChanged(origin: _originController.text),
    );
  }

  _onLoginButtonPressed() {
    _loginBloc.events.add(LoginWithCredentialsPressed(
      username: _usernameController.text + "@pam",
      password: _passwordController.text,
      origin: _originController.text
    ));
  }
}
