import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';
import 'package:frontend/ui/danger_card.dart';
import 'package:frontend/ui/primary_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final userState = context.read<MyUserCubit>().state;
    if (userState is MyUserLoaded) {
      _emailController.text = userState.myUser.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Profile'),
                trailing: TextButton(
                    onPressed: () {
                      context.read<MyUserCubit>().saveUser();
                      context.pop();
                    },
                    child: const Text("Save")),
              ),
              SliverList.list(
                children: [
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: Colors.transparent,
                    header: const ThemedText("Account Email"),
                    children: [
                      CupertinoTextFormFieldRow(
                        placeholder: (context.read<MyUserCubit>().state
                                    is MyUserLoaded) &&
                                ((context.read<MyUserCubit>().state
                                        as MyUserLoaded)
                                    .myUser
                                    .email
                                    .isEmpty)
                            ? "Email not set"
                            : "Email",
                        controller: _emailController,
                        onChanged: (value) =>
                            context.read<MyUserCubit>().updateEmail(value),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppPadding.md),
                child: Column(
                  spacing: 8,
                  children: [
                    DangerCard.medium(
                      onTap: () {
                        context.read<MyUserCubit>().deleteUser();
                        context.pop();
                      },
                      child: const Row(
                        children: [
                          ThemedText(
                            'Submit Account Deletion',
                            color: TextColor.inverse,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    // PrimaryCard.medium(
                    //   onTap: () {
                    //     context.read<AuthCubit>().signOut();
                    //     context.pop();
                    //   },
                    //   child: const Row(
                    //     children: [
                    //       ThemedText(
                    //         'Request Data',
                    //         color: TextColor.inverse,
                    //         weight: FontWeight.w600,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
