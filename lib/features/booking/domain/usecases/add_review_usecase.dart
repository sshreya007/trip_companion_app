import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class AddReviewUsecase {
  final IBookingRepository repository;

  AddReviewUsecase(this.repository);

  Future<Either<Failure, BookingEntity>> call(
    String id,
    double rating,
    String comment,
  ) async {
    return repository.addReview(id, rating, comment);
  }
}
