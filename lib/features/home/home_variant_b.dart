import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HomeVariantB extends StatelessWidget {
  const HomeVariantB({super.key});

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
                  _buildPromoBanner(context, appProvider),
                  const SizedBox(height: 24),
                  _buildServicesScroll(context, appProvider),
                  const SizedBox(height: 24),
                  _buildProfessionalsScroll(context, appProvider),
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
                  'BarberFlow',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.textOnPrimary,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'A melhor barbearia da cidade',
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

  Widget _buildPromoBanner(BuildContext context, AppProvider appProvider) {
    return GestureDetector(
      onTap: () {
        appProvider.trackEvent('cta_click', properties: {'section': 'promo'});
        GoRouter.of(context).go('/booking');
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B0000), Color(0xFFB22222)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B0000).withValues(alpha: 0.3),
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
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'OFERTA DA SEMANA',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Corte + Barba',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R\$ 45',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'R\$ 39,90',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_offer_rounded, size: 18, color: Color(0xFF8B0000)),
                  const SizedBox(width: 8),
                  Text(
                    'AGENDAR AGORA',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: const Color(0xFF8B0000),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesScroll(BuildContext context, AppProvider appProvider) {
    final services = [
      (name: 'Corte', icon: Icons.content_cut_rounded, price: 'R\$ 25', color: AppColors.blue),
      (name: 'Barba', icon: Icons.auto_fix_high_rounded, price: 'R\$ 20', color: const Color(0xFF5856D6)),
      (name: 'Corte + Barba', icon: Icons.auto_awesome_rounded, price: 'R\$ 39,90', color: const Color(0xFF8B0000)),
      (name: 'Sobrancelha', icon: Icons.brush_rounded, price: 'R\$ 15', color: const Color(0xFFFF6B6B)),
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
              child: Text('Ver todos', style: AppTextStyles.label.copyWith(color: AppColors.accent)),
            ),
          ],
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final s = services[index];
              return GestureDetector(
                onTap: () {
                  appProvider.trackEvent('cta_click', properties: {'section': 'services', 'service': s.name});
                  GoRouter.of(context).go('/services');
                },
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
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
                          color: s.color.withValues(alpha: 0.1),
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
        ),
      ],
    );
  }

  Widget _buildProfessionalsScroll(BuildContext context, AppProvider appProvider) {
    final professionals = [
      (name: 'Carlos Silva', specialty: 'Corte & Barba', initials: 'CS', rating: 5.0),
      (name: 'João Pedro', specialty: 'Barba & Sobr.', initials: 'JP', rating: 4.0),
      (name: 'Ricardo A.', specialty: 'Corte Premium', initials: 'RA', rating: 5.0),
      (name: 'Fernanda C.', specialty: 'Sobrancelha', initials: 'FC', rating: 4.0),
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
              child: Text('Ver todos', style: AppTextStyles.label.copyWith(color: AppColors.accent)),
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
                  appProvider.trackEvent('cta_click', properties: {'section': 'professionals'});
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
                      BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
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
                            style: AppTextStyles.heading3.copyWith(color: AppColors.accentDark, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.name,
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: AppColors.accent),
                          const SizedBox(width: 2),
                          Text(p.rating.toString(), style: AppTextStyles.caption),
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