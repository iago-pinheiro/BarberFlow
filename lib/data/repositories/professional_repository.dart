import '../models/professional_model.dart';
import '../models/service_model.dart';
import '../mock/mock_data.dart';

class ProfessionalRepository {
  List<Professional> getProfessionals() => MockData.professionals;

  Professional? getProfessionalById(String id) {
    try {
      return MockData.professionals.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Professional> getAvailableProfessionals(String serviceId) {
    final service = getServiceById(serviceId);
    if (service == null) return [];
    return MockData.professionals
        .where((p) => _matchesService(p.specialtyType, service.type))
        .toList();
  }

  Service? getServiceById(String id) {
    try {
      return MockData.services.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  bool _matchesService(ProfessionalSpecialty pType, ServiceType sType) {
    switch (sType) {
      case ServiceType.haircut:
        return pType == ProfessionalSpecialty.haircut ||
            pType == ProfessionalSpecialty.haircutAndBeard;
      case ServiceType.beard:
        return pType == ProfessionalSpecialty.beard ||
            pType == ProfessionalSpecialty.haircutAndBeard;
      case ServiceType.eyebrow:
        return pType == ProfessionalSpecialty.eyebrow;
      case ServiceType.haircutAndBeard:
        return pType == ProfessionalSpecialty.haircutAndBeard;
    }
  }
}