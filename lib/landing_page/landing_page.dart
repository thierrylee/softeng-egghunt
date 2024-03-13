import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softeng_egghunt/ask_username/ask_username_page.dart';
import 'package:softeng_egghunt/landing_page/infrastructure/landing_page_bloc.dart';
import 'package:softeng_egghunt/repository/egghunt_repository_provider.dart';
import 'package:softeng_egghunt/score_list/score_list_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LandingPageBloc(usernameRepository: EggHuntRepositoryProvider.getUsernameRepository())
        ..add(LandingPageInitEvent()),
      child: _LandingPageScreen(),
    );
  }
}

class _LandingPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LandingPageBloc, LandingPageState>(
      listener: (context, state) {
        final nextRouteName = switch (state) {
          LandingPageInitialState _ => null,
          LandingPageAskUsernameState _ => AskUsernamePage.routeName,
          LandingPageUsernameAvailableState _ => ScoreListPage.routeName,
        };

        if (nextRouteName != null) {
          Navigator.pushReplacementNamed(context, nextRouteName);
        }
      },
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
