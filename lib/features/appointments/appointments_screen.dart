import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/appointments_provider.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/professional_repository.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentsProvider>();
    final scheduled = provider.scheduledAppointments;
    final cancelled = provider.cancelledAppointments;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/'),
        ),
      ),
      body: scheduled.isEmpty && cancelled.isEmpty
          ? _buildEmptyState(context)
          : ListView(
              padding: const EdgeInsets.all(AppDimensions.spaceMD),
              children: [
                if (scheduled.isNotEmpty) ...[
                  Text('Ativos', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  ...scheduled.map((a) => _buildAppointmentCard(context, a, provider, true)),
                ],
                if (scheduled.isNotEmpty && cancelled.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.spaceMD),
                  Text('Histórico', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                ],
                if (cancelled.isNotEmpty) ...[
                  ...cancelled.map((a) => _buildAppointmentCard(context, a, provider, false)),
                ],
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.iconBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                size: 36,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            Text(
              'Sem agendamentos',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'Faça seu primeiro agendamento\npara começar!',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            ElevatedButton.icon(
              onPressed: () => GoRouter.of(context).go('/booking'),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Agendar agora'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    Appointment appointment,
    AppointmentsProvider provider,
    bool isActive,
  ) {
    final serviceRepo = ServiceRepository();
    final profRepo = ProfessionalRepository();
    final service = serviceRepo.getServiceById(appointment.serviceId);
    final professional = profRepo.getProfessionalById(appointment.professionalId);

    final date = appointment.dateTime;
    final dayName = _getDayName(date.weekday);
    final monthName = _getMonthName(date.month);
    final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? AppColors.borderLight : AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accent.withValues(alpha: 0.1) : AppColors.iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: isActive ? AppColors.accentDark : AppColors.textTertiary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service?.name ?? 'Serviço',
                      style: AppTextStyles.subtitle,
                    ),
                    Text(
                      professional?.name ?? 'Profissional',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                'R\$ ${appointment.value.toStringAsFixed(0)}',
                style: AppTextStyles.priceSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.accentBg : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time_rounded, size: 16, color: isActive ? AppColors.accentDark : AppColors.textTertiary),
                const SizedBox(width: 6),
                Text(
                  '$dayName, ${date.day} de $monthName - $timeStr',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCancelDialog(context, appointment.id, provider),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.cancelAppointment(appointment.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Agendamento concluído!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Text('Concluir'),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Cancelado',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String id, AppointmentsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancelar agendamento?'),
        content: const Text('Tem certeza que deseja cancelar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Não, manter'),
          ),
          TextButton(
            onPressed: () {
              provider.cancelAppointment(id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Agendamento cancelado.'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Sim, cancelar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) => switch (weekday) {
    1 => 'Seg',
    2 => 'Ter',
    3 => 'Qua',
    4 => 'Qui',
    5 => 'Sex',
    6 => 'Sáb',
    7 => 'Dom',
    _ => '',
  };

  String _getMonthName(int month) => switch (month) {
    1 => 'Jan',
    2 => 'Fev',
    3 => 'Mar',
    4 => 'Abr',
    5 => 'Mai',
    6 => 'Jun',
    7 => 'Jul',
    8 => 'Ago',
    9 => 'Set',
    10 => 'Out',
    11 => 'Nov',
    12 => 'Dez',
    _ => '',
  };
}