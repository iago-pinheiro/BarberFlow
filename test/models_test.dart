import 'package:flutter_test/flutter_test.dart';
import 'package:barberflow_app/core/constants/app_strings.dart';
import 'package:barberflow_app/data/models/appointment_model.dart';
import 'package:barberflow_app/data/models/professional_model.dart';
import 'package:barberflow_app/data/models/service_model.dart';

Service _service() => const Service(
      id: '1',
      name: 'Corte',
      description: 'Corte tradicional',
      price: 25.0,
      duration: 30,
      type: ServiceType.haircut,
      image: 'assets/haircut.png',
    );

Professional _professional() => const Professional(
      id: 'p1',
      name: 'Carlos Silva',
      specialty: 'Corte e Barba',
      specialtyType: ProfessionalSpecialty.haircutAndBeard,
      availableHours: ['09:00', '10:00'],
      image: 'assets/carlos.png',
      rating: 5,
      bio: '10 anos de experiência.',
    );

Appointment _appointment({AppointmentStatus status = AppointmentStatus.scheduled}) =>
    Appointment(
      id: 'a1',
      serviceId: '1',
      professionalId: 'p1',
      dateTime: DateTime(2026, 1, 15, 14, 0),
      value: 25.0,
      status: status,
      clientName: 'Kaio',
      observations: '',
    );

void main() {
  group('Service', () {
    test('copyWith altera apenas os campos informados', () {
      final service = _service();

      final updated = service.copyWith(price: 30.0, duration: 45);

      expect(updated.price, 30.0);
      expect(updated.duration, 45);
      expect(updated.id, '1');
      expect(updated.name, 'Corte');
      expect(updated.type, ServiceType.haircut);
    });

    test('igualdade é baseada no id', () {
      final a = _service();
      final b = a.copyWith(price: 99.0);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == _service().copyWith(id: '2'), isFalse);
    });
  });

  group('Professional', () {
    test('copyWith altera apenas os campos informados', () {
      final professional = _professional();

      final updated = professional.copyWith(rating: 4, bio: 'nova bio');

      expect(updated.rating, 4);
      expect(updated.bio, 'nova bio');
      expect(updated.name, 'Carlos Silva');
      expect(updated.availableHours, ['09:00', '10:00']);
    });

    test('igualdade é baseada no id', () {
      final a = _professional();

      expect(a, a.copyWith(rating: 3));
      expect(a == _professional().copyWith(id: 'p2'), isFalse);
    });
  });

  group('Appointment', () {
    test('copyWith altera apenas os campos informados', () {
      final appointment = _appointment();

      final updated = appointment.copyWith(status: AppointmentStatus.cancelled);

      expect(updated.status, AppointmentStatus.cancelled);
      expect(updated.id, 'a1');
      expect(updated.value, 25.0);
    });

    test('igualdade é baseada no id', () {
      final a = _appointment();
      final b = a.copyWith(value: 50.0);

      expect(a, b);
      expect(a == _appointment().copyWith(id: 'a2'), isFalse);
    });

    test('statusLabel retorna o texto esperado', () {
      expect(_appointment().statusLabel, AppStrings.scheduled);
      expect(
        _appointment(status: AppointmentStatus.completed).statusLabel,
        AppStrings.completed,
      );
      expect(
        _appointment(status: AppointmentStatus.cancelled).statusLabel,
        AppStrings.cancelled,
      );
    });
  });
}