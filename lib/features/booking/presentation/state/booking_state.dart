import 'package:equatable/equatable.dart';
import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';

enum BookingStatus {
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
  final BookingStatus status;
  final List<BookingEntity> bookings;
  final BookingEntity? selectedBooking;
  final Map<String, dynamic>? bookingStats;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.bookings = const [],
    this.selectedBooking,
    this.bookingStats,
    this.errorMessage,
    this.hasMore = true,
    this.currentPage = 1,
  });

  BookingState copyWith({
    BookingStatus? status,
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
