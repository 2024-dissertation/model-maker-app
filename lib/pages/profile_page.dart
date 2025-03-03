import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';
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
      child: CustomScrollView(
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
                header: const Text("Details"),
                children: [
                  CupertinoTextFormFieldRow(
                    placeholder: "Email",
                    controller: _emailController,
                    onChanged: (value) =>
                        context.read<MyUserCubit>().updateEmail(value),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
