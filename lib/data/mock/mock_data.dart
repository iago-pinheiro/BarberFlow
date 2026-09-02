import '../../core/constants/app_strings.dart';
import '../models/service_model.dart';
import '../models/professional_model.dart';

class MockData {
  static List<Service> services = [
    Service(
      id: '1',
      name: AppStrings.haircut,
      description: 'Corte tradicional com navalha ou tesoura',
      price: 25.0,
      duration: 30,
      type: ServiceType.haircut,
      image: 'assets/haircut.png',
    ),
    Service(
      id: '2',
      name: AppStrings.beard,
      description: 'Modelagem de barba com navalha e pomada',
      price: 20.0,
      duration: 25,
      type: ServiceType.beard,
      image: 'assets/beard.png',
    ),
    Service(
      id: '3',
      name: AppStrings.haircutAndBeard,
      description: 'Combo completo: corte de cabelo + modelagem de barba',
      price: 45.0,
      duration: 55,
      type: ServiceType.haircutAndBeard,
      image: 'assets/haircut-beard.png',
    ),
    Service(
      id: '4',
      name: AppStrings.eyebrow,
      description: 'Design e delimitação de sobrancelhas',
      price: 15.0,
      duration: 15,
      type: ServiceType.eyebrow,
      image: 'assets/eyebrow.png',
    ),
  ];

  static List<Professional> professionals = [
    Professional(
      id: 'p1',
      name: 'Carlos Silva',
      specialty: 'Corte e Barba',
      specialtyType: ProfessionalSpecialty.haircutAndBeard,
      availableHours: ['09:00', '09:30', '10:00', '10:30', '11:00', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30'],
      image: 'assets/carlos.png',
      rating: 5,
      bio: '10 anos de experiência em cortes clássicos e modernos.',
    ),
    Professional(
      id: 'p2',
      name: 'João Pedro',
      specialty: 'Barba e Sobrancelha',
      specialtyType: ProfessionalSpecialty.beard,
      availableHours: ['08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '13:00', '13:30', '14:00', '15:00', '16:00'],
      image: 'assets/joao.png',
      rating: 4,
      bio: 'Especialista em modelagem de barba e sobrancelhas.',
    ),
    Professional(
      id: 'p3',
      name: 'Ricardo Almeida',
      specialty: 'Corte Premium',
      specialtyType: ProfessionalSpecialty.haircut,
      availableHours: ['09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'],
      image: 'assets/ricardo.png',
      rating: 5,
      bio: 'Técnica premium com acabamento impecável.',
    ),
    Professional(
      id: 'p4',
      name: 'Fernanda Costa',
      specialty: 'Design de Sobrancelha',
      specialtyType: ProfessionalSpecialty.eyebrow,
      availableHours: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '13:00', '14:00', '15:00', '16:00'],
      image: 'assets/fernanda.png',
      rating: 4,
      bio: 'Expert em design e henna de sobrancelhas.',
    ),
  ];
}