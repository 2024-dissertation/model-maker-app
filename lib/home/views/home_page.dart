import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..fetchTasks(),
      child: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home Route'),
      ),
      child: SafeArea(
        child: Center(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoaded) {
                return ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    return CupertinoListTile(
                      title: Text(state.tasks[index].title),
                      subtitle: Text(state.tasks[index].description),
                    );
                  },
                );
              } else if (state is HomeError) {
                return Text(state.message);
              } else {
                return const CupertinoActivityIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
