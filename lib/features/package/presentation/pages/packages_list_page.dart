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
      body: RefreshIndicator(
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
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Beautiful App Bar with Gradient
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: Colors.teal,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.teal.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Discover Your\nNext Adventure',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
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
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: PackageCategoryChips(
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
            ),

            // Featured Section - ✅ FIXED: Correct class name
            if (packageState.featuredPackages.isNotEmpty)
              const SliverToBoxAdapter(
                child:
                    FeaturedPackagesSection(), // ✅ Changed from FeaturedPackageCard
              ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
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
            ),

            // Loading State
            if (packageState.status == PackageStatus.loading &&
                packageState.packages.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            // Empty State
            else if (packageState.packages.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              )
            // Packages Grid
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final package = packageState.packages[index];
                    return PackageCard(package: package);
                  }, childCount: packageState.packages.length),
                ),
              ),

            // Loading More Indicator
            if (packageState.status == PackageStatus.loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

            // Bottom Spacing
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
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
