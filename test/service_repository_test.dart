import 'package:flutter_test/flutter_test.dart';
import 'package:barberflow_app/data/models/service_model.dart';
import 'package:barberflow_app/data/repositories/service_repository.dart';

void main() {
  group('ServiceRepository', () {
    test('getServices retorna todos os serviços mockados', () {
      final repo = ServiceRepository();

      final services = repo.getServices();

      expect(services, hasLength(4));
    });

    test('getServiceById retorna o serviço correto', () {
      final repo = ServiceRepository();

      final service = repo.getServiceById('1');

      expect(service, isNotNull);
      expect(service!.id, '1');
      expect(service.type, ServiceType.haircut);
    });

    test('getServiceById retorna null para id inválido', () {
      final repo = ServiceRepository();

      final service = repo.getServiceById('nao-existe');

      expect(service, isNull);
    });
  });
}