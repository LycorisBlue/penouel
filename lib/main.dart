import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:penouel/core/constants/sizes.dart';
import 'package:penouel/core/constants/themes.dart';
import 'package:penouel/services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('fr_FR', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Routes.navigatorKey,
      title: 'Votre App',
      theme: AppTheme.lightTheme,
      initialRoute: Routes.home,
      onGenerateRoute: Routes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Initialisation des tailles responsives dès que le contexte est disponible
        AppSizes.initialize(context);

        // S'assurer que le texte ne soit pas mis à l'échelle par les paramètres du système
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)), child: child!);
      },
    );
  }
}
