import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';

class BookingModel {
  final String id;
  final String userId;
  final String packageId;
  final String bookingReference;
  final String status;
  final List<TravelerModel> travelers;
  final DateTime travelDate;
  final NumberOfTravelersModel numberOfTravelers;
  final double totalPrice;
  final String paymentStatus;
  final String? paymentMethod;
  final String? specialRequests;
  final EmergencyContactModel emergencyContact;
  final List<AddOnModel> addOns;
  final DiscountModel discount;
  final DateTime bookingDate;
  final DateTime? cancellationDate;
  final String? cancellationReason;
  final ReviewModel? review;
  final DateTime createdAt;

  BookingModel({
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

  // Convert JSON → Model
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] is String
          ? json['userId']
          : json['userId']?['_id'] ?? '',
      packageId: json['packageId'] is String
          ? json['packageId']
          : json['packageId']?['_id'] ?? '',
      bookingReference: json['bookingReference'] ?? '',
      status: json['status'] ?? 'pending',
      travelers:
          (json['travelers'] as List<dynamic>?)
              ?.map((e) => TravelerModel.fromJson(e))
              .toList() ??
          [],
      travelDate: DateTime.tryParse(json['travelDate'] ?? '') ?? DateTime.now(),
      numberOfTravelers: NumberOfTravelersModel.fromJson(
        json['numberOfTravelers'] ?? {},
      ),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      paymentMethod: json['paymentMethod'],
      specialRequests: json['specialRequests'],
      emergencyContact: EmergencyContactModel.fromJson(
        json['emergencyContact'] ?? {},
      ),
      addOns:
          (json['addOns'] as List<dynamic>?)
              ?.map((e) => AddOnModel.fromJson(e))
              .toList() ??
          [],
      discount: DiscountModel.fromJson(json['discount'] ?? {}),
      bookingDate:
          DateTime.tryParse(json['bookingDate'] ?? '') ?? DateTime.now(),
      cancellationDate: json['cancellationDate'] != null
          ? DateTime.tryParse(json['cancellationDate'])
          : null,
      cancellationReason: json['cancellationReason'],
      review: json['review'] != null
          ? ReviewModel.fromJson(json['review'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Convert Model → Entity
  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      userId: userId,
      packageId: packageId,
      bookingReference: bookingReference,
      status: _parseBookingStatus(status),
      travelers: travelers.map((t) => t.toEntity()).toList(),
      travelDate: travelDate,
      numberOfTravelers: numberOfTravelers.toEntity(),
      totalPrice: totalPrice,
      paymentStatus: _parsePaymentStatus(paymentStatus),
      paymentMethod: paymentMethod,
      specialRequests: specialRequests,
      emergencyContact: emergencyContact.toEntity(),
      addOns: addOns.map((a) => a.toEntity()).toList(),
      discount: discount.toEntity(),
      bookingDate: bookingDate,
      cancellationDate: cancellationDate,
      cancellationReason: cancellationReason,
      review: review?.toEntity(),
      createdAt: createdAt,
    );
  }

  BookingStatus _parseBookingStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }

  PaymentStatus _parsePaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'paid':
        return PaymentStatus.paid;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }
}

class TravelerModel {
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String? passportNumber;
  final String email;
  final String phone;

  TravelerModel({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    this.passportNumber,
    required this.email,
    required this.phone,
  });

  factory TravelerModel.fromJson(Map<String, dynamic> json) {
    return TravelerModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      passportNumber: json['passportNumber'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  TravelerEntity toEntity() => TravelerEntity(
    firstName: firstName,
    lastName: lastName,
    age: age,
    gender: gender,
    passportNumber: passportNumber,
    email: email,
    phone: phone,
  );

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      if (passportNumber != null) 'passportNumber': passportNumber,
      'email': email,
      'phone': phone,
    };
  }
}

class NumberOfTravelersModel {
  final int adults;
  final int children;

  NumberOfTravelersModel({required this.adults, required this.children});

  factory NumberOfTravelersModel.fromJson(Map<String, dynamic> json) {
    return NumberOfTravelersModel(
      adults: json['adults'] ?? 1,
      children: json['children'] ?? 0,
    );
  }

  NumberOfTravelersEntity toEntity() =>
      NumberOfTravelersEntity(adults: adults, children: children);

  Map<String, dynamic> toJson() => {'adults': adults, 'children': children};
}

class EmergencyContactModel {
  final String name;
  final String phone;
  final String relation;

  EmergencyContactModel({
    required this.name,
    required this.phone,
    required this.relation,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      relation: json['relation'] ?? '',
    );
  }

  EmergencyContactEntity toEntity() =>
      EmergencyContactEntity(name: name, phone: phone, relation: relation);

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'relation': relation,
  };
}

class AddOnModel {
  final String name;
  final double price;

  AddOnModel({required this.name, required this.price});

  factory AddOnModel.fromJson(Map<String, dynamic> json) {
    return AddOnModel(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  AddOnEntity toEntity() => AddOnEntity(name: name, price: price);

  Map<String, dynamic> toJson() => {'name': name, 'price': price};
}

class DiscountModel {
  final String? code;
  final double amount;

  DiscountModel({this.code, required this.amount});

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      code: json['code'],
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  DiscountEntity toEntity() => DiscountEntity(code: code, amount: amount);
}

class ReviewModel {
  final double rating;
  final String comment;
  final DateTime reviewDate;

  ReviewModel({
    required this.rating,
    required this.comment,
    required this.reviewDate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      reviewDate: DateTime.tryParse(json['reviewDate'] ?? '') ?? DateTime.now(),
    );
  }

  ReviewEntity toEntity() =>
      ReviewEntity(rating: rating, comment: comment, reviewDate: reviewDate);
}
