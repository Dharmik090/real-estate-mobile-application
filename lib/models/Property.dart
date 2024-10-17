class Property {
  final String id;
  final String title;
  final String description;
  final num price;
  final num bhk;
  final num area;
  final String status;
  final String location;
  final String city;
  final String state;
  final String country;
  final num latitude;
  final num longtitude;
  final List<String> imageUrls;


  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.bhk,
    required this.area,
    required this.status,
    required this.location,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longtitude,
    required this.imageUrls
  });

  factory Property.fromJson(dynamic json) {
    var images = json['images'] as List<dynamic>;
    List<String> imageList = images.map((img) => img as String).toList();

    return Property(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      bhk: (json['bhk'] as num).toInt(),
      area: (json['area'] as num).toDouble(),
      status: json['status'] as String,
      location: json['location'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toInt(),
      longtitude: 0,
      imageUrls: imageList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'bhk': bhk,
      'area': area,
      'status': status,
      'location': location,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longtitude': longtitude,
      'imageUrls': imageUrls,
    };
  }}