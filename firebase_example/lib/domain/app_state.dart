import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
    (_) => AppStateNotifier());

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState(Icons.sort_by_alpha, Icons.login));

  void setSortIcon(IconData icon) {
    state = AppState(icon, state.loginIcon);
  }

  void setLoginIcon(IconData icon) {
    state = AppState(state.sortIcon, icon);
  }

  void login() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInAnonymously().then((result) {
      state = AppState.newState(state.sortIcon, Icons.logout, result.user!);
    });
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    state = AppState(state.sortIcon, Icons.login);
  }
}

class AppState {
  IconData sortIcon;
  IconData loginIcon;
  late User loggedUser;

  AppState(this.sortIcon, this.loginIcon);

  AppState.newState(this.sortIcon, this.loginIcon, this.loggedUser);
}
