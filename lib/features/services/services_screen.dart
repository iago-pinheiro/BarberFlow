import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/service_model.dart';
import '../../data/repositories/service_repository.dart';
import '../../core/providers/booking_provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedCategoryIndex = 0;

  final _categories = const [
    (label: 'Todos', icon: Icons.grid_view_rounded),
    (label: 'Corte', icon: Icons.content_cut_rounded),
    (label: 'Barba', icon: Icons.auto_fix_high_rounded),
    (label: 'Sobr.', icon: Icons.brush_rounded),
    (label: 'Combo', icon: Icons.auto_awesome_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final serviceRepo = ServiceRepository();
    final allServices = serviceRepo.getServices();

    final filteredServices = _selectedCategoryIndex == 0
        ? allServices
        : allServices.where((s) {
            switch (_selectedCategoryIndex) {
              case 1: return s.type == ServiceType.haircut;
              case 2: return s.type == ServiceType.beard;
              case 3: return s.type == ServiceType.eyebrow;
              case 4: return s.type == ServiceType.haircutAndBeard;
              default: return true;
            }
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Serviços'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryBar(),
          Expanded(
            child: filteredServices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 56, color: AppColors.textTertiary),
                        const SizedBox(height: AppDimensions.spaceMD),
                        Text('Nenhum serviço nesta categoria', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.spaceMD),
                    itemCount: filteredServices.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildServiceCard(context, filteredServices[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategoryIndex == index;
          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusFull),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat.icon,
                      size: 16,
                      color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat.label,
                      style: AppTextStyles.chip.copyWith(
                        color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    final iconData = _getServiceIcon(service.type);
    final iconColor = _getServiceColor(service.type);

    return GestureDetector(
      onTap: () {
        context.read<BookingProvider>().selectService(service.id);
        context.go('/booking');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconData, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.name,
                          style: AppTextStyles.subtitle,
                        ),
                      ),
                      _buildTypeBadge(service.type),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '${service.duration} min',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'R\$ ${service.price.toStringAsFixed(0)}',
              style: AppTextStyles.price,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(ServiceType type) {
    final (label, color) = switch (type) {
      ServiceType.haircut => ('Corte', AppColors.blue),
      ServiceType.beard => ('Barba', const Color(0xFF5856D6)),
      ServiceType.haircutAndBeard => ('Combo', AppColors.accentDark),
      ServiceType.eyebrow => ('Sobr.', const Color(0xFFFF6B6B)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getServiceIcon(ServiceType type) {
    return switch (type) {
      ServiceType.haircut => Icons.content_cut_rounded,
      ServiceType.beard => Icons.auto_fix_high_rounded,
      ServiceType.haircutAndBeard => Icons.auto_awesome_rounded,
      ServiceType.eyebrow => Icons.brush_rounded,
    };
  }

  Color _getServiceColor(ServiceType type) {
    return switch (type) {
      ServiceType.haircut => AppColors.blue,
      ServiceType.beard => const Color(0xFF5856D6),
      ServiceType.haircutAndBeard => AppColors.accentDark,
      ServiceType.eyebrow => const Color(0xFFFF6B6B),
    };
  }
}