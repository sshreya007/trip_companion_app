import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/package/presentation/view_model/package_view_model.dart';
import 'package:trip_planner/features/package/presentation/state/package_state.dart';
import 'package:trip_planner/features/package/presentation/widgets/package_card.dart';
import 'package:trip_planner/features/package/presentation/widgets/package_category_chips.dart';
import 'package:trip_planner/features/package/presentation/widgets/featured_packages_section.dart';

class PackagesListPage extends ConsumerStatefulWidget {
  const PackagesListPage({super.key});

  @override
  ConsumerState<PackagesListPage> createState() => _PackagesListPageState();
}

class _PackagesListPageState extends ConsumerState<PackagesListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(packageViewModelProvider.notifier).getAllPackages(refresh: true);
      ref.read(packageViewModelProvider.notifier).getFeaturedPackages();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = ref.read(packageViewModelProvider);
      if (state.hasMore && state.status != PackageStatus.loadingMore) {
        ref
            .read(packageViewModelProvider.notifier)
            .getAllPackages(
              category: _selectedCategory,
              search: _searchController.text.isEmpty
                  ? null
                  : _searchController.text,
            );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final packageState = ref.watch(packageViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header Section
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Title
                    const Text(
                      'Discover Your\nNext Adventure',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search destinations...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.teal,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                    _onSearch();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                        onSubmitted: (_) => _onSearch(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category Chips
          PackageCategoryChips(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category == _selectedCategory
                    ? null
                    : category;
              });
              _onCategoryChanged();
            },
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(packageViewModelProvider.notifier)
                    .getAllPackages(
                      category: _selectedCategory,
                      search: _searchController.text.isEmpty
                          ? null
                          : _searchController.text,
                      refresh: true,
                    );
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Featured Section
                    if (packageState.featuredPackages.isNotEmpty)
                      const FeaturedPackagesSection(),

                    // Section Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCategory != null
                                ? '${_selectedCategory!.toUpperCase()} Packages'
                                : 'All Packages',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (packageState.packages.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${packageState.packages.length} found',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Loading State
                    if (packageState.status == PackageStatus.loading &&
                        packageState.packages.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      )
                    // Empty State
                    else if (packageState.packages.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.explore_off,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No packages found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    // Packages Grid
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.68,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                          itemCount: packageState.packages.length,
                          itemBuilder: (context, index) {
                            final package = packageState.packages[index];
                            return PackageCard(package: package);
                          },
                        ),
                      ),

                    // Loading More Indicator
                    if (packageState.status == PackageStatus.loadingMore)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),

                    // Bottom Spacing
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSearch() {
    ref
        .read(packageViewModelProvider.notifier)
        .getAllPackages(
          search: _searchController.text.isEmpty
              ? null
              : _searchController.text,
          category: _selectedCategory,
          refresh: true,
        );
  }

  void _onCategoryChanged() {
    ref
        .read(packageViewModelProvider.notifier)
        .getAllPackages(
          category: _selectedCategory,
          search: _searchController.text.isEmpty
              ? null
              : _searchController.text,
          refresh: true,
        );
  }
}
