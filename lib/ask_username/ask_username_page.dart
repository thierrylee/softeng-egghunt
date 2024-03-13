import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softeng_egghunt/ask_username/infastructure/ask_username_bloc.dart';
import 'package:softeng_egghunt/repository/egghunt_repository_provider.dart';
import 'package:softeng_egghunt/score_list/score_list_page.dart';

class AskUsernamePage extends StatelessWidget {
  static const String routeName = "/askUsername";

  const AskUsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Qui est-tu ??")),
      body: BlocProvider(
        create: (context) => AskUsernameBloc(usernameRepository: EggHuntRepositoryProvider.getUsernameRepository()),
        child: _AskUsernameScreen(),
      ),
    );
  }
}

class _AskUsernameScreen extends StatefulWidget {
  @override
  State<_AskUsernameScreen> createState() => _AskUsernameScreenState();
}

class _AskUsernameScreenState extends State<_AskUsernameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AskUsernameBloc, AskUsernameState>(
      listener: (context, state) {
        if (state is AskUsernameSubmitSuccess) {
          Navigator.pushReplacementNamed(context, ScoreListPage.routeName);
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Ton polygramme (obligatoire)",
                  hintText: "Exemple: LOL",
                  helperText: "3 caractères minimum, 4 maximum",
                  suffixIcon: InkWell(
                    onTap: () => _controller.clear(),
                    child: const Icon(Icons.clear),
                  ),
                  errorText: _buildErrorText(),
                ),
                maxLength: 4,
                onSubmitted: (value) => context.read<AskUsernameBloc>().add(AskUsernameSubmitEvent(username: value)),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _buildSubmitCallback(),
                child: const Text("Valider"),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _buildErrorText() {
    if (_controller.value.text.isEmpty) {
      return null;
    } else if (_controller.value.text.length > 4 || _controller.value.text.length < 3) {
      return "3 caractères minimum, 4 maximum";
    }
    return null;
  }

  Function()? _buildSubmitCallback() {
    if (_controller.value.text.length >= 3 && _controller.value.text.length <= 4) {
      return () => context.read<AskUsernameBloc>().add(AskUsernameSubmitEvent(username: _controller.value.text));
    }
    return null;
  }
}
