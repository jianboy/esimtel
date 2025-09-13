import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esimtel/theme/bloc/theme_event.dart';
import 'package:esimtel/theme/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ChangePrimaryColor>(_onChangePrimaryColor);
    on<ChangeSecondaryColor>(_onChangeSecondaryColor);
    add(const LoadTheme());
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? primaryColorValue = sp.getInt('primaryColor');
    int? secondaryColorValue = sp.getInt('secondaryColor');

    Color primaryColor = primaryColorValue != null
        ? Color(primaryColorValue)
        : const Color(0xff2323FF);
    int pickIntColor = secondaryColorValue ?? 0xff2323FF;

    emit(
      state.copyWith(primaryColor: primaryColor, pickIntColor: pickIntColor),
    );
  }

  Future<void> _onChangePrimaryColor(
    ChangePrimaryColor event,
    Emitter<ThemeState> emit,
  ) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('primaryColor', event.primaryColor.value);

    emit(state.copyWith(primaryColor: event.primaryColor));
  }

  Future<void> _onChangeSecondaryColor(
    ChangeSecondaryColor event,
    Emitter<ThemeState> emit,
  ) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('secondaryColor', event.pickIntColor);

    emit(state.copyWith(pickIntColor: event.pickIntColor));
  }
}
