import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUsecase {
  final IBookingRepository repository;

  CreateBookingUsecase(this.repository);

  Future<Either<Failure, BookingEntity>> call(
    CreateBookingEntity booking,
  ) async {
    return repository.createBooking(booking);
  }
}
