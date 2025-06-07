import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/onboarding/cubit/onboarding_cubit.dart';
import 'package:frontend/module/onboarding/cubit/onboarding_state.dart';
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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const ThemedText(
                  "Choose your focus",
                  style: TextType.title,
                ),
                const SizedBox(height: 8),
                ThemedText(
                  "We'll customize the app experience for your needs",
                  color: TextColor.muted,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (context, state) => ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: UserUseCase.values.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final useCase = UserUseCase.values[index];
                        final isSelected = state.useCase == useCase;

                        return _UseCaseOption(
                          useCase: useCase,
                          isSelected: isSelected,
                          onTap: () {
                            if (state.useCase == useCase) {
                              context.read<OnboardingCubit>().setState(
                                    state.copyWith(useCase: null),
                                  );
                            } else {
                              context.read<OnboardingCubit>().setState(
                                    state.copyWith(useCase: useCase),
                                  );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: onBack,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: CupertinoColors.systemGrey4,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.arrow_left,
                                color: CupertinoColors.label,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Back',
                                style: TextStyle(
                                  color: CupertinoColors.label,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: onContinue,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                CupertinoIcons.arrow_right,
                                color: CupertinoColors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UseCaseOption extends StatelessWidget {
  const _UseCaseOption({
    required this.useCase,
    required this.isSelected,
    required this.onTap,
  });

  final UserUseCase useCase;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.systemBlue.withOpacity(0.1)
              : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemGrey4,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? CupertinoColors.systemBlue.withOpacity(0.1)
                    : CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? CupertinoColors.systemBlue
                      : CupertinoColors.systemGrey4,
                  width: 1,
                ),
              ),
              child: Icon(
                useCase.icon,
                color: isSelected
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.label,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    useCase.title,
                    style: TextStyle(
                      color: CupertinoColors.label,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    useCase.description,
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              isSelected
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.circle,
              color: isSelected
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.systemGrey3,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
