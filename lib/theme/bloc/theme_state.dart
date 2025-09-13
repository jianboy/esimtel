// theme_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final bool isDarkTheme;
  final Color primaryColor;
  final int pickIntColor;

  const ThemeState({
    required this.isDarkTheme,
    required this.primaryColor,
    required this.pickIntColor,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      isDarkTheme: false,
      primaryColor: Color(0xff2323FF),
      pickIntColor: 0xff2323FF,
    );
  }

  ThemeState copyWith({
    bool? isDarkTheme,
    Color? primaryColor,
    int? pickIntColor,
  }) {
    return ThemeState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      primaryColor: primaryColor ?? this.primaryColor,
      pickIntColor: pickIntColor ?? this.pickIntColor,
    );
  }

  @override
  List<Object> get props => [isDarkTheme, primaryColor, pickIntColor];
}
