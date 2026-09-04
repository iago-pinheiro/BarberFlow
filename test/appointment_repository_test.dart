import 'package:flutter_test/flutter_test.dart';
import 'package:barberflow_app/data/models/appointment_model.dart';
import 'package:barberflow_app/data/repositories/appointment_repository.dart';

void main() {
  group('AppointmentRepository', () {
    test('começa sem agendamentos', () {
      final repo = AppointmentRepository();

      expect(repo.getAppointments(), isEmpty);
    });

    test('scheduleAppointment cria agendamento com status scheduled', () {
      final repo = AppointmentRepository();
      final dateTime = DateTime(2026, 1, 15, 14, 0);

      final id = repo.scheduleAppointment(
        serviceId: '1',
        professionalId: 'p1',
        dateTime: dateTime,
        value: 25.0,
        clientName: 'Kaio',
        observations: 'Cabelo curto',
      );

      expect(id, isNotEmpty);
      final appointments = repo.getAppointments();
      expect(appointments, hasLength(1));
      expect(appointments.first.id, id);
      expect(appointments.first.serviceId, '1');
      expect(appointments.first.professionalId, 'p1');
      expect(appointments.first.dateTime, dateTime);
      expect(appointments.first.value, 25.0);
      expect(appointments.first.clientName, 'Kaio');
      expect(appointments.first.observations, 'Cabelo curto');
      expect(appointments.first.status, AppointmentStatus.scheduled);
    });

    test('getAppointments retorna lista imodificável', () {
      final repo = AppointmentRepository();
      repo.scheduleAppointment(
        serviceId: '1',
        professionalId: 'p1',
        dateTime: DateTime(2026, 1, 15, 14, 0),
        value: 25.0,
        clientName: 'Kaio',
      );

      expect(
        () => repo.getAppointments().add(
              Appointment(
                id: 'x',
                serviceId: '1',
                professionalId: 'p1',
                dateTime: DateTime(2027, 1, 1),
                value: 1,
                status: AppointmentStatus.scheduled,
                clientName: 'X',
                observations: '',
              ),
            ),
        throwsUnsupportedError,
      );
    });

    test('getAppointmentsByStatus filtra por status', () {
      final repo = AppointmentRepository();
      repo.scheduleAppointment(
        serviceId: '1',
        professionalId: 'p1',
        dateTime: DateTime(2026, 1, 15, 14, 0),
        value: 25.0,
        clientName: 'Kaio',
      );
      repo.scheduleAppointment(
        serviceId: '2',
        professionalId: 'p2',
        dateTime: DateTime(2026, 1, 16, 14, 0),
        value: 20.0,
        clientName: 'Ana',
      );

      final scheduled = repo.getAppointmentsByStatus(AppointmentStatus.scheduled);
      final completed = repo.getAppointmentsByStatus(AppointmentStatus.completed);

      expect(scheduled, hasLength(2));
      expect(completed, isEmpty);
    });

    test('cancelAppointment altera o status para cancelled e retorna true', () {
      final repo = AppointmentRepository();
      final id = repo.scheduleAppointment(
        serviceId: '1',
        professionalId: 'p1',
        dateTime: DateTime(2026, 1, 15, 14, 0),
        value: 25.0,
        clientName: 'Kaio',
      );

      final result = repo.cancelAppointment(id);

      expect(result, isTrue);
      expect(
        repo.getAppointments().first.status,
        AppointmentStatus.cancelled,
      );
    });

    test('cancelAppointment retorna false para id inexistente', () {
      final repo = AppointmentRepository();

      final result = repo.cancelAppointment('nao-existe');

      expect(result, isFalse);
    });

    test('isSlotAvailable retorna true para horário livre', () {
      final repo = AppointmentRepository();

      expect(repo.isSlotAvailable(DateTime(2026, 1, 15, 14, 0)), isTrue);
    });

    test('isSlotAvailable retorna false quando o horário já está marcado', () {
      final repo = AppointmentRepository();
      final dateTime = DateTime(2026, 1, 15, 14, 0);
      repo.scheduleAppointment(
        serviceId: '1',
        professionalId: 'p1',
        dateTime: dateTime,
        value: 25.0,
        clientName: 'Kaio',
      );

      expect(repo.isSlotAvailable(dateTime), isFalse);
      expect(repo.isSlotAvailable(dateTime.add(const Duration(hours: 1))), isTrue);
    });

    test('isSlotAvailable ignora agendamentos cancelados', () {
      final repo = AppointmentRepository();
      final dateTime = DateTime(2026, 1, 15, 14, 0);
      final id = repo.scheduleAppointment(
        serviceId: '1',
        professionalId: 'p1',
        dateTime: dateTime,
        value: 25.0,
        clientName: 'Kaio',
      );
      repo.cancelAppointment(id);

      expect(repo.isSlotAvailable(dateTime), isTrue);
    });

    test('isSlotAvailableForProfessional considera apenas o profissional', () {
      final repo = AppointmentRepository();
      final dateTime = DateTime(2026, 1, 15, 14, 0);
      repo.scheduleAppointment(
        serviceId: '1',
        professionalId: 'p1',
        dateTime: dateTime,
        value: 25.0,
        clientName: 'Kaio',
      );

      expect(repo.isSlotAvailableForProfessional(dateTime, 'p1'), isFalse);
      expect(repo.isSlotAvailableForProfessional(dateTime, 'p2'), isTrue);
    });
  });
}