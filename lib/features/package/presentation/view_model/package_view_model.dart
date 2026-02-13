import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:trip_planner/features/package/domain/entities/package_entity.dart';
import 'package:trip_planner/features/package/domain/usecases/get_all_packages_usecase.dart';
import 'package:trip_planner/features/package/domain/usecases/get_package_by_id_usecase.dart';
import 'package:trip_planner/features/package/domain/usecases/get_featured_packages_usecase.dart';
import 'package:trip_planner/features/package/domain/usecases/get_packages_by_category_usecase.dart';
import 'package:trip_planner/features/package/presentation/state/package_state.dart';
import 'package:trip_planner/features/package/data/datasources/remote/package_remote_datasource.dart';
import 'package:trip_planner/features/package/data/repositories/package_repository_impl.dart';

// Providers
final packageRemoteDatasourceProvider = Provider<PackageRemoteDatasource>((
  ref,
) {
  final dioClient = ref.read(dioClientProvider);
  return PackageRemoteDatasource(dioClient);
});

final packageRepositoryProvider = Provider((ref) {
  final remoteDatasource = ref.read(packageRemoteDatasourceProvider);
  return PackageRepositoryImpl(remoteDatasource);
});

final getAllPackagesUsecaseProvider = Provider((ref) {
  final repository = ref.read(packageRepositoryProvider);
  return GetAllPackagesUsecase(repository);
});

final getPackageByIdUsecaseProvider = Provider((ref) {
  final repository = ref.read(packageRepositoryProvider);
  return GetPackageByIdUsecase(repository);
});

final getFeaturedPackagesUsecaseProvider = Provider((ref) {
  final repository = ref.read(packageRepositoryProvider);
  return GetFeaturedPackagesUsecase(repository);
});

final getPackagesByCategoryUsecaseProvider = Provider((ref) {
  final repository = ref.read(packageRepositoryProvider);
  return GetPackagesByCategoryUsecase(repository);
});

final packageViewModelProvider =
    NotifierProvider<PackageViewModel, PackageState>(PackageViewModel.new);

class PackageViewModel extends Notifier<PackageState> {
  late final GetAllPackagesUsecase _getAllPackagesUsecase;
  late final GetPackageByIdUsecase _getPackageByIdUsecase;
  late final GetFeaturedPackagesUsecase _getFeaturedPackagesUsecase;
  late final GetPackagesByCategoryUsecase _getPackagesByCategoryUsecase;

  @override
  PackageState build() {
    _getAllPackagesUsecase = ref.read(getAllPackagesUsecaseProvider);
    _getPackageByIdUsecase = ref.read(getPackageByIdUsecaseProvider);
    _getFeaturedPackagesUsecase = ref.read(getFeaturedPackagesUsecaseProvider);
    _getPackagesByCategoryUsecase = ref.read(
      getPackagesByCategoryUsecaseProvider,
    );

    return const PackageState();
  }

  /// Get all packages with filters
  Future<void> getAllPackages({
    String? category,
    double? minPrice,
    double? maxPrice,
    int? minDays,
    int? maxDays,
    String? destination,
    String? search,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
    bool refresh = false,
  }) async {
    print('🎯 VIEWMODEL: Getting all packages');

    if (refresh) {
      state = state.copyWith(
        status: PackageStatus.loading,
        currentPage: 1,
        packages: [],
      );
    } else if (state.status == PackageStatus.loading) {
      return; // Already loading
    } else {
      state = state.copyWith(status: PackageStatus.loadingMore);
    }

    final filters = PackageFilterEntity(
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minDays: minDays,
      maxDays: maxDays,
      destination: destination,
      search: search,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: refresh ? 1 : state.currentPage,
      limit: 10,
    );

    final result = await _getAllPackagesUsecase(filters);

    result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to get packages - ${failure.message}');
        state = state.copyWith(
          status: PackageStatus.error,
          errorMessage: failure.message,
        );
      },
      (packages) {
        print('✅ VIEWMODEL: ${packages.length} packages loaded');

        final allPackages = refresh
            ? packages
            : [...state.packages, ...packages];

        state = state.copyWith(
          status: PackageStatus.loaded,
          packages: allPackages,
          hasMore: packages.length >= 10,
          currentPage: state.currentPage + 1,
        );
      },
    );
  }

  /// Get package by ID
  Future<void> getPackageById(String id) async {
    print('🎯 VIEWMODEL: Getting package by ID: $id');

    state = state.copyWith(status: PackageStatus.loading);

    final result = await _getPackageByIdUsecase(id);

    result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to get package - ${failure.message}');
        state = state.copyWith(
          status: PackageStatus.error,
          errorMessage: failure.message,
        );
      },
      (package) {
        print('✅ VIEWMODEL: Package loaded - ${package.title}');
        state = state.copyWith(
          status: PackageStatus.loaded,
          selectedPackage: package,
        );
      },
    );
  }

  /// Get featured packages
  Future<void> getFeaturedPackages({int limit = 6}) async {
    print('🎯 VIEWMODEL: Getting featured packages');

    final result = await _getFeaturedPackagesUsecase(limit: limit);

    result.fold(
      (failure) {
        print(
          '❌ VIEWMODEL: Failed to get featured packages - ${failure.message}',
        );
      },
      (packages) {
        print('✅ VIEWMODEL: ${packages.length} featured packages loaded');
        state = state.copyWith(featuredPackages: packages);
      },
    );
  }

  /// Get packages by category
  Future<void> getPackagesByCategory(String category, {int limit = 10}) async {
    print('🎯 VIEWMODEL: Getting packages by category: $category');

    state = state.copyWith(status: PackageStatus.loading);

    final result = await _getPackagesByCategoryUsecase(category, limit: limit);

    result.fold(
      (failure) {
        print(
          '❌ VIEWMODEL: Failed to get category packages - ${failure.message}',
        );
        state = state.copyWith(
          status: PackageStatus.error,
          errorMessage: failure.message,
        );
      },
      (packages) {
        print('✅ VIEWMODEL: ${packages.length} packages loaded');
        state = state.copyWith(
          status: PackageStatus.loaded,
          packages: packages,
        );
      },
    );
  }

  /// Clear selected package
  void clearSelectedPackage() {
    state = state.copyWith(
      selectedPackage: null,
      status: PackageStatus.initial,
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
