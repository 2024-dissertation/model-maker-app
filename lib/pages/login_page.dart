import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/auth/cubit/auth_cubit.dart';
import 'package:frontend/module/auth/cubit/auth_state.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthRepository _authRepository = getIt();

  @override
  void initState() {
    _emailController.text = "laister.sam+scanner@gmail.com";
    _passwordController.text = "password";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login Page'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (context.watch<MyUserCubit>().state is MyUserError)
                  Text(
                    (context.watch<MyUserCubit>().state as MyUserError).message,
                    style: const TextStyle(color: Colors.red),
                  ),
                CupertinoTextField(
                  placeholder: "Email",
                  keyboardType: TextInputType.emailAddress,
                  padding: const EdgeInsets.all(12),
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  placeholder: "Password",
                  obscureText: true,
                  padding: const EdgeInsets.all(12),
                  controller: _passwordController,
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state == AuthState.signedIn) {
                      return CupertinoButton.filled(
                        child: const Text("Log out"),
                        onPressed: () => _authRepository.signOut(),
                      );
                    }
                    if (state == AuthState.initial) {
                      return const CupertinoActivityIndicator();
                    }
                    return CupertinoButton.filled(
                      child: const Text("Login"),
                      onPressed: () =>
                          _authRepository.signInWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                      ),
                    );
                  },
                ),
                Text(context.watch<AuthCubit>().state.toString()),
                Text("${_authRepository.currentUser}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
