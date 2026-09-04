import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_provider.dart';
import 'core/providers/booking_provider.dart';
import 'core/providers/appointments_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const BarberFlowApp());
}

class BarberFlowApp extends StatefulWidget {
  const BarberFlowApp({super.key});

  @override
  State<BarberFlowApp> createState() => _BarberFlowAppState();
}

class _BarberFlowAppState extends State<BarberFlowApp> {
  late final AppProvider _appProvider;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appProvider = AppProvider()..initialize();
    _appRouter = AppRouter(appProvider: _appProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _appProvider),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
