import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/onboarding/cubit/onboarding_cubit.dart';
import 'package:frontend/module/onboarding/cubit/onboarding_state.dart';
import 'package:frontend/ui/primary_card.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';

class UseCasePage extends StatelessWidget {
  const UseCasePage({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(AppPadding.md),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppPadding.sm),
                ThemedText(
                  "We'll tender the app experience to your use case. (This is optional)",
                  color: TextColor.muted,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppPadding.sm),
                Expanded(
                  child: BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (context, state) => GridView.builder(
                      itemCount: UserUseCase.values.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: ThemedCard(
                            outlined:
                                state.useCase == UserUseCase.values[index],
                            onTap: () {
                              if (context
                                      .read<OnboardingCubit>()
                                      .state
                                      .useCase ==
                                  UserUseCase.values[index]) {
                                context.read<OnboardingCubit>().setState(
                                      context
                                          .read<OnboardingCubit>()
                                          .state
                                          .copyWith(
                                            useCase: null,
                                          ),
                                    );
                                return;
                              }
                              context.read<OnboardingCubit>().setState(
                                    context
                                        .read<OnboardingCubit>()
                                        .state
                                        .copyWith(
                                          useCase: UserUseCase.values[index],
                                        ),
                                  );
                            },
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon((UserUseCase.values[index].icon)),
                                  ThemedText(
                                    UserUseCase.values[index].title,
                                    weight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryCard.medium(
                  onTap: () => onBack(),
                  child: ThemedText(
                    "Back",
                    weight: FontWeight.w600,
                    color: TextColor.inverse,
                  ),
                ),
                SizedBox(width: 4),
                PrimaryCard.medium(
                  onTap: () => onContinue(),
                  child: ThemedText(
                    "Continue",
                    weight: FontWeight.w600,
                    color: TextColor.inverse,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
