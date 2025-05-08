import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

part 'onboarding_state.mapper.dart';

@MappableEnum()
enum UserUseCase {
  hobby(icon: Remix.chess_line, title: "Hobby"),
  business(icon: Remix.inbox_2_line, title: "Business"),
  education(icon: Remix.school_line, title: "Education"),
  research(icon: Remix.survey_line, title: "Research"),
  work(icon: Remix.suitcase_3_line, title: "Work"),
  personal(icon: Remix.user_3_line, title: "Personal"),
  startup(icon: Remix.funds_line, title: "Startup"),
  enterprise(icon: Remix.user_3_line, title: "Enterprise"),
  non_profit(icon: Remix.cash_line, title: "Non-profit"),
  government(icon: Remix.building_3_line, title: "Government"),
  healthcare(icon: Remix.health_book_line, title: "Healthcare"),
  other(icon: Remix.add_line, title: "Other");

  final IconData icon;
  final String title;

  const UserUseCase({
    required this.icon,
    required this.title,
  });
}

@MappableClass()
class OnboardingState with OnboardingStateMappable {
  final UserUseCase? useCase;

  const OnboardingState({
    this.useCase,
  });
}
