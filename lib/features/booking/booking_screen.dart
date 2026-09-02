import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../core/providers/booking_provider.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/professional_repository.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final serviceRepo = ServiceRepository();
    final profRepo = ProfessionalRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.confirmBooking),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStepIndicator(context, bookingProvider),
            const SizedBox(height: AppDimensions.spaceLG),
            _buildOrderSummary(context, bookingProvider, serviceRepo, profRepo),
            const SizedBox(height: AppDimensions.spaceLG),
            _buildClientInfo(context, bookingProvider),
            const SizedBox(height: AppDimensions.spaceLG),
            SizedBox(
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: bookingProvider.state.isComplete
                    ? () {
                        GoRouter.of(context).go('/appointments');
                      }
                    : null,
                child: Text(AppStrings.bookNow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, BookingProvider bookingProvider) {
    final steps = ['Serviço', 'Barbeiro', 'Data/Hora', 'Confirmar'];
    final currentStep = 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(steps.length, (index) {
        return Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: index <= currentStep ? AppColors.primary : AppColors.border,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.caption.copyWith(
                    color: index <= currentStep ? AppColors.textOnAccent : AppColors.textHint,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              steps[index],
              style: AppTextStyles.caption,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOrderSummary(BuildContext context, BookingProvider bookingProvider, ServiceRepository serviceRepo, ProfessionalRepository profRepo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.orderSummary,
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            if (bookingProvider.state.selectedServiceId != null) ...[
              _buildSummaryRow('Serviço', serviceRepo.getServiceById(bookingProvider.state.selectedServiceId!)!.name),
            ],
            if (bookingProvider.state.selectedProfessionalId != null) ...[
              _buildSummaryRow('Barbeiro', profRepo.getProfessionalById(bookingProvider.state.selectedProfessionalId!)!.name),
            ],
            if (bookingProvider.state.selectedDate != null) ...[
              _buildSummaryRow('Data', bookingProvider.state.selectedDate!.toString().split(' ')[0]),
            ],
            if (bookingProvider.state.selectedTime != null) ...[
              _buildSummaryRow('Horário', bookingProvider.state.selectedTime!.toString().split(' ')[1].substring(0, 5)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.label),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildClientInfo(BuildContext context, BookingProvider bookingProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.clientName,
              style: AppTextStyles.label,
            ),
            const SizedBox(height: AppDimensions.spaceSM),
            TextField(
              decoration: InputDecoration(hintText: AppStrings.nameHint),
              onChanged: bookingProvider.setClientName,
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            TextField(
              decoration: InputDecoration(hintText: AppStrings.phoneHint),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppDimensions.spaceMD),
            TextField(
              decoration: InputDecoration(hintText: AppStrings.obsHint),
              maxLines: 2,
              onChanged: bookingProvider.setObservations,
            ),
          ],
        ),
      ),
    );
  }
}