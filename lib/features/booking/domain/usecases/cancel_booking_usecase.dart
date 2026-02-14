import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CancelBookingUsecase {
  final IBookingRepository repository;

  CancelBookingUsecase(this.repository);

  Future<Either<Failure, BookingEntity>> call(String id, String reason) async {
    return repository.cancelBooking(id, reason);
  }
}
