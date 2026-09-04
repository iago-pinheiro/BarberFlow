import 'package:flutter/foundation.dart';

class BookingState {
  final String? selectedServiceId;
  final String? selectedProfessionalId;
  final DateTime? selectedDate;
  final DateTime? selectedTime;
  final String clientName;
  final String observations;

  const BookingState({
    this.selectedServiceId,
    this.selectedProfessionalId,
    this.selectedDate,
    this.selectedTime,
    this.clientName = '',
    this.observations = '',
  });

  BookingState copyWith({
    String? selectedServiceId,
    String? selectedProfessionalId,
    DateTime? selectedDate,
    DateTime? selectedTime,
    String? clientName,
    String? observations,
  }) {
    return BookingState(
      selectedServiceId: selectedServiceId ?? this.selectedServiceId,
      selectedProfessionalId:
          selectedProfessionalId ?? this.selectedProfessionalId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      clientName: clientName ?? this.clientName,
      observations: observations ?? this.observations,
    );
  }

  bool get hasSelectedService => selectedServiceId != null;
  bool get hasSelectedProfessional => selectedProfessionalId != null;
  bool get hasSelectedDate => selectedDate != null;
  bool get hasSelectedTime => selectedTime != null;
  bool get isComplete =>
      selectedServiceId != null &&
      selectedProfessionalId != null &&
      selectedDate != null &&
      selectedTime != null &&
      clientName.isNotEmpty;
}

class BookingProvider extends ChangeNotifier {
  BookingState _state = const BookingState();

  BookingState get state => _state;

  void selectService(String serviceId) {
    if (_state.selectedServiceId == serviceId) return;

    _state = BookingState(
      selectedServiceId: serviceId,
      selectedDate: _state.selectedDate,
      clientName: _state.clientName,
      observations: _state.observations,
    );
    notifyListeners();
  }

  void selectProfessional(String professionalId) {
    if (_state.selectedProfessionalId == professionalId) return;

    _state = BookingState(
      selectedServiceId: _state.selectedServiceId,
      selectedProfessionalId: professionalId,
      selectedDate: _state.selectedDate,
      clientName: _state.clientName,
      observations: _state.observations,
    );
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _state = _state.copyWith(selectedDate: date);
    notifyListeners();
  }

  void selectTime(DateTime time) {
    _state = _state.copyWith(selectedTime: time);
    notifyListeners();
  }

  void setClientName(String name) {
    _state = _state.copyWith(clientName: name);
    notifyListeners();
  }

  void setObservations(String obs) {
    _state = _state.copyWith(observations: obs);
    notifyListeners();
  }

  void reset() {
    _state = const BookingState();
    notifyListeners();
  }
}
