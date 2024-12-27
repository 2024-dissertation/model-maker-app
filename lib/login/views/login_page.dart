import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login Page'),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                placeholder: "Email",
                keyboardType: TextInputType.emailAddress,
                padding: EdgeInsets.all(12),
                controller: _emailController,
              ),
              SizedBox(height: 16),
              CupertinoTextField(
                placeholder: "Password",
                obscureText: true,
                padding: EdgeInsets.all(12),
                controller: _passwordController,
              ),
              SizedBox(height: 24),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthSuccess) {
                    return CupertinoButton.filled(
                      child: const Text("Log out"),
                      onPressed: () => context.read<AuthCubit>().logOut(),
                    );
                  }
                  if (state is AuthLoading) {
                    return const CupertinoActivityIndicator();
                  }
                  return CupertinoButton.filled(
                    child: const Text("Login"),
                    onPressed: () =>
                        context.read<AuthCubit>().loginEmailPassword(
                              _emailController.text,
                              _passwordController.text,
                            ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
