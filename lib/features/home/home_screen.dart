import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/booking_provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final bookingProvider = context.read<BookingProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, appProvider),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spaceMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appProvider.isTreatment) _buildPromoSection(context),
                    const SizedBox(height: AppDimensions.spaceLG),
                    _buildQuickActions(context, bookingProvider),
                    const SizedBox(height: AppDimensions.spaceLG),
                    _buildSectionHeader(context, AppStrings.servicesTitle),
                    const SizedBox(height: AppDimensions.spaceSM),
                    _buildServicesPreview(context),
                    const SizedBox(height: AppDimensions.spaceXL),
                    _buildSectionHeader(context, AppStrings.professionalsTitle),
                    const SizedBox(height: AppDimensions.spaceSM),
                    _buildProfessionalsPreview(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider appProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceMD,
        AppDimensions.spaceMD,
        AppDimensions.spaceMD,
        AppDimensions.spaceLG,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.borderRadiusXL),
          bottomRight: Radius.circular(AppDimensions.borderRadiusXL),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.homeTitle,
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXS),
              Text(
                appProvider.isTreatment
                    ? AppStrings.promoTitle
                    : AppStrings.tagline,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: AppColors.textOnPrimary,
              size: AppDimensions.iconSizeLG,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.15),
            AppColors.accentLight.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMD),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.promoTitle,
            style: AppTextStyles.overline,
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(
            AppStrings.promoDescription,
            style: AppTextStyles.promoPrice,
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          const Text(
            AppStrings.promotionalCutsAndBeard,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentDark,
                foregroundColor: AppColors.textOnAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusFull),
                ),
              ),
              child: Text(AppStrings.btnBookNow),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, BookingProvider bookingProvider) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: [
          _buildQuickActionCard(
            context: context,
            icon: Icons.schedule_rounded,
            label: 'Agendar',
            color: AppColors.primary,
            onTap: () => GoRouter.of(context).go('/booking'),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          _buildQuickActionCard(
            context: context,
            icon: Icons.history_rounded,
            label: 'Meus Agts',
            color: AppColors.secondary,
            onTap: () => GoRouter.of(context).go('/appointments'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMD),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textOnPrimary, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.buttonMedium.copyWith(
                fontSize: AppDimensions.fontSizeXS,
                color: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.heading3,
        ),
        TextButton(
          onPressed: () => GoRouter.of(context).go('/services'),
          child: Text(
            'Ver todos',
            style: AppTextStyles.label.copyWith(color: AppColors.accentDark),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesPreview(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSM),
            child: _buildServiceCard(context, index),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, int index) {
    final services = [
      (name: AppStrings.haircut, icon: Icons.content_cut, price: 'R\$ 25', color: AppColors.primary),
      (name: AppStrings.beard, icon: Icons.brush, price: 'R\$ 20', color: AppColors.secondary),
      (name: AppStrings.haircutAndBeard, icon: Icons.style, price: 'R\$ 45', color: AppColors.accentDark),
      (name: AppStrings.eyebrow, icon: Icons.brush, price: 'R\$ 15', color: AppColors.primaryLight),
    ];
    final service = services[index];
    return GestureDetector(
      onTap: () => GoRouter.of(context).go('/services'),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        decoration: BoxDecoration(
          color: service.color,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMD),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(service.icon, color: AppColors.textOnAccent, size: 36),
            const SizedBox(height: AppDimensions.spaceSM),
            Text(
              service.name,
              style: AppTextStyles.buttonMedium.copyWith(
                fontSize: AppDimensions.fontSizeSM,
                color: AppColors.textOnAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              service.price,
              style: AppTextStyles.promoPrice.copyWith(
                color: AppColors.textOnAccent,
                fontSize: AppDimensions.fontSizeMD,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalsPreview(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSM),
            child: _buildProfessionalCard(context, index),
          );
        },
      ),
    );
  }

  Widget _buildProfessionalCard(BuildContext context, int index) {
    final professionals = [
      (name: 'Carlos', specialty: 'Corte & Barba', rating: '5.0', initials: 'CS'),
      (name: 'João', specialty: 'Barba', rating: '4.0', initials: 'JP'),
      (name: 'Ricardo', specialty: 'Premium', rating: '5.0', initials: 'RA'),
      (name: 'Fernanda', specialty: 'Sobr.licha', rating: '4.0', initials: 'FC'),
    ];
    final prof = professionals[index];
    return GestureDetector(
      onTap: () => GoRouter.of(context).go('/professionals'),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  prof.initials,
                  style: AppTextStyles.buttonMedium.copyWith(
                    fontSize: AppDimensions.fontSizeSM,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            Text(
              prof.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              prof.specialty,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: 12, color: AppColors.accent),
                const SizedBox(width: 2),
                Text(
                  prof.rating,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
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