import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/booking_entity.dart';

abstract class IBookingRepository {
  Future<Either<Failure, BookingEntity>> createBooking(
    CreateBookingEntity booking,
  );
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(
    BookingFilterEntity filters,
  );
  Future<Either<Failure, BookingEntity>> getBookingById(String id);
  Future<Either<Failure, BookingEntity>> getBookingByReference(
    String reference,
  );
  Future<Either<Failure, BookingEntity>> cancelBooking(
    String id,
    String reason,
  );
  Future<Either<Failure, BookingEntity>> addReview(
    String id,
    double rating,
    String comment,
  );
  Future<Either<Failure, Map<String, dynamic>>> getBookingStats();
}
