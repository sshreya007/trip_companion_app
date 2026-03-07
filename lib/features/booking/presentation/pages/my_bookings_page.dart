import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:trip_planner/features/booking/presentation/state/booking_state.dart';
import 'package:trip_planner/features/booking/presentation/widgets/booking_card.dart';
import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';

class MyBookingsPage extends ConsumerStatefulWidget {
  const MyBookingsPage({super.key});

  @override
  ConsumerState<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends ConsumerState<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(bookingViewModelProvider.notifier)
          .getUserBookings(refresh: true);
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = ref.read(bookingViewModelProvider);
      if (state.hasMore && state.status != BookingUIStatus.loading) {
        ref.read(bookingViewModelProvider.notifier).getUserBookings();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.book_online,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'My Bookings',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        // Booking count badge
                        if (bookingState.bookings.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${bookingState.bookings.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withOpacity(0.6),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(bookingViewModelProvider.notifier)
                    .getUserBookings(refresh: true);
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(bookingState, null),
                  _buildBookingsList(bookingState, BookingStatus.confirmed),
                  _buildBookingsList(bookingState, BookingStatus.completed),
                  _buildBookingsList(bookingState, BookingStatus.cancelled),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(BookingState state, BookingStatus? filterStatus) {
    // Filter bookings
    final filteredBookings = filterStatus == null
        ? state.bookings
        : state.bookings.where((b) => b.status == filterStatus).toList();

    // Loading state
    if (state.status == BookingUIStatus.loading && state.bookings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Empty state
    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyIcon(filterStatus),
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              _getEmptyMessage(filterStatus),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring packages!',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    // Bookings list
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount:
          filteredBookings.length +
          (state.status == BookingUIStatus.loading ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == filteredBookings.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final booking = filteredBookings[index];
        return BookingCard(booking: booking);
      },
    );
  }

  IconData _getEmptyIcon(BookingStatus? status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Icons.pending_actions;
      case BookingStatus.completed:
        return Icons.check_circle_outline;
      case BookingStatus.cancelled:
        return Icons.cancel_outlined;
      default:
        return Icons.inbox_outlined;
    }
  }

  String _getEmptyMessage(BookingStatus? status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'No upcoming bookings';
      case BookingStatus.completed:
        return 'No completed bookings';
      case BookingStatus.cancelled:
        return 'No cancelled bookings';
      default:
        return 'No bookings yet';
    }
  }
}
