import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../core/providers/appointments_provider.dart';
import '../../data/models/appointment_model.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentsProvider = context.watch<AppointmentsProvider>();
    final appointments = appointmentsProvider.scheduledAppointments;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appointmentsTitle),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => appointmentsProvider.loadAppointments(),
          ),
        ],
      ),
      body: appointments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 64, color: AppColors.textHint),
                  const SizedBox(height: AppDimensions.spaceMD),
                  Text(
                    AppStrings.noAppointments,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.spaceMD),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentCard(context, appointments[index], appointmentsProvider);
              },
            ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Appointment appointment, AppointmentsProvider appointmentsProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointment.statusLabel,
                  style: AppTextStyles.label.copyWith(
                    color: appointment.status == AppointmentStatus.scheduled
                        ? AppColors.primary
                        : appointment.status == AppointmentStatus.cancelled
                            ? AppColors.error
                            : AppColors.success,
                  ),
                ),
                Text(
                  appointment.dateTime.toString().split(' ')[0],
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            Text(
              appointment.clientName,
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            _buildAppointmentDetail(Icons.schedule_rounded, appointment.dateTime.toString().split(' ')[1].substring(0, 5)),
            const SizedBox(height: AppDimensions.spaceXS),
            _buildAppointmentDetail(Icons.calendar_today_rounded, appointment.dateTime.toString().split(' ')[0]),
            const SizedBox(height: AppDimensions.spaceLG),
            if (appointment.status == AppointmentStatus.scheduled)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        appointmentsProvider.cancelAppointment(appointment.id);
                      },
                      child: Text(AppStrings.cancel),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceSM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Mark as completed
                      },
                      child: Text(AppStrings.completed),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textHint),
        const SizedBox(width: AppDimensions.spaceSM),
        Text(value, style: AppTextStyles.bodySmall),
      ],
    );
  }
}