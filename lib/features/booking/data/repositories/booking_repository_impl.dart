import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';
import 'package:trip_planner/features/booking/domain/repositories/booking_repository.dart';
import 'package:trip_planner/features/booking/data/datasources/remote/booking_remote_datasource.dart';

class BookingRepositoryImpl implements IBookingRepository {
  final BookingRemoteDatasource _remoteDatasource;

  BookingRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, BookingEntity>> createBooking(
    CreateBookingEntity booking,
  ) async {
    try {
      print('📁 REPOSITORY: Creating booking');

      final bookingModel = await _remoteDatasource.createBooking(booking);
      final entity = bookingModel.toEntity();

      print('📁 REPOSITORY: Booking created - ${entity.bookingReference}');

      return Right(entity);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(
    BookingFilterEntity filters,
  ) async {
    try {
      print('📁 REPOSITORY: Getting user bookings');

      final bookings = await _remoteDatasource.getUserBookings(filters);
      final entities = bookings.map((model) => model.toEntity()).toList();

      print('📁 REPOSITORY: ${entities.length} bookings retrieved');

      return Right(entities);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingById(String id) async {
    try {
      print('📁 REPOSITORY: Getting booking by ID: $id');

      final booking = await _remoteDatasource.getBookingById(id);
      final entity = booking.toEntity();

      print('📁 REPOSITORY: Booking retrieved');

      return Right(entity);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingByReference(
    String reference,
  ) async {
    try {
      print('📁 REPOSITORY: Getting booking by reference: $reference');

      final booking = await _remoteDatasource.getBookingByReference(reference);
      final entity = booking.toEntity();

      print('📁 REPOSITORY: Booking retrieved');

      return Right(entity);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking(
    String id,
    String reason,
  ) async {
    try {
      print('📁 REPOSITORY: Cancelling booking: $id');

      final booking = await _remoteDatasource.cancelBooking(id, reason);
      final entity = booking.toEntity();

      print('📁 REPOSITORY: Booking cancelled');

      return Right(entity);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> addReview(
    String id,
    double rating,
    String comment,
  ) async {
    try {
      print('📁 REPOSITORY: Adding review to booking: $id');

      final booking = await _remoteDatasource.addReview(id, rating, comment);
      final entity = booking.toEntity();

      print('📁 REPOSITORY: Review added');

      return Right(entity);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBookingStats() async {
    try {
      print('📁 REPOSITORY: Getting booking stats');

      final stats = await _remoteDatasource.getBookingStats();

      print('📁 REPOSITORY: Stats retrieved');

      return Right(stats);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
