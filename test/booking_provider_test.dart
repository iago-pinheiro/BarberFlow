import 'package:flutter_test/flutter_test.dart';
import 'package:barberflow_app/core/providers/booking_provider.dart';

void main() {
  group('BookingState', () {
    test('estado inicial é vazio e incompleto', () {
      const state = BookingState();

      expect(state.selectedServiceId, isNull);
      expect(state.selectedProfessionalId, isNull);
      expect(state.selectedDate, isNull);
      expect(state.selectedTime, isNull);
      expect(state.clientName, isEmpty);
      expect(state.observations, isEmpty);
      expect(state.isComplete, isFalse);
    });

    test('hasSelected* retorna false no estado vazio', () {
      const state = BookingState();

      expect(state.hasSelectedService, isFalse);
      expect(state.hasSelectedProfessional, isFalse);
      expect(state.hasSelectedDate, isFalse);
      expect(state.hasSelectedTime, isFalse);
    });

    test('isComplete exige serviço, barbeiro, data, horário e nome', () {
      final state = BookingState()
          .copyWith(selectedServiceId: '1')
          .copyWith(selectedProfessionalId: 'p1')
          .copyWith(selectedDate: DateTime(2026, 1, 15))
          .copyWith(selectedTime: DateTime(2026, 1, 15, 14, 0));

      expect(state.isComplete, isFalse);

      final complete = state.copyWith(clientName: 'Kaio');
      expect(complete.isComplete, isTrue);
    });

    test('copyWith não sobrescreve valores com null', () {
      const base = BookingState(clientName: 'Kaio', observations: 'obs');

      final updated = base.copyWith(clientName: null, observations: null);

      expect(updated.clientName, 'Kaio');
      expect(updated.observations, 'obs');
    });

    test('copyWith sobrescreve apenas os campos informados', () {
      const base = BookingState(clientName: 'A');

      final updated = base.copyWith(clientName: 'B', observations: 'x');

      expect(updated.clientName, 'B');
      expect(updated.observations, 'x');
    });
  });

  group('BookingProvider', () {
    test('seleciona serviço e notifica listeners', () {
      final provider = BookingProvider();
      var notified = 0;
      provider.addListener(() => notified++);

      provider.selectService('1');

      expect(provider.state.selectedServiceId, '1');
      expect(provider.state.hasSelectedService, isTrue);
      expect(notified, 1);
    });

    test('selecionar o mesmo serviço não notifica novamente', () {
      final provider = BookingProvider();
      provider.selectService('1');
      var notified = 0;
      provider.addListener(() => notified++);

      provider.selectService('1');

      expect(notified, 0);
    });

    test('trocar de serviço limpa barbeiro e horário selecionados', () {
      final provider = BookingProvider();
      provider.selectService('1');
      provider.selectProfessional('p1');
      provider.selectDate(DateTime(2026, 1, 15));
      provider.selectTime(DateTime(2026, 1, 15, 14, 0));
      provider.setClientName('Kaio');

      provider.selectService('2');

      expect(provider.state.selectedServiceId, '2');
      expect(provider.state.selectedProfessionalId, isNull);
      expect(provider.state.selectedTime, isNull);
      expect(provider.state.selectedDate, isNotNull);
      expect(provider.state.clientName, 'Kaio');
    });

    test('seleciona barbeiro e notifica listeners', () {
      final provider = BookingProvider();
      provider.selectService('1');
      var notified = 0;
      provider.addListener(() => notified++);

      provider.selectProfessional('p1');

      expect(provider.state.selectedProfessionalId, 'p1');
      expect(provider.state.hasSelectedProfessional, isTrue);
      expect(notified, 1);
    });

    test('trocar de barbeiro limpa o horário selecionado', () {
      final provider = BookingProvider();
      provider.selectService('1');
      provider.selectProfessional('p1');
      provider.selectTime(DateTime(2026, 1, 15, 14, 0));

      provider.selectProfessional('p2');

      expect(provider.state.selectedProfessionalId, 'p2');
      expect(provider.state.selectedTime, isNull);
      expect(provider.state.selectedServiceId, '1');
    });

    test('seleciona data e horário', () {
      final provider = BookingProvider();
      final date = DateTime(2026, 1, 20);
      final time = DateTime(2026, 1, 20, 15, 30);

      provider.selectDate(date);
      provider.selectTime(time);

      expect(provider.state.selectedDate, date);
      expect(provider.state.selectedTime, time);
      expect(provider.state.hasSelectedDate, isTrue);
      expect(provider.state.hasSelectedTime, isTrue);
    });

    test('define nome e observações do cliente', () {
      final provider = BookingProvider();

      provider.setClientName('Kaio');
      provider.setObservations('Cabelo curto');

      expect(provider.state.clientName, 'Kaio');
      expect(provider.state.observations, 'Cabelo curto');
    });

    test('reset limpa todo o estado e notifica', () {
      final provider = BookingProvider();
      provider.selectService('1');
      provider.selectProfessional('p1');
      provider.selectDate(DateTime(2026, 1, 20));
      provider.selectTime(DateTime(2026, 1, 20, 15, 30));
      provider.setClientName('Kaio');
      var notified = 0;
      provider.addListener(() => notified++);

      provider.reset();

      expect(provider.state.selectedServiceId, isNull);
      expect(provider.state.selectedProfessionalId, isNull);
      expect(provider.state.selectedDate, isNull);
      expect(provider.state.selectedTime, isNull);
      expect(provider.state.clientName, isEmpty);
      expect(provider.state.observations, isEmpty);
      expect(provider.state.isComplete, isFalse);
      expect(notified, 1);
    });
  });
}