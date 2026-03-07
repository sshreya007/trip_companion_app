import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetUserBookingsUsecase {
  final IBookingRepository repository;

  GetUserBookingsUsecase(this.repository);

  Future<Either<Failure, List<BookingEntity>>> call(
    BookingFilterEntity filters,
  ) async {
    return repository.getUserBookings(filters);
  }
}
