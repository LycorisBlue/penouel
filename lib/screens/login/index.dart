import 'package:flutter/material.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/utils/snackbar_utils.dart';
import 'package:penouel/services/navigation_service.dart';
import 'widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Valide le formulaire et procède à la connexion (simulation)
  void _login() {
    if (_formKey.currentState!.validate()) {
      // Simuler un temps de chargement pour montrer l'état de chargement
      setState(() => _isLoading = true);

      // Simuler une action de connexion
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);

          // Simuler une connexion réussie
          SnackBarUtils.showSuccess(context, "Connexion réussie, bienvenue!");

          // Naviguer vers l'écran d'accueil après connexion réussie
          Routes.navigateAndRemoveAll(Routes.home);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialise les tailles responsives
    AppSizes.initialize(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo et titre
                const LoginHeader(),

                SizedBox(height: AppSizes.percentHeight(4)),

                // Formulaire
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Champ email
                      LoginTextInput(
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: 'email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer votre email";
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return "Veuillez entrer un email valide";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppSizes.paddingMedium),

                      // Champ mot de passe
                      LoginTextInput(
                        controller: _passwordController,
                        hintText: "Mot de passe",
                        prefixIcon: 'password',
                        obscureText: !_isPasswordVisible,
                        suffixIcon: _isPasswordVisible ? 'visibility_on' : 'visibility_off',
                        onSuffixIconTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer votre mot de passe";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppSizes.paddingLarge * 1.5),

                      // Bouton de connexion
                      LoginButton(text: "Se connecter", isLoading: _isLoading, onPressed: _isLoading ? null : _login),

                      SizedBox(height: AppSizes.paddingMedium),

                      // Information sur l'accès restreint
                      const LoginInfoText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
