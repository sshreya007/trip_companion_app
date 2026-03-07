import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingByIdUsecase {
  final IBookingRepository repository;

  GetBookingByIdUsecase(this.repository);

  Future<Either<Failure, BookingEntity>> call(String id) async {
    return repository.getBookingById(id);
  }
}
