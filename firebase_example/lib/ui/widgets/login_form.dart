import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_state.dart';

class LoginForm extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginForm({Key? key}) : super(key: key);

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconsState = ref.watch(appStateProvider);
    final iconProvider = ref.watch(appStateProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[100],
              child: const Text(
                'Hello',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(60.0, 20, 60, 20),
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
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                child: const Text('Login'),
                onPressed: () async {
                  if (iconsState.loginIcon == Icons.login) {
                    try {
                      iconProvider.login(context, _emailController.text,
                          _passwordController.text);
                    } catch (e) {
                      showMessage(context, e.toString());
                    }
                  }
                }

                // if (iconsState.loginIcon != Icons.login) {
                //                 Navigator.pop(context);
                //                 return Container();
                //               }
                //               else
                //                 {
                //                   showDialog(
                //                       context: context,
                //                       builder: (context) {
                //                         return AlertDialog(content: Text(iconsState.loginError)
                //                         );
                //                       }
                //                   );
                //                 }
                // if (_formKey.currentState.validate()) {
                //   _signInWithEmailAndPassword();
                // }

                ),
          ),
        ],
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
