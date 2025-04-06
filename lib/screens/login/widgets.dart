import 'package:flutter/material.dart';
import 'package:penouel/core/constants/colors.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/constants/texts.dart';
import 'package:penouel/core/constants/icons.dart';

/// Widget pour l'entête de la page de connexion avec logo et titre
class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo centré
        Container(
          height: AppSizes.percentHeight(18),
          width: AppSizes.percentHeight(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          // Remplacez cette image par votre logo
          child: Center(
            child: Icon(
              IconManager.getIconData('school'),
              size: AppSizes.percentHeight(10),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        SizedBox(height: AppSizes.paddingMedium),

        // Titre de l'application
        Text(
          "Communauté Spirituelle",
          style: AppTextStyles.heading2.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: AppSizes.paddingSmall),

        // Sous-titre
        Text(
          "Connectez-vous pour accéder à l'application",
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Champ de texte personnalisé pour l'écran de connexion
class LoginTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String prefixIcon;
  final String? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const LoginTextInput({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight.withOpacity(0.6)),
        prefixIcon: IconManager.getIcon(prefixIcon, color: Theme.of(context).colorScheme.primary),
        suffixIcon:
            suffixIcon != null
                ? GestureDetector(
                  onTap: onSuffixIconTap,
                  child: IconManager.getIcon(suffixIcon!, color: Theme.of(context).colorScheme.primary),
                )
                : null,
        contentPadding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium, horizontal: AppSizes.paddingMedium),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.textLight.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: AppColors.textLight.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

/// Bouton de connexion avec état de chargement
class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoginButton({Key? key, required this.text, required this.onPressed, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingLarge),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSmall)),
        elevation: 2,
      ),
      child:
          isLoading
              ? SizedBox(
                height: AppSizes.bodyLarge,
                width: AppSizes.bodyLarge,
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary, strokeWidth: 3),
              )
              : Text(text, style: AppTextStyles.buttonText),
    );
  }
}

/// Texte d'information sur l'accès restreint
class LoginInfoText extends StatelessWidget {
  const LoginInfoText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          IconManager.getIcon('info_outline', color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          SizedBox(width: AppSizes.paddingSmall),
          Expanded(
            child: Text(
              "L'accès à cette application est restreint aux membres autorisés. Contactez l'administrateur si vous avez besoin d'un accès.",
              style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
