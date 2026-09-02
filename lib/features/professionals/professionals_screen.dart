import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../data/models/professional_model.dart';
import '../../data/repositories/professional_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../core/providers/booking_provider.dart';

class ProfessionalsScreen extends StatelessWidget {
  const ProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final serviceRepo = ServiceRepository();
    final profRepo = ProfessionalRepository();

    List<Professional> professionals;
    if (bookingProvider.state.selectedServiceId != null) {
      professionals = profRepo.getAvailableProfessionals(bookingProvider.state.selectedServiceId!);
    } else {
      professionals = profRepo.getProfessionals();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.professionalsTitle),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        itemCount: professionals.length,
        itemBuilder: (context, index) {
          return _buildProfessionalTile(context, professionals[index], bookingProvider);
        },
      ),
    );
  }

  Widget _buildProfessionalTile(BuildContext context, Professional professional, BookingProvider bookingProvider) {
    return GestureDetector(
      onTap: () {
        bookingProvider.selectProfessional(professional.id);
        GoRouter.of(context).go('/booking');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  professional.name.split(' ').map((n) => n[0]).join(),
                  style: AppTextStyles.buttonMedium.copyWith(
                    fontSize: AppDimensions.fontSizeSM,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.name,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    professional.specialty,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 16, color: AppColors.accent),
                const SizedBox(width: 4),
                Text(
                  '${professional.rating}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}