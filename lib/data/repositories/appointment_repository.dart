import 'dart:math';
import '../models/appointment_model.dart';

class AppointmentRepository {
  final List<Appointment> _appointments = [];

  List<Appointment> getAppointments() => List.unmodifiable(_appointments);

  List<Appointment> getAppointmentsByStatus(AppointmentStatus status) {
    return _appointments
        .where((a) => a.status == status)
        .toList();
  }

  String scheduleAppointment({
    required String serviceId,
    required String professionalId,
    required DateTime dateTime,
    required double value,
    required String clientName,
    String observations = '',
  }) {
    final id = 'app_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    final appointment = Appointment(
      id: id,
      serviceId: serviceId,
      professionalId: professionalId,
      dateTime: dateTime,
      value: value,
      status: AppointmentStatus.scheduled,
      clientName: clientName,
      observations: observations,
    );
    _appointments.add(appointment);
    return id;
  }

  bool cancelAppointment(String id) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.cancelled,
      );
      return true;
    }
    return false;
  }

  bool isSlotAvailable(DateTime dateTime) {
    return !_appointments.any(
      (a) =>
          a.dateTime.isAtSameMomentAs(dateTime) &&
          a.status == AppointmentStatus.scheduled,
    );
  }

  bool isSlotAvailableForProfessional(DateTime dateTime, String professionalId) {
    return !_appointments.any(
      (a) =>
          a.dateTime.isAtSameMomentAs(dateTime) &&
          a.professionalId == professionalId &&
          a.status == AppointmentStatus.scheduled,
    );
  }
}