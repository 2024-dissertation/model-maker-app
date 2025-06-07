import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

part 'onboarding_state.mapper.dart';

@MappableEnum()
enum UserUseCase {
  hobby(
    icon: Remix.chess_line,
    title: "Hobby",
    description:
        "For personal projects and hobbies, perfect for learning and experimenting",
  ),
  business(
    icon: Remix.inbox_2_line,
    title: "Business",
    description: "For business applications and professional use cases",
  ),
  education(
    icon: Remix.school_line,
    title: "Education",
    description: "For students, teachers, and educational institutions",
  ),
  research(
    icon: Remix.survey_line,
    title: "Research",
    description: "For academic research and scientific projects",
  ),
  work(
    icon: Remix.suitcase_3_line,
    title: "Work",
    description: "For professional work environments and team collaboration",
  ),
  personal(
    icon: Remix.user_3_line,
    title: "Personal",
    description: "For individual use and personal productivity",
  ),
  startup(
    icon: Remix.funds_line,
    title: "Startup",
    description: "For startups and growing businesses",
  ),
  enterprise(
    icon: Remix.user_3_line,
    title: "Enterprise",
    description: "For large organizations and enterprise solutions",
  ),
  non_profit(
    icon: Remix.cash_line,
    title: "Non-profit",
    description: "For non-profit organizations and charitable causes",
  ),
  government(
    icon: Remix.building_3_line,
    title: "Government",
    description: "For government agencies and public sector",
  ),
  healthcare(
    icon: Remix.health_book_line,
    title: "Healthcare",
    description: "For healthcare providers and medical institutions",
  ),
  other(
    icon: Remix.add_line,
    title: "Other",
    description: "For any other use case not listed above",
  );

  final IconData icon;
  final String title;
  final String description;

  const UserUseCase({
    required this.icon,
    required this.title,
    required this.description,
  });
}

@MappableClass()
class OnboardingState with OnboardingStateMappable {
  final UserUseCase? useCase;

  const OnboardingState({
    this.useCase,
  });
}
