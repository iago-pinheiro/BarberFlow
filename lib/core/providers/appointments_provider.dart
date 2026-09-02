import 'package:flutter/foundation.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/appointment_repository.dart';

class AppointmentsProvider extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();

  List<Appointment> get appointments => _repository.getAppointments();

  List<Appointment> get scheduledAppointments =>
      _repository.getAppointmentsByStatus(AppointmentStatus.scheduled);

  List<Appointment> get completedAppointments =>
      _repository.getAppointmentsByStatus(AppointmentStatus.completed);

  List<Appointment> get cancelledAppointments =>
      _repository.getAppointmentsByStatus(AppointmentStatus.cancelled);

  Future<void> loadAppointments() async {
    notifyListeners();
  }

  Future<void> scheduleAppointment({
    required String serviceId,
    required String professionalId,
    required DateTime dateTime,
    required double value,
    required String clientName,
    String observations = '',
  }) async {
    _repository.scheduleAppointment(
      serviceId: serviceId,
      professionalId: professionalId,
      dateTime: dateTime,
      value: value,
      clientName: clientName,
      observations: observations,
    );
    notifyListeners();
  }

  Future<void> cancelAppointment(String id) async {
    _repository.cancelAppointment(id);
    notifyListeners();
  }
}