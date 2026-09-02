import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/constants/app_strings.dart';
import '../../features/home/home_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/professionals/professionals_screen.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/appointments/appointments_screen.dart';

class AppRouter {
  final AppProvider appProvider;

  AppRouter({required this.appProvider});

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigator => _navigatorKey.currentState!;

  GoRouter get router {
    return GoRouter(
      navigatorKey: _navigatorKey,
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesScreen(),
        ),
        GoRoute(
          path: '/professionals',
          builder: (context, state) => const ProfessionalsScreen(),
        ),
        GoRoute(
          path: '/booking',
          builder: (context, state) => const BookingScreen(),
        ),
        GoRoute(
          path: '/appointments',
          builder: (context, state) => const AppointmentsScreen(),
        ),
      ],
    );
  }
}