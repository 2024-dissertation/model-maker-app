import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/cubit/my_user_cubit.dart';
import 'package:frontend/main.dart';
import 'package:frontend/repositories/auth_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthRepository _authRepository = getIt();

  @override
  void initState() {
    _emailController.text = "laister.sam@gmail.com";
    _passwordController.text = "password";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Register Page'),
      ),
      child: BlocListener<MyUserCubit, MyUserState>(
        listener: (context, state) {},
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (context.watch<MyUserCubit>().state is MyUserError)
                    Text(
                      (context.watch<MyUserCubit>().state as MyUserError)
                          .message,
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
                  CupertinoButton.filled(
                    child: const Text("Register"),
                    onPressed: () => _authRepository.singUpWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    ),
                  ),
                  Text(context.watch<AuthCubit>().state.toString()),
                  Text("${_authRepository.currentUser}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
