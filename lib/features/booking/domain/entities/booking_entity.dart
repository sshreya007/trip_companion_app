import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String userId;
  final String packageId;
  final String bookingReference;
  final BookingStatus status;
  final List<TravelerEntity> travelers;
  final DateTime travelDate;
  final NumberOfTravelersEntity numberOfTravelers;
  final double totalPrice;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final String? specialRequests;
  final EmergencyContactEntity emergencyContact;
  final List<AddOnEntity> addOns;
  final DiscountEntity discount;
  final DateTime bookingDate;
  final DateTime? cancellationDate;
  final String? cancellationReason;
  final ReviewEntity? review;
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.bookingReference,
    required this.status,
    required this.travelers,
    required this.travelDate,
    required this.numberOfTravelers,
    required this.totalPrice,
    required this.paymentStatus,
    this.paymentMethod,
    this.specialRequests,
    required this.emergencyContact,
    required this.addOns,
    required this.discount,
    required this.bookingDate,
    this.cancellationDate,
    this.cancellationReason,
    this.review,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    packageId,
    bookingReference,
    status,
    travelers,
    travelDate,
    numberOfTravelers,
    totalPrice,
    paymentStatus,
    paymentMethod,
    specialRequests,
    emergencyContact,
    addOns,
    discount,
    bookingDate,
    cancellationDate,
    cancellationReason,
    review,
    createdAt,
  ];
}

enum BookingStatus { pending, confirmed, cancelled, completed }

enum PaymentStatus { pending, paid, refunded }

class TravelerEntity extends Equatable {
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String? passportNumber;
  final String email;
  final String phone;

  const TravelerEntity({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    this.passportNumber,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    age,
    gender,
    passportNumber,
    email,
    phone,
  ];
}

class NumberOfTravelersEntity extends Equatable {
  final int adults;
  final int children;

  const NumberOfTravelersEntity({required this.adults, required this.children});

  int get total => adults + children;

  @override
  List<Object> get props => [adults, children];
}

class EmergencyContactEntity extends Equatable {
  final String name;
  final String phone;
  final String relation;

  const EmergencyContactEntity({
    required this.name,
    required this.phone,
    required this.relation,
  });

  @override
  List<Object> get props => [name, phone, relation];
}

class AddOnEntity extends Equatable {
  final String name;
  final double price;

  const AddOnEntity({required this.name, required this.price});

  @override
  List<Object> get props => [name, price];
}

class DiscountEntity extends Equatable {
  final String? code;
  final double amount;

  const DiscountEntity({this.code, required this.amount});

  @override
  List<Object?> get props => [code, amount];
}

class ReviewEntity extends Equatable {
  final double rating;
  final String comment;
  final DateTime reviewDate;

  const ReviewEntity({
    required this.rating,
    required this.comment,
    required this.reviewDate,
  });

  @override
  List<Object> get props => [rating, comment, reviewDate];
}

class CreateBookingEntity {
  final String packageId;
  final List<TravelerEntity> travelers;
  final DateTime travelDate;
  final NumberOfTravelersEntity numberOfTravelers;
  final EmergencyContactEntity emergencyContact;
  final String? specialRequests;
  final List<AddOnEntity>? addOns;
  final String? discountCode;
  final String? paymentMethod;

  CreateBookingEntity({
    required this.packageId,
    required this.travelers,
    required this.travelDate,
    required this.numberOfTravelers,
    required this.emergencyContact,
    this.specialRequests,
    this.addOns,
    this.discountCode,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'travelers': travelers
          .map(
            (t) => {
              'firstName': t.firstName,
              'lastName': t.lastName,
              'age': t.age,
              'gender': t.gender,
              'passportNumber': t.passportNumber,
              'email': t.email,
              'phone': t.phone,
            },
          )
          .toList(),
      'travelDate': travelDate.toIso8601String(),
      'numberOfTravelers': {
        'adults': numberOfTravelers.adults,
        'children': numberOfTravelers.children,
      },
      'emergencyContact': {
        'name': emergencyContact.name,
        'phone': emergencyContact.phone,
        'relation': emergencyContact.relation,
      },
      if (specialRequests != null) 'specialRequests': specialRequests,
      if (addOns != null)
        'addOns': addOns!
            .map((a) => {'name': a.name, 'price': a.price})
            .toList(),
      if (discountCode != null) 'discountCode': discountCode,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
    };
  }
}

class BookingFilterEntity {
  final BookingStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String sortBy;
  final String sortOrder;
  final int page;
  final int limit;

  BookingFilterEntity({
    this.status,
    this.startDate,
    this.endDate,
    this.sortBy = 'bookingDate',
    this.sortOrder = 'desc',
    this.page = 1,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (status != null) data['status'] = status!.name;
    if (startDate != null) data['startDate'] = startDate!.toIso8601String();
    if (endDate != null) data['endDate'] = endDate!.toIso8601String();
    data['sortBy'] = sortBy;
    data['sortOrder'] = sortOrder;
    data['page'] = page;
    data['limit'] = limit;
    return data;
  }
}
