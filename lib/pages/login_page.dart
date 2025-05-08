import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/analytics/cubit/analytics_cubit.dart';
import 'package:frontend/module/auth/cubit/auth_cubit.dart';
import 'package:frontend/module/auth/cubit/auth_state.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:frontend/module/collections/cubit/collection_cubit.dart';
import 'package:frontend/module/home/cubit/home_cubit.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';
import 'package:frontend/ui/themed/themed_text.dart';

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
    // _emailController.text = "laister.sam+scanner@gmail.com";
    // _passwordController.text = "password";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemedText("Login", style: TextType.title),
            SizedBox(height: AppPadding.md),
            ThemedText("This is only for admins, please sign in with Apple",
                color: TextColor.muted),
            SizedBox(height: AppPadding.md),
            if (context.watch<MyUserCubit>().state is MyUserError)
              ThemedText(
                (context.watch<MyUserCubit>().state as MyUserError).message,
                color: TextColor.inverse,
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
                    child: const ThemedText("Log out"),
                    onPressed: () {
                      context.read<HomeCubit>().clear();
                      context.read<AnalyticsCubit>().clear();
                      context.read<CollectionCubit>().clear();
                      _authRepository.signOut();
                    },
                  );
                }
                if (state == AuthState.initial) {
                  return const CupertinoActivityIndicator();
                }
                return Center(
                  child: CupertinoButton.filled(
                    child: const ThemedText("Login"),
                    onPressed: () => _authRepository.signInWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
