import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/booking_provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, appProvider)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppDimensions.spaceLG),
                  if (appProvider.isTreatment) ...[
                    _buildPromoCard(context),
                    const SizedBox(height: AppDimensions.spaceLG),
                  ],
                  _buildQuickActions(context),
                  const SizedBox(height: AppDimensions.spaceXL),
                  _buildSectionHeader(context, 'Serviços', '/services'),
                  const SizedBox(height: AppDimensions.spaceSM),
                  _buildServicesHorizontal(context),
                  const SizedBox(height: AppDimensions.spaceXL),
                  _buildSectionHeader(context, 'Barbeiros', '/professionals'),
                  const SizedBox(height: AppDimensions.spaceSM),
                  _buildProfessionalsHorizontal(context),
                  const SizedBox(height: AppDimensions.spaceXXL),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider appProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.textOnPrimary,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appProvider.isTreatment
                          ? AppStrings.promoTitle
                          : AppStrings.tagline,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textOnPrimary,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => GoRouter.of(context).go('/booking'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Buscar serviço ou barbeiro...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go('/services'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C2C2E), Color(0xFF3A3A3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppStrings.promoTitle.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Corte + Barba',
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ 45,00',
                    style: AppTextStyles.price.copyWith(
                      color: AppColors.accent,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.content_cut_rounded,
                color: AppColors.accent,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.calendar_today_rounded,
            label: 'Agendar',
            subtitle: 'Escolha seu horário',
            color: AppColors.primary,
            onTap: () => GoRouter.of(context).go('/booking'),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMD),
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.history_rounded,
            label: 'Agendamentos',
            subtitle: 'Consultar seus horários',
            color: AppColors.accentDark,
            onTap: () => GoRouter.of(context).go('/appointments'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.textOnPrimary, size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String route) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading3),
        TextButton(
          onPressed: () => GoRouter.of(context).go(route),
          child: Text(
            'Ver todos',
            style: AppTextStyles.label.copyWith(color: AppColors.accent),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesHorizontal(BuildContext context) {
    final services = [
      (name: 'Corte', icon: Icons.content_cut_rounded, price: 'R\$ 25', color: AppColors.primary),
      (name: 'Barba', icon: Icons.auto_fix_high_rounded, price: 'R\$ 20', color: const Color(0xFF5856D6)),
      (name: 'Corte + Barba', icon: Icons.auto_awesome_rounded, price: 'R\$ 45', color: AppColors.accentDark),
      (name: 'Sobrancelha', icon: Icons.brush_rounded, price: 'R\$ 15', color: const Color(0xFFFF6B6B)),
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final s = services[index];
          return GestureDetector(
            onTap: () => GoRouter.of(context).go('/services'),
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.color, size: 22),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.name,
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.price,
                        style: AppTextStyles.priceSmall.copyWith(color: s.color),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfessionalsHorizontal(BuildContext context) {
    final professionals = [
      (name: 'Carlos Silva', specialty: 'Corte & Barba', initials: 'CS', rating: 5.0),
      (name: 'João Pedro', specialty: 'Barba & Sobr.', initials: 'JP', rating: 4.0),
      (name: 'Ricardo A.', specialty: 'Corte Premium', initials: 'RA', rating: 5.0),
      (name: 'Fernanda C.', specialty: 'Sobrancelha', initials: 'FC', rating: 4.0),
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: professionals.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final p = professionals[index];
          return GestureDetector(
            onTap: () => GoRouter.of(context).go('/professionals'),
            child: Container(
              width: 130,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        p.initials,
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.accentDark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.name,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    p.specialty,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
                      const SizedBox(width: 3),
                      Text(
                        p.rating.toString(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}