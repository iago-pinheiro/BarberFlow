import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../data/models/service_model.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/professional_repository.dart';
import '../../core/providers/booking_provider.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceRepo = ServiceRepository();
    final bookingProvider = context.watch<BookingProvider>();
    final services = serviceRepo.getServices();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.servicesTitle),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceTile(context, service, bookingProvider);
        },
      ),
    );
  }

  Widget _buildServiceTile(BuildContext context, Service service, BookingProvider bookingProvider) {
    return GestureDetector(
      onTap: () {
        bookingProvider.selectService(service.id);
        GoRouter.of(context).go('/professionals');
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
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSM),
              ),
              child: Center(
                child: _getServiceIcon(service.type),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R\$ ${service.price.toStringAsFixed(2)}',
                  style: AppTextStyles.promoPrice,
                ),
                const SizedBox(height: 2),
                Text(
                  '${service.duration}${AppStrings.minutes}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.haircut:
        return const Icon(Icons.content_cut_rounded, color: AppColors.textOnAccent, size: 28);
      case ServiceType.beard:
        return const Icon(Icons.format_color_fill_rounded, color: AppColors.textOnAccent, size: 28);
      case ServiceType.haircutAndBeard:
        return const Icon(Icons.auto_fix_high_rounded, color: AppColors.textOnAccent, size: 28);
      case ServiceType.eyebrow:
        return const Icon(Icons.brush, color: AppColors.textOnAccent, size: 28);
    }
  }
}