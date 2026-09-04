import 'package:flutter_test/flutter_test.dart';
import 'package:barberflow_app/data/repositories/professional_repository.dart';

void main() {
  group('ProfessionalRepository', () {
    test('getProfessionals retorna todos os profissionais mockados', () {
      final repo = ProfessionalRepository();

      final professionals = repo.getProfessionals();

      expect(professionals, hasLength(4));
    });

    test('getProfessionalById retorna o profissional correto', () {
      final repo = ProfessionalRepository();

      final professional = repo.getProfessionalById('p1');

      expect(professional, isNotNull);
      expect(professional!.id, 'p1');
      expect(professional.name, 'Carlos Silva');
    });

    test('getProfessionalById retorna null para id inválido', () {
      final repo = ProfessionalRepository();

      final professional = repo.getProfessionalById('nao-existe');

      expect(professional, isNull);
    });

    test('getAvailableProfessionals para corte retorna quem faz corte/barba', () {
      final repo = ProfessionalRepository();

      final professionals = repo.getAvailableProfessionals('1');

      expect(professionals.map((p) => p.id), containsAll(['p1', 'p3']));
      expect(professionals.map((p) => p.id), isNot(contains('p2')));
      expect(professionals.map((p) => p.id), isNot(contains('p4')));
    });

    test('getAvailableProfessionals para barba retorna quem faz barba', () {
      final repo = ProfessionalRepository();

      final professionals = repo.getAvailableProfessionals('2');

      expect(professionals.map((p) => p.id), containsAll(['p1', 'p2']));
    });

    test('getAvailableProfessionals para combo retorna apenas quem faz tudo', () {
      final repo = ProfessionalRepository();

      final professionals = repo.getAvailableProfessionals('3');

      expect(professionals, hasLength(1));
      expect(professionals.first.id, 'p1');
    });

    test('getAvailableProfessionals para sobrancelha retorna especialista', () {
      final repo = ProfessionalRepository();

      final professionals = repo.getAvailableProfessionals('4');

      expect(professionals, hasLength(1));
      expect(professionals.first.id, 'p4');
    });

    test('getAvailableProfessionals retorna lista vazia para serviço inválido', () {
      final repo = ProfessionalRepository();

      final professionals = repo.getAvailableProfessionals('nao-existe');

      expect(professionals, isEmpty);
    });
  });
}