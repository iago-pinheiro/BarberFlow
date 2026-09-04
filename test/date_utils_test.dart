import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:barberflow_app/core/utils/date_utils.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('DateUtils - formatação', () {
    test('formatDate usa dd/MM/yyyy', () {
      expect(DateUtils.formatDate(DateTime(2026, 1, 5)), '05/01/2026');
      expect(DateUtils.formatDate(DateTime(2026, 12, 31)), '31/12/2026');
    });

    test('formatTime usa HH:mm', () {
      expect(DateUtils.formatTime(DateTime(2026, 1, 15, 9, 5)), '09:05');
      expect(DateUtils.formatTime(DateTime(2026, 1, 15, 16, 30)), '16:30');
    });

    test('formatDateTime combina data e hora', () {
      expect(
        DateUtils.formatDateTime(DateTime(2026, 1, 5, 14, 0)),
        '05/01/2026 14:00',
      );
    });

    test('formatDateRange mesmo mês usa "a"', () {
      expect(
        DateUtils.formatDateRange(
          DateTime(2026, 1, 10),
          DateTime(2026, 1, 12),
        ),
        '10/01/2026 a 12/01/2026',
      );
    });

    test('formatDateRange meses diferentes usa hífen', () {
      expect(
        DateUtils.formatDateRange(
          DateTime(2026, 1, 30),
          DateTime(2026, 2, 2),
        ),
        '30/01/2026 - 02/02/2026',
      );
    });

    test('formatMonthYear usa mês por extenso no locale padrão', () {
      expect(DateUtils.formatMonthYear(DateTime(2026, 3, 15)), 'March 2026');
    });

    test('formatDuration menores que 60 min', () {
      expect(DateUtils.formatDuration(30), '30 min');
      expect(DateUtils.formatDuration(0), '0 min');
    });

    test('formatDuration em horas exatas', () {
      expect(DateUtils.formatDuration(60), '1 hora');
      expect(DateUtils.formatDuration(120), '2 horas');
    });

    test('formatDuration com minutos', () {
      expect(DateUtils.formatDuration(90), '1 h 30 min');
      expect(DateUtils.formatDuration(135), '2 h 15 min');
    });
  });

  group('DateUtils - datas', () {
    test('isToday reconhece hoje', () {
      final now = DateTime.now();

      expect(DateUtils.isToday(now), isTrue);
      expect(DateUtils.isToday(now.subtract(const Duration(days: 1))), isFalse);
    });

    test('isTomorrow reconhece amanhã', () {
      final amanha = DateTime.now().add(const Duration(days: 1));

      expect(DateUtils.isTomorrow(amanha), isTrue);
      expect(DateUtils.isTomorrow(DateTime.now()), isFalse);
    });

    test('isPast e isInFuture', () {
      final passado = DateTime.now().subtract(const Duration(days: 1));
      final futuro = DateTime.now().add(const Duration(days: 1));

      expect(DateUtils.isPast(passado), isTrue);
      expect(DateUtils.isInFuture(passado), isFalse);
      expect(DateUtils.isPast(futuro), isFalse);
      expect(DateUtils.isInFuture(futuro), isTrue);
    });

    test('getDaysInMonth retorna todos os dias do mês', () {
      final jan = DateUtils.getDaysInMonth(2026, 1);

      expect(jan, hasLength(31));
      expect(jan.first, DateTime(2026, 1, 1));
      expect(jan.last, DateTime(2026, 1, 31));

      final fev = DateUtils.getDaysInMonth(2026, 2);
      expect(fev, hasLength(28));
    });

    test('getAvailableSlots converte strings de horário em DateTime', () {
      final slots = DateUtils.getAvailableSlots(
        DateTime(2026, 3, 10),
        ['09:00', '14:30'],
      );

      expect(slots, hasLength(2));
      expect(slots[0], DateTime(2026, 3, 10, 9, 0));
      expect(slots[1], DateTime(2026, 3, 10, 14, 30));
    });
  });

  group('DateUtils - locale pt_BR', () {
    test('formatDayOfWeek usa abreviação em português', () {
      expect(DateUtils.formatDayOfWeek(DateTime(2026, 1, 16)), 'sex.');
    });
  });
}