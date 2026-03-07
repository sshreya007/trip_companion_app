import 'package:equatable/equatable.dart';

class PackageEntity extends Equatable {
  final String id;
  final String title;
  final String destination;
  final String country;
  final String description;
  final String shortDescription;
  final DurationEntity duration;
  final PriceEntity price;
  final String coverImage;
  final List<String> images;
  final String category;
  final List<String> includes;
  final List<String> excludes;
  final List<ItineraryEntity> itinerary;
  final AccommodationEntity? accommodation;
  final List<String> highlights;
  final AvailabilityEntity availability;
  final RatingEntity rating;
  final List<String> tags;
  final bool isActive;
  final bool featured;
  final String? cancellationPolicy;
  final String? termsAndConditions;
  final DateTime createdAt;

  const PackageEntity({
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

  @override
  List<Object?> get props => [
    id,
    title,
    destination,
    country,
    description,
    shortDescription,
    duration,
    price,
    coverImage,
    images,
    category,
    includes,
    excludes,
    itinerary,
    accommodation,
    highlights,
    availability,
    rating,
    tags,
    isActive,
    featured,
    cancellationPolicy,
    termsAndConditions,
    createdAt,
  ];
}

class DurationEntity extends Equatable {
  final int days;
  final int nights;

  const DurationEntity({required this.days, required this.nights});

  @override
  List<Object> get props => [days, nights];
}

class PriceEntity extends Equatable {
  final double amount;
  final String currency;
  final double? originalPrice;

  const PriceEntity({
    required this.amount,
    this.currency = 'USD',
    this.originalPrice,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > amount;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice! - amount) / originalPrice!) * 100;
  }

  @override
  List<Object?> get props => [amount, currency, originalPrice];
}

class ItineraryEntity extends Equatable {
  final int day;
  final String title;
  final String? description;
  final List<String> activities;
  final List<String> meals;

  const ItineraryEntity({
    required this.day,
    required this.title,
    this.description,
    required this.activities,
    required this.meals,
  });

  @override
  List<Object?> get props => [day, title, description, activities, meals];
}

class AccommodationEntity extends Equatable {
  final String hotelName;
  final int hotelRating;
  final String roomType;

  const AccommodationEntity({
    required this.hotelName,
    required this.hotelRating,
    required this.roomType,
  });

  @override
  List<Object> get props => [hotelName, hotelRating, roomType];
}

class AvailabilityEntity extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final int maxBookings;
  final int bookedCount;

  const AvailabilityEntity({
    required this.startDate,
    required this.endDate,
    required this.maxBookings,
    required this.bookedCount,
  });

  bool get isAvailable => bookedCount < maxBookings;
  int get spotsLeft => maxBookings - bookedCount;

  @override
  List<Object> get props => [startDate, endDate, maxBookings, bookedCount];
}

class RatingEntity extends Equatable {
  final double average;
  final int count;

  const RatingEntity({required this.average, required this.count});

  @override
  List<Object> get props => [average, count];
}

class PackageFilterEntity {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final int? minDays;
  final int? maxDays;
  final String? destination;
  final String? country;
  final bool? featured;
  final String? search;
  final String sortBy;
  final String sortOrder;
  final int page;
  final int limit;

  PackageFilterEntity({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minDays,
    this.maxDays,
    this.destination,
    this.country,
    this.featured,
    this.search,
    this.sortBy = 'createdAt',
    this.sortOrder = 'desc',
    this.page = 1,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (category != null) data['category'] = category;
    if (minPrice != null) data['minPrice'] = minPrice;
    if (maxPrice != null) data['maxPrice'] = maxPrice;
    if (minDays != null) data['minDays'] = minDays;
    if (maxDays != null) data['maxDays'] = maxDays;
    if (destination != null) data['destination'] = destination;
    if (country != null) data['country'] = country;
    if (featured != null) data['featured'] = featured;
    if (search != null) data['search'] = search;
    data['sortBy'] = sortBy;
    data['sortOrder'] = sortOrder;
    data['page'] = page;
    data['limit'] = limit;
    return data;
  }
}
