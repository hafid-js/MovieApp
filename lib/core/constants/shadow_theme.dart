import 'package:flutter/material.dart';

@immutable
class AppShadow extends ThemeExtension<AppShadow> {
  final List<BoxShadow> small;
  final List<BoxShadow> medium;
  final List<BoxShadow> large;

  const AppShadow({
    required this.small,
    required this.medium,
    required this.large,
  });

  @override
  AppShadow copyWith({
    List<BoxShadow>? small,
    List<BoxShadow>? medium,
    List<BoxShadow>? large,
  }) {
    return AppShadow(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
    );
  }

  @override
  AppShadow lerp(ThemeExtension<AppShadow>? other, double t) {
    return this;
  }
}