import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HomeVariantA extends StatelessWidget {
  const HomeVariantA({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.read<AppProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),
                  _buildHeroSection(context, appProvider),
                  const SizedBox(height: 24),
                  _buildServicesGrid(context, appProvider),
                  const SizedBox(height: 24),
                  _buildProfessionalsList(context, appProvider),
                  const SizedBox(height: 48),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá!',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textOnPrimary,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pronto para agendar?',
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
    );
  }

  Widget _buildHeroSection(BuildContext context, AppProvider appProvider) {
    return GestureDetector(
      onTap: () {
        appProvider.trackEvent('cta_click', properties: {'section': 'hero'});
        GoRouter.of(context).go('/booking');
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1C1C1E), Color(0xFF3A3A3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'AGENDAMENTO RÁPIDO',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Agende seu próximo\nhorário agora',
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Escolha o melhor horário para você',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                appProvider.trackEvent(
                  'cta_click',
                  properties: {'section': 'hero'},
                );
                GoRouter.of(context).go('/booking');
              },
              icon: const Icon(Icons.calendar_today_rounded, size: 18),
              label: const Text('AGENDAR AGORA'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: AppTextStyles.buttonLarge.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context, AppProvider appProvider) {
    final services = [
      (
        name: 'Corte',
        icon: Icons.content_cut_rounded,
        price: 'R\$ 25',
        color: AppColors.blue,
      ),
      (
        name: 'Barba',
        icon: Icons.auto_fix_high_rounded,
        price: 'R\$ 20',
        color: const Color(0xFF5856D6),
      ),
      (
        name: 'Corte + Barba',
        icon: Icons.auto_awesome_rounded,
        price: 'R\$ 45',
        color: AppColors.accentDark,
      ),
      (
        name: 'Sobrancelha',
        icon: Icons.brush_rounded,
        price: 'R\$ 15',
        color: const Color(0xFFFF6B6B),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Serviços', style: AppTextStyles.heading3),
            TextButton(
              onPressed: () => GoRouter.of(context).go('/services'),
              child: Text(
                'Ver todos',
                style: AppTextStyles.label.copyWith(color: AppColors.accent),
              ),
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final s = services[index];
            return GestureDetector(
              onTap: () {
                appProvider.trackEvent(
                  'cta_click',
                  properties: {'section': 'services', 'service': s.name},
                );
                GoRouter.of(context).go('/services');
              },
              child: Container(
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: s.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(s.icon, color: s.color, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      s.price,
                      style: AppTextStyles.priceSmall.copyWith(
                        color: s.color,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfessionalsList(
    BuildContext context,
    AppProvider appProvider,
  ) {
    final professionals = [
      (
        name: 'Carlos Silva',
        specialty: 'Corte & Barba',
        initials: 'CS',
        rating: 5.0,
      ),
      (
        name: 'João Pedro',
        specialty: 'Barba & Sobr.',
        initials: 'JP',
        rating: 4.0,
      ),
      (
        name: 'Ricardo A.',
        specialty: 'Corte Premium',
        initials: 'RA',
        rating: 5.0,
      ),
      (
        name: 'Fernanda C.',
        specialty: 'Sobrancelha',
        initials: 'FC',
        rating: 4.0,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Barbeiros', style: AppTextStyles.heading3),
            TextButton(
              onPressed: () => GoRouter.of(context).go('/professionals'),
              child: Text(
                'Ver todos',
                style: AppTextStyles.label.copyWith(color: AppColors.accent),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: professionals.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final p = professionals[index];
              return GestureDetector(
                onTap: () {
                  appProvider.trackEvent(
                    'cta_click',
                    properties: {'section': 'professionals'},
                  );
                  GoRouter.of(context).go('/professionals');
                },
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            p.initials,
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.accentDark,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            p.rating.toString(),
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
