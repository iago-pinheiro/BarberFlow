import '../models/service_model.dart';
import '../mock/mock_data.dart';

class ServiceRepository {
  List<Service> getServices() => MockData.services;

  Service? getServiceById(String id) {
    try {
      return MockData.services.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}