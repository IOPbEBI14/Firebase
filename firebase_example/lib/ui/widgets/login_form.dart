import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_state.dart';

class LoginForm extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconsState = ref.watch(appStateProvider);
    final iconProvider = ref.watch(appStateProvider.notifier);
    ref.listen(appStateProvider, (AppState? prevState, AppState newState) {
      if (newState.loginError.isNotEmpty) {
        showMessage(context, newState.loginError);
      } else {
        Navigator.of(context).pop();
      }
    });
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[100],
                child: const Text(
                  'Hello',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(60.0, 20, 60, 0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'email',
                      labelStyle: const TextStyle(color: Colors.purple),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: Colors.purple)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: Colors.purple)),
                    ),
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      labelText: 'password',
                      labelStyle: const TextStyle(color: Colors.purple),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: Colors.purple)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: Colors.purple)),
                    ),
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: const Text('          Login          '),
                  onPressed: () async {
                    if (iconsState.loginIcon == Icons.login) {
                      try {
                        iconProvider.login(context, _emailController.text,
                            _passwordController.text);
                      } catch (e) {
                        showMessage(context, e.toString());
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool showMessage(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        });
    return true;
  }
}
