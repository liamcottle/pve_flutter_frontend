import 'package:flutter/material.dart';
import 'package:pve_flutter_frontend/bloc/pve_authentication_bloc.dart';
import 'package:pve_flutter_frontend/bloc/pve_login_bloc.dart';
import 'package:pve_flutter_frontend/events/pve_login_events.dart';
import 'package:pve_flutter_frontend/states/pve_login_states.dart';

class PveLoginForm extends StatefulWidget {
  final PveLoginBloc loginBloc;
  //final String hostname;

  PveLoginForm({
    Key key,
    @required this.loginBloc,
    //@required this.hostname,
  }) : super(key: key);

  @override
  State<PveLoginForm> createState() => _PveLoginFormState();
}

class _PveLoginFormState extends State<PveLoginForm> {
  final _hostnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  PveLoginBloc get _loginBloc => widget.loginBloc;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
    _usernameController.addListener(_onUsernameChanged);

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PveLoginState>(
      stream: _loginBloc.state,
      initialData: PveLoginState.empty(),
      builder: (BuildContext context, AsyncSnapshot<PveLoginState> snapshot) {
        //_hostnameController.text = widget.hostname;
        if (snapshot.hasData) {
          final state = snapshot.data;
          return Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Proxmox_logo_white_orange_800.png'),
                const SizedBox(height: 20),
                //TODO handle Platfrom specific visibility
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Hostname/IP',
                      labelStyle: TextStyle(color: Color(0xFFFFFFFF))),
                  controller: _hostnameController,

                ),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Color(0xFFFFFFFF))),
                  controller: _usernameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color(0xFFFFFFFF))),
                  controller: _passwordController,
                  obscureText: true,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isPasswordValid ? 'Invalid Password' : null;
                  },
                ),
                const SizedBox(height: 20),
                RaisedButton(
                  onPressed: isLoginButtonEnabled(state)
                      ? _onLoginButtonPressed
                      : null,
                  color: const Color(0xFFE47225),
                  textColor: const Color(0xFFFFFFFF),
                  child: Text('Login'),
                ),
                Container(
                  child:
                      state.isSubmitting ? CircularProgressIndicator() : null,
                ),
              ],
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

  _onLoginButtonPressed() {
    _loginBloc.events.add(LoginWithCredentialsPressed(
      username: _usernameController.text + "@pam",
      password: _passwordController.text,
    ));
  }
}
