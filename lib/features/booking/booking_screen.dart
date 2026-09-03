import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/booking_provider.dart';
import '../../core/providers/appointments_provider.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/professional_repository.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _obsController = TextEditingController();

  final _availableTimes = const [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final serviceRepo = ServiceRepository();
    final profRepo = ProfessionalRepository();

    final service = bookingProvider.state.selectedServiceId != null
        ? serviceRepo.getServiceById(bookingProvider.state.selectedServiceId!)
        : null;
    final professional = bookingProvider.state.selectedProfessionalId != null
        ? profRepo.getProfessionalById(
            bookingProvider.state.selectedProfessionalId!,
          )
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Agendar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(bookingProvider),
            const SizedBox(height: AppDimensions.spaceLG),
            if (service != null) _buildSelectedService(service),
            if (professional != null) ...[
              const SizedBox(height: 12),
              _buildSelectedProfessional(professional),
            ],
            const SizedBox(height: AppDimensions.spaceLG),
            _buildDatePicker(),
            const SizedBox(height: AppDimensions.spaceLG),
            _buildTimePicker(),
            const SizedBox(height: AppDimensions.spaceLG),
            _buildClientInfo(),
            const SizedBox(height: AppDimensions.spaceXL),
            SizedBox(
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: _canConfirm()
                    ? () => _confirmBooking(context, bookingProvider)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canConfirm()
                      ? AppColors.accent
                      : AppColors.border,
                  foregroundColor: _canConfirm()
                      ? AppColors.primary
                      : AppColors.textTertiary,
                ),
                child: Text(
                  _canConfirm()
                      ? 'Confirmar Agendamento'
                      : 'Preencha todos os campos',
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: _canConfirm()
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(BookingProvider bookingProvider) {
    final steps = ['Serviço', 'Barbeiro', 'Data/Hora', 'Confirmar'];
    final currentStep = [
      bookingProvider.state.hasSelectedService,
      bookingProvider.state.hasSelectedProfessional,
      _selectedTime != null,
      false,
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        final isDone = currentStep[index];
        final isCurrent = index == currentStep.indexOf(false);
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isDone ? AppColors.accent : AppColors.border,
                      ),
                    ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.accent
                          : (isCurrent ? AppColors.primary : AppColors.border),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.textOnAccent,
                            )
                          : Text(
                              '${index + 1}',
                              style: AppTextStyles.caption.copyWith(
                                color: isCurrent
                                    ? AppColors.textOnPrimary
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isDone ? AppColors.accent : AppColors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                steps[index],
                style: AppTextStyles.caption.copyWith(
                  color: isDone
                      ? AppColors.accentDark
                      : (isCurrent
                            ? AppColors.textPrimary
                            : AppColors.textTertiary),
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSelectedService(dynamic service) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.content_cut_rounded,
              color: AppColors.accentDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: AppTextStyles.subtitle),
                Text('${service.duration} min', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(
            'R\$ ${service.price.toStringAsFixed(2)}',
            style: AppTextStyles.priceSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProfessional(dynamic professional) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blueBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                professional.name.split(' ').map((n) => n[0]).take(2).join(),
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.blue,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(professional.name, style: AppTextStyles.subtitle),
                Text(professional.specialty, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 16, color: AppColors.accent),
              const SizedBox(width: 3),
              Text(
                professional.rating.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    final now = DateTime.now();
    final days = List.generate(14, (i) => now.add(Duration(days: i)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text('Data', style: AppTextStyles.heading3),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = _isSameDay(day, _selectedDate);
              final dayName = _getDayName(day.weekday);
              final isWeekend = day.weekday == 6 || day.weekday == 7;

              return GestureDetector(
                onTap: isWeekend
                    ? null
                    : () => setState(() => _selectedDate = day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : (isWeekend
                                ? AppColors.borderLight
                                : AppColors.border),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: AppTextStyles.caption.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : (isWeekend
                                    ? AppColors.textTertiary
                                    : AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${day.day}',
                        style: AppTextStyles.heading3.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : (isWeekend
                                    ? AppColors.textTertiary
                                    : AppColors.textPrimary),
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        _getMonthName(day.month),
                        style: AppTextStyles.caption.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : (isWeekend
                                    ? AppColors.textTertiary
                                    : AppColors.textSecondary),
                        ),
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

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text('Horário', style: AppTextStyles.heading3),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTimes.map((time) {
            final isSelected = _selectedTime == time;
            return GestureDetector(
              onTap: () => setState(() => _selectedTime = time),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.border,
                  ),
                ),
                child: Text(
                  time,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildClientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.person_outline_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text('Seus dados', style: AppTextStyles.heading3),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Seu nome'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(hintText: 'Telefone'),
          keyboardType: TextInputType.phone,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _obsController,
          decoration: const InputDecoration(hintText: 'Observações (opcional)'),
          maxLines: 2,
        ),
      ],
    );
  }

  bool _canConfirm() {
    return context.read<BookingProvider>().state.hasSelectedService &&
        context.read<BookingProvider>().state.hasSelectedProfessional &&
        _selectedTime != null &&
        _nameController.text.isNotEmpty;
  }

  void _confirmBooking(BuildContext context, BookingProvider bookingProvider) {
    final serviceRepo = ServiceRepository();
    final profRepo = ProfessionalRepository();
    final service = serviceRepo.getServiceById(
      bookingProvider.state.selectedServiceId!,
    )!;
    final professional = profRepo.getProfessionalById(
      bookingProvider.state.selectedProfessionalId!,
    )!;

    final timeParts = _selectedTime!.split(':');
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    context.read<AppointmentsProvider>().scheduleAppointment(
      serviceId: service.id,
      professionalId: professional.id,
      dateTime: dateTime,
      value: service.price,
      clientName: _nameController.text,
      observations: _obsController.text,
    );

    bookingProvider.reset();
    _selectedTime = null;
    _nameController.clear();
    _phoneController.clear();
    _obsController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Agendamento realizado com sucesso!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    context.go('/appointments');
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _getDayName(int weekday) {
    return switch (weekday) {
      1 => 'Seg',
      2 => 'Ter',
      3 => 'Qua',
      4 => 'Qui',
      5 => 'Sex',
      6 => 'Sáb',
      7 => 'Dom',
      _ => '',
    };
  }

  String _getMonthName(int month) {
    return switch (month) {
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
}
