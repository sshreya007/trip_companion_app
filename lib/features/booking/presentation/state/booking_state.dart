import 'package:equatable/equatable.dart';
import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';

// ✅ RENAMED: BookingStatus → BookingUIStatus (to avoid conflict with entity enum)
enum BookingUIStatus {
  initial,
  loading,
  loaded,
  creating,
  created,
  cancelling,
  cancelled,
  error,
}

class BookingState extends Equatable {
  final BookingUIStatus status; // ✅ Using BookingUIStatus
  final List<BookingEntity> bookings;
  final BookingEntity? selectedBooking;
  final Map<String, dynamic>? bookingStats;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;

  const BookingState({
    this.status = BookingUIStatus.initial, // ✅ BookingUIStatus.initial
    this.bookings = const [],
    this.selectedBooking,
    this.bookingStats,
    this.errorMessage,
    this.hasMore = true,
    this.currentPage = 1,
  });

  BookingState copyWith({
    BookingUIStatus? status, // ✅ BookingUIStatus
    List<BookingEntity>? bookings,
    BookingEntity? selectedBooking,
    Map<String, dynamic>? bookingStats,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
    bool clearSelectedBooking = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      selectedBooking: clearSelectedBooking
          ? null
          : (selectedBooking ?? this.selectedBooking),
      bookingStats: bookingStats ?? this.bookingStats,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bookings,
    selectedBooking,
    bookingStats,
    errorMessage,
    hasMore,
    currentPage,
  ];
}
