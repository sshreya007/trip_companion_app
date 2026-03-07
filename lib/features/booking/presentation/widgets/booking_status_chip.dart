import 'package:flutter/material.dart';
import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';

class BookingStatusChip extends StatelessWidget {
  final BookingStatus status;

  const BookingStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(status), size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            _getLabel(status),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.green;
    }
  }

  IconData _getIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.pending;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.completed:
        return Icons.check_circle_outline;
    }
  }

  String _getLabel(BookingStatus status) {
    return status.name.toUpperCase();
  }
}
