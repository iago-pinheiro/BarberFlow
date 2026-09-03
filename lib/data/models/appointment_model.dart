import '../../core/constants/app_strings.dart';

enum AppointmentStatus { scheduled, completed, cancelled }

class Appointment {
  final String id;
  final String serviceId;
  final String professionalId;
  final DateTime dateTime;
  final double value;
  final AppointmentStatus status;
  final String clientName;
  final String observations;

  const Appointment({
    required this.id,
    required this.serviceId,
    required this.professionalId,
    required this.dateTime,
    required this.value,
    required this.status,
    required this.clientName,
    required this.observations,
  });

  Appointment copyWith({
    String? id,
    String? serviceId,
    String? professionalId,
    DateTime? dateTime,
    double? value,
    AppointmentStatus? status,
    String? clientName,
    String? observations,
  }) {
    return Appointment(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      professionalId: professionalId ?? this.professionalId,
      dateTime: dateTime ?? this.dateTime,
      value: value ?? this.value,
      status: status ?? this.status,
      clientName: clientName ?? this.clientName,
      observations: observations ?? this.observations,
    );
  }

  String get statusLabel {
    switch (status) {
      case AppointmentStatus.scheduled:
        return AppStrings.scheduled;
      case AppointmentStatus.completed:
        return AppStrings.completed;
      case AppointmentStatus.cancelled:
        return AppStrings.cancelled;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) && other is Appointment && other.id == id;

  @override
  int get hashCode => id.hashCode;
}