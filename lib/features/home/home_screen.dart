import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import 'home_variant_a.dart';
import 'home_variant_b.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isTreatment = appProvider.isTreatment;

    if (isTreatment) {
      return const HomeVariantB();
    } else {
      return const HomeVariantA();
    }
  }
}