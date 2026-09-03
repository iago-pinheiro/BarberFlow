
enum ServiceType { haircut, beard, eyebrow, haircutAndBeard }

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;
  final ServiceType type;
  final String image;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.type,
    required this.image,
  });

  Service copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? duration,
    ServiceType? type,
    String? image,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) && other is Service && other.id == id;

  @override
  int get hashCode => id.hashCode;
}