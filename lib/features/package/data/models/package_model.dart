import 'package:trip_planner/features/package/domain/entities/package_entity.dart';

class PackageModel {
  final String id;
  final String title;
  final String destination;
  final String country;
  final String description;
  final String shortDescription;
  final DurationModel duration;
  final PriceModel price;
  final String coverImage;
  final List<String> images;
  final String category;
  final List<String> includes;
  final List<String> excludes;
  final List<ItineraryModel> itinerary;
  final AccommodationModel? accommodation;
  final List<String> highlights;
  final AvailabilityModel availability;
  final RatingModel rating;
  final List<String> tags;
  final bool isActive;
  final bool featured;
  final String? cancellationPolicy;
  final String? termsAndConditions;
  final DateTime createdAt;

  PackageModel({
    required this.id,
    required this.title,
    required this.destination,
    required this.country,
    required this.description,
    required this.shortDescription,
    required this.duration,
    required this.price,
    required this.coverImage,
    required this.images,
    required this.category,
    required this.includes,
    required this.excludes,
    required this.itinerary,
    this.accommodation,
    required this.highlights,
    required this.availability,
    required this.rating,
    required this.tags,
    required this.isActive,
    required this.featured,
    this.cancellationPolicy,
    this.termsAndConditions,
    required this.createdAt,
  });

  // Convert JSON → Model
  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      destination: json['destination'] ?? '',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      duration: DurationModel.fromJson(json['duration'] ?? {}),
      price: PriceModel.fromJson(json['price'] ?? {}),
      coverImage: json['coverImage'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      includes: List<String>.from(json['includes'] ?? []),
      excludes: List<String>.from(json['excludes'] ?? []),
      itinerary:
          (json['itinerary'] as List<dynamic>?)
              ?.map((e) => ItineraryModel.fromJson(e))
              .toList() ??
          [],
      accommodation: json['accommodation'] != null
          ? AccommodationModel.fromJson(json['accommodation'])
          : null,
      highlights: List<String>.from(json['highlights'] ?? []),
      availability: AvailabilityModel.fromJson(json['availability'] ?? {}),
      rating: RatingModel.fromJson(json['rating'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      isActive: json['isActive'] ?? true,
      featured: json['featured'] ?? false,
      cancellationPolicy: json['cancellationPolicy'],
      termsAndConditions: json['termsAndConditions'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Convert Model → Entity
  PackageEntity toEntity() {
    return PackageEntity(
      id: id,
      title: title,
      destination: destination,
      country: country,
      description: description,
      shortDescription: shortDescription,
      duration: duration.toEntity(),
      price: price.toEntity(),
      coverImage: coverImage,
      images: images,
      category: category,
      includes: includes,
      excludes: excludes,
      itinerary: itinerary.map((e) => e.toEntity()).toList(),
      accommodation: accommodation?.toEntity(),
      highlights: highlights,
      availability: availability.toEntity(),
      rating: rating.toEntity(),
      tags: tags,
      isActive: isActive,
      featured: featured,
      cancellationPolicy: cancellationPolicy,
      termsAndConditions: termsAndConditions,
      createdAt: createdAt,
    );
  }
}

class DurationModel {
  final int days;
  final int nights;

  DurationModel({required this.days, required this.nights});

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(days: json['days'] ?? 0, nights: json['nights'] ?? 0);
  }

  DurationEntity toEntity() => DurationEntity(days: days, nights: nights);
}

class PriceModel {
  final double amount;
  final String currency;
  final double? originalPrice;

  PriceModel({required this.amount, this.currency = 'USD', this.originalPrice});

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      originalPrice: json['originalPrice']?.toDouble(),
    );
  }

  PriceEntity toEntity() => PriceEntity(
    amount: amount,
    currency: currency,
    originalPrice: originalPrice,
  );
}

class ItineraryModel {
  final int day;
  final String title;
  final String? description;
  final List<String> activities;
  final List<String> meals;

  ItineraryModel({
    required this.day,
    required this.title,
    this.description,
    required this.activities,
    required this.meals,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    return ItineraryModel(
      day: json['day'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      activities: List<String>.from(json['activities'] ?? []),
      meals: List<String>.from(json['meals'] ?? []),
    );
  }

  ItineraryEntity toEntity() => ItineraryEntity(
    day: day,
    title: title,
    description: description,
    activities: activities,
    meals: meals,
  );
}

class AccommodationModel {
  final String hotelName;
  final int hotelRating;
  final String roomType;

  AccommodationModel({
    required this.hotelName,
    required this.hotelRating,
    required this.roomType,
  });

  factory AccommodationModel.fromJson(Map<String, dynamic> json) {
    return AccommodationModel(
      hotelName: json['hotelName'] ?? '',
      hotelRating: json['hotelRating'] ?? 0,
      roomType: json['roomType'] ?? '',
    );
  }

  AccommodationEntity toEntity() => AccommodationEntity(
    hotelName: hotelName,
    hotelRating: hotelRating,
    roomType: roomType,
  );
}

class AvailabilityModel {
  final DateTime startDate;
  final DateTime endDate;
  final int maxBookings;
  final int bookedCount;

  AvailabilityModel({
    required this.startDate,
    required this.endDate,
    required this.maxBookings,
    required this.bookedCount,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      maxBookings: json['maxBookings'] ?? 100,
      bookedCount: json['bookedCount'] ?? 0,
    );
  }

  AvailabilityEntity toEntity() => AvailabilityEntity(
    startDate: startDate,
    endDate: endDate,
    maxBookings: maxBookings,
    bookedCount: bookedCount,
  );
}

class RatingModel {
  final double average;
  final int count;

  RatingModel({required this.average, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }

  RatingEntity toEntity() => RatingEntity(average: average, count: count);
}
