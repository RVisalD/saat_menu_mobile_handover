import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/api/auth.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/models/auth.dart';
import 'package:saatmenumobileapp/presentation/widget/button.dart';
import 'package:saatmenumobileapp/presentation/widget/input.dart';
import 'package:saatmenumobileapp/presentation/widget/loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String isError = '';
  int userType = 3;
  bool isLoading = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        isError = 'Please fill all fields';
      });
      return;
    }

    setState(() {
      isError = '';
      isLoading = true;
    });

    try {
      Auth? authResponse = await AuthService.login(phoneController.text, passwordController.text);
      if(authResponse == null) {
        setState(() {
          isLoading = false;
          isError = 'Login failed. Please try again.';
        });
        return;
      }
      else{
        setState(() {
          isLoading = false;
          isError = '';
        });
        switch (authResponse.staff!.position) {
          case 0:
            Navigator.pushReplacementNamed(context, 'home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, 'waiter_home');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, 'kitchen_home');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, 'cashier_home');
            break;
          default:
            setState(() {
              isError = 'Invalid user position';
            });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = 'Login failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  font2xlbold(
                    'Welcome to Saat Menu',
                    color: const Color(
                      0xFF595959,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputWidget(
                      hintText: 'Phone Number',
                      isNumber: true,
                      controller: phoneController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputWidget(
                      hintText: 'Password',
                      isNumber: false,
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  if (isError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            fontmd(isError, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: ButtonWidget(
                      label: 'Login',
                      onTap: login,
                    ),
                  ),
                ],
              ),
              if (isLoading) const Center(child: LoadingWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
