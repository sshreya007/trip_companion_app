import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/booking/domain/entities/booking_entity.dart';
import 'package:trip_planner/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:trip_planner/features/booking/presentation/state/booking_state.dart';
import 'package:trip_planner/features/package/domain/entities/package_entity.dart';

class BookingFormPage extends ConsumerStatefulWidget {
  final PackageEntity package;

  const BookingFormPage({super.key, required this.package});

  @override
  ConsumerState<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends ConsumerState<BookingFormPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form data
  final List<TravelerData> _travelers = [];
  DateTime? _travelDate;
  int _adults = 1;
  int _children = 0;

  // Emergency Contact
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationController = TextEditingController();

  // Special Requests
  final _specialRequestsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add first traveler by default
    _travelers.add(TravelerData());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Book Your Trip'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),

          // Form Steps
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildStep1TravelersInfo(),
                _buildStep2EmergencyContact(),
                _buildStep3SpecialRequests(),
                _buildStep4Review(),
              ],
            ),
          ),

          // Navigation Buttons
          _buildNavigationButtons(bookingState),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                          ? Colors.teal
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 3) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  // STEP 1: Travelers Information
  Widget _buildStep1TravelersInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 1: Traveler Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add details for all travelers',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Number of Travelers
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Number of Travelers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildCounterWidget('Adults', _adults, (value) {
                        setState(() {
                          _adults = value;
                          _updateTravelersList();
                        });
                      }, min: 1),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCounterWidget('Children', _children, (
                        value,
                      ) {
                        setState(() {
                          _children = value;
                          _updateTravelersList();
                        });
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Travel Date
          const Text(
            'Travel Date',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _selectTravelDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.teal),
                  const SizedBox(width: 12),
                  Text(
                    _travelDate != null
                        ? '${_travelDate!.day}/${_travelDate!.month}/${_travelDate!.year}'
                        : 'Select travel date',
                    style: TextStyle(
                      fontSize: 16,
                      color: _travelDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Traveler Forms
          const Text(
            'Traveler Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...List.generate(_travelers.length, (index) {
            return _buildTravelerForm(index);
          }),
        ],
      ),
    );
  }

  Widget _buildCounterWidget(
    String label,
    int value,
    Function(int) onChanged, {
    int min = 0,
    int max = 10,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.teal,
            ),
            Text(
              '$value',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
              color: Colors.teal,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTravelerForm(int index) {
    final traveler = _travelers[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Traveler ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: traveler.firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: traveler.lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: traveler.ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: traveler.gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      traveler.gender = value ?? 'Male';
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: traveler.emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),

          TextField(
            controller: traveler.phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),

          TextField(
            controller: traveler.passportController,
            decoration: const InputDecoration(
              labelText: 'Passport Number (Optional)',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 2: Emergency Contact
  Widget _buildStep2EmergencyContact() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 2: Emergency Contact',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Provide emergency contact details',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.emergency, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This person will be contacted in case of emergency',
                    style: TextStyle(fontSize: 14, color: Colors.red[900]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _emergencyNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _emergencyPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _emergencyRelationController,
            decoration: const InputDecoration(
              labelText: 'Relationship',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.people),
              hintText: 'e.g., Spouse, Parent, Friend',
            ),
          ),
        ],
      ),
    );
  }

  // STEP 3: Special Requests
  Widget _buildStep3SpecialRequests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 3: Special Requests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Any special requirements or requests?',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _specialRequestsController,
            decoration: const InputDecoration(
              labelText: 'Special Requests (Optional)',
              border: OutlineInputBorder(),
              hintText: 'Dietary restrictions, accessibility needs, etc.',
            ),
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  // STEP 4: Review
  Widget _buildStep4Review() {
    final basePrice = widget.package.price.amount;
    final totalPrice = basePrice * _adults + (basePrice * 0.5 * _children);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 4: Review & Confirm',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your booking details',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Package Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Package',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(widget.package.title),
                Text(
                  '${widget.package.destination}, ${widget.package.country}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Summary
          _buildSummaryItem(
            'Travel Date',
            _travelDate != null
                ? '${_travelDate!.day}/${_travelDate!.month}/${_travelDate!.year}'
                : 'Not selected',
          ),
          _buildSummaryItem(
            'Travelers',
            '$_adults Adults, $_children Children',
          ),
          _buildSummaryItem('Emergency Contact', _emergencyNameController.text),

          const SizedBox(height: 24),

          // Price Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Adults',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '$_adults × \$${basePrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                if (_children > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Children (50% off)',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '$_children × \$${(basePrice * 0.5).toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
                const Divider(color: Colors.white30, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BookingState bookingState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.teal),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: bookingState.status == BookingUIStatus.creating
                    ? null
                    : () => _handleNextOrConfirm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: bookingState.status == BookingUIStatus.creating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _currentStep == 3 ? 'Confirm Booking' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTravelersList() {
    final totalTravelers = _adults + _children;

    if (_travelers.length < totalTravelers) {
      while (_travelers.length < totalTravelers) {
        _travelers.add(TravelerData());
      }
    } else if (_travelers.length > totalTravelers) {
      _travelers.removeRange(totalTravelers, _travelers.length);
    }
  }

  Future<void> _selectTravelDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _travelDate = picked;
      });
    }
  }

  void _handleNextOrConfirm() async {
    if (_currentStep < 3) {
      // Validate current step
      if (_currentStep == 0 && !_validateStep1()) return;
      if (_currentStep == 1 && !_validateStep2()) return;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Final validation and submit
      if (!_validateAllSteps()) return;

      await _submitBooking();
    }
  }

  bool _validateStep1() {
    if (_travelDate == null) {
      _showError('Please select a travel date');
      return false;
    }

    for (var traveler in _travelers) {
      if (traveler.firstNameController.text.isEmpty ||
          traveler.lastNameController.text.isEmpty ||
          traveler.emailController.text.isEmpty ||
          traveler.phoneController.text.isEmpty ||
          traveler.ageController.text.isEmpty) {
        _showError('Please fill in all traveler details');
        return false;
      }
    }

    return true;
  }

  bool _validateStep2() {
    if (_emergencyNameController.text.isEmpty ||
        _emergencyPhoneController.text.isEmpty ||
        _emergencyRelationController.text.isEmpty) {
      _showError('Please fill in all emergency contact details');
      return false;
    }
    return true;
  }

  bool _validateAllSteps() {
    return _validateStep1() && _validateStep2();
  }

  Future<void> _submitBooking() async {
    final booking = CreateBookingEntity(
      packageId: widget.package.id,
      travelers: _travelers
          .map(
            (t) => TravelerEntity(
              firstName: t.firstNameController.text,
              lastName: t.lastNameController.text,
              age: int.parse(t.ageController.text),
              gender: t.gender,
              passportNumber: t.passportController.text.isEmpty
                  ? null
                  : t.passportController.text,
              email: t.emailController.text,
              phone: t.phoneController.text,
            ),
          )
          .toList(),
      travelDate: _travelDate!,
      numberOfTravelers: NumberOfTravelersEntity(
        adults: _adults,
        children: _children,
      ),
      emergencyContact: EmergencyContactEntity(
        name: _emergencyNameController.text,
        phone: _emergencyPhoneController.text,
        relation: _emergencyRelationController.text,
      ),
      specialRequests: _specialRequestsController.text.isEmpty
          ? null
          : _specialRequestsController.text,
    );

    final success = await ref
        .read(bookingViewModelProvider.notifier)
        .createBooking(booking);

    if (success && mounted) {
      await ref
          .read(bookingViewModelProvider.notifier)
          .getUserBookings(refresh: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context); // Go back to package detail
    } else if (mounted) {
      final error = ref.read(bookingViewModelProvider).errorMessage;
      _showError(error ?? 'Failed to create booking');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

// Helper class for traveler data
class TravelerData {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passportController = TextEditingController();
  String gender = 'Male';

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passportController.dispose();
  }
}
