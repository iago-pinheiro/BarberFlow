import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/professional_model.dart';
import '../../data/repositories/professional_repository.dart';
import '../../core/providers/booking_provider.dart';

class ProfessionalsScreen extends StatelessWidget {
  const ProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final profRepo = ProfessionalRepository();

    final professionals = bookingProvider.state.selectedServiceId != null
        ? profRepo.getAvailableProfessionals(
            bookingProvider.state.selectedServiceId!,
          )
        : profRepo.getProfessionals();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Barbeiros')),
      body: professionals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_rounded,
                    size: 56,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppDimensions.spaceMD),
                  Text(
                    'Nenhum barbeiro disponível',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.spaceMD),
              itemCount: professionals.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildProfessionalCard(
                  context,
                  professionals[index],
                  bookingProvider,
                );
              },
            ),
    );
  }

  Widget _buildProfessionalCard(
    BuildContext context,
    Professional professional,
    BookingProvider bookingProvider,
  ) {
    final isSelected =
        bookingProvider.state.selectedProfessionalId == professional.id;
    final availableSlots = professional.availableHours.length;

    return GestureDetector(
      onTap: () {
        bookingProvider.selectProfessional(professional.id);
        context.go('/booking');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : AppColors.iconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  professional.name.split(' ').map((n) => n[0]).take(2).join(),
                  style: AppTextStyles.heading3.copyWith(
                    color: isSelected
                        ? AppColors.accentDark
                        : AppColors.primary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.name,
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(professional.specialty, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        professional.rating.toString(),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$availableSlots horários disponíveis',
                        style: AppTextStyles.caption.copyWith(
                          color: availableSlots > 3
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.textOnAccent,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
