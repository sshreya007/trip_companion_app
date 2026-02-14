import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';
import 'package:trip_planner/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:trip_planner/features/booking/domain/usecases/get_user_bookings_usecase.dart';
import 'package:trip_planner/features/booking/domain/usecases/get_booking_by_id_usecase.dart';
import 'package:trip_planner/features/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:trip_planner/features/booking/domain/usecases/add_review_usecase.dart';
import 'package:trip_planner/features/booking/presentation/state/booking_state.dart'
    hide BookingStatus;
import 'package:trip_planner/features/booking/data/datasources/remote/booking_remote_datasource.dart';
import 'package:trip_planner/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:trip_planner/core/network/dio_client.dart';

// Providers
final bookingRemoteDatasourceProvider = Provider<BookingRemoteDatasource>((
  ref,
) {
  final dioClient = ref.read(dioClientProvider);
  return BookingRemoteDatasource(dioClient);
});

final bookingRepositoryProvider = Provider((ref) {
  final remoteDatasource = ref.read(bookingRemoteDatasourceProvider);
  return BookingRepositoryImpl(remoteDatasource);
});

final createBookingUsecaseProvider = Provider((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return CreateBookingUsecase(repository);
});

final getUserBookingsUsecaseProvider = Provider((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetUserBookingsUsecase(repository);
});

final getBookingByIdUsecaseProvider = Provider((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetBookingByIdUsecase(repository);
});

final cancelBookingUsecaseProvider = Provider((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return CancelBookingUsecase(repository);
});

final addReviewUsecaseProvider = Provider((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return AddReviewUsecase(repository);
});

final bookingViewModelProvider =
    NotifierProvider<BookingViewModel, BookingState>(BookingViewModel.new);

class BookingViewModel extends Notifier<BookingState> {
  late final CreateBookingUsecase _createBookingUsecase;
  late final GetUserBookingsUsecase _getUserBookingsUsecase;
  late final GetBookingByIdUsecase _getBookingByIdUsecase;
  late final CancelBookingUsecase _cancelBookingUsecase;
  late final AddReviewUsecase _addReviewUsecase;

  @override
  BookingState build() {
    _createBookingUsecase = ref.read(createBookingUsecaseProvider);
    _getUserBookingsUsecase = ref.read(getUserBookingsUsecaseProvider);
    _getBookingByIdUsecase = ref.read(getBookingByIdUsecaseProvider);
    _cancelBookingUsecase = ref.read(cancelBookingUsecaseProvider);
    _addReviewUsecase = ref.read(addReviewUsecaseProvider);

    return const BookingState();
  }

  // At the top of the file, update all references:

  /// Create booking
  Future<bool> createBooking(CreateBookingEntity booking) async {
    print('🎯 VIEWMODEL: Creating booking');

    state = state.copyWith(
      status: BookingUIStatus.creating,
    ); // ✅ BookingUIStatus

    final result = await _createBookingUsecase(booking);

    return result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to create booking - ${failure.message}');
        state = state.copyWith(
          status: BookingUIStatus.error, // ✅ BookingUIStatus
          errorMessage: failure.message,
        );
        return false;
      },
      (bookingEntity) {
        print(
          '✅ VIEWMODEL: Booking created - ${bookingEntity.bookingReference}',
        );
        state = state.copyWith(
          status: BookingUIStatus.created, // ✅ BookingUIStatus
          selectedBooking: bookingEntity,
        );
        return true;
      },
    );
  }

  /// Get user bookings
  Future<void> getUserBookings({
    BookingStatus?
    filterStatus, // ✅ This is the ENTITY status (pending, confirmed, etc.)
    DateTime? startDate,
    DateTime? endDate,
    String sortBy = 'bookingDate',
    String sortOrder = 'desc',
    bool refresh = false,
  }) async {
    print('🎯 VIEWMODEL: Getting user bookings');

    if (refresh) {
      state = state.copyWith(
        status: BookingUIStatus.loading, // ✅ BookingUIStatus
        currentPage: 1,
        bookings: [],
      );
    } else if (state.status == BookingUIStatus.loading) {
      // ✅ BookingUIStatus
      return; // Already loading
    }

    final filters = BookingFilterEntity(
      status: filterStatus,
      startDate: startDate,
      endDate: endDate,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: refresh ? 1 : state.currentPage,
      limit: 10,
    );

    final result = await _getUserBookingsUsecase(filters);

    result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to get bookings - ${failure.message}');
        state = state.copyWith(
          status: BookingUIStatus.error, // ✅ BookingUIStatus
          errorMessage: failure.message,
        );
      },
      (bookings) {
        print('✅ VIEWMODEL: ${bookings.length} bookings loaded');

        final allBookings = refresh
            ? bookings
            : [...state.bookings, ...bookings];

        state = state.copyWith(
          status: BookingUIStatus.loaded, // ✅ BookingUIStatus
          bookings: allBookings,
          hasMore: bookings.length >= 10,
          currentPage: state.currentPage + 1,
        );
      },
    );
  }

  /// Get booking by ID
  Future<void> getBookingById(String id) async {
    print('🎯 VIEWMODEL: Getting booking by ID: $id');

    state = state.copyWith(
      status: BookingUIStatus.loading,
    ); // ✅ BookingUIStatus

    final result = await _getBookingByIdUsecase(id);

    result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to get booking - ${failure.message}');
        state = state.copyWith(
          status: BookingUIStatus.error, // ✅ BookingUIStatus
          errorMessage: failure.message,
        );
      },
      (booking) {
        print('✅ VIEWMODEL: Booking loaded - ${booking.bookingReference}');
        state = state.copyWith(
          status: BookingUIStatus.loaded, // ✅ BookingUIStatus
          selectedBooking: booking,
        );
      },
    );
  }

  /// Cancel booking
  Future<bool> cancelBooking(String id, String reason) async {
    print('🎯 VIEWMODEL: Cancelling booking: $id');

    state = state.copyWith(
      status: BookingUIStatus.cancelling,
    ); // ✅ BookingUIStatus

    final result = await _cancelBookingUsecase(id, reason);

    return result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to cancel booking - ${failure.message}');
        state = state.copyWith(
          status: BookingUIStatus.error, // ✅ BookingUIStatus
          errorMessage: failure.message,
        );
        return false;
      },
      (booking) {
        print('✅ VIEWMODEL: Booking cancelled');

        // Update the booking in the list
        final updatedBookings = state.bookings.map((b) {
          return b.id == booking.id ? booking : b;
        }).toList();

        state = state.copyWith(
          status: BookingUIStatus.cancelled, // ✅ BookingUIStatus
          bookings: updatedBookings,
          selectedBooking: booking,
        );
        return true;
      },
    );
  }

  /// Add review
  Future<bool> addReview(String id, double rating, String comment) async {
    print('🎯 VIEWMODEL: Adding review to booking: $id');

    state = state.copyWith(
      status: BookingUIStatus.loading,
    ); // ✅ BookingUIStatus

    final result = await _addReviewUsecase(id, rating, comment);

    return result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to add review - ${failure.message}');
        state = state.copyWith(
          status: BookingUIStatus.error, // ✅ BookingUIStatus
          errorMessage: failure.message,
        );
        return false;
      },
      (booking) {
        print('✅ VIEWMODEL: Review added');

        // Update the booking in the list
        final updatedBookings = state.bookings.map((b) {
          return b.id == booking.id ? booking : b;
        }).toList();

        state = state.copyWith(
          status: BookingUIStatus.loaded, // ✅ BookingUIStatus
          bookings: updatedBookings,
          selectedBooking: booking,
        );
        return true;
      },
    );
  }

  /// Clear selected booking
  void clearSelectedBooking() {
    state = state.copyWith(
      clearSelectedBooking: true,
      status: BookingUIStatus.initial, // ✅ BookingUIStatus
    );
  }

  /// Filter bookings by status locally
  List<BookingEntity> getBookingsByStatus(BookingStatus filterStatus) {
    // ✅ This is entity status
    return state.bookings.where((booking) {
      return booking.status == filterStatus;
    }).toList();
  }
}
