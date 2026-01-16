import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';
import 'theme/app_theme.dart';

class DataCareApp extends StatelessWidget {
  const DataCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Care',
      theme: AppTheme.light(),
      initialRoute: RouteNames.splash,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
