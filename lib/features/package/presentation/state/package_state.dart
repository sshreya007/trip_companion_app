import 'package:equatable/equatable.dart';
import 'package:trip_planner/features/package/domain/entities/package_entity.dart';

enum PackageStatus { initial, loading, loaded, loadingMore, error }

class PackageState extends Equatable {
  final PackageStatus status;
  final List<PackageEntity> packages;
  final PackageEntity? selectedPackage;
  final List<PackageEntity> featuredPackages;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;

  const PackageState({
    this.status = PackageStatus.initial,
    this.packages = const [],
    this.selectedPackage,
    this.featuredPackages = const [],
    this.errorMessage,
    this.hasMore = true,
    this.currentPage = 1,
  });

  PackageState copyWith({
    PackageStatus? status,
    List<PackageEntity>? packages,
    PackageEntity? selectedPackage,
    List<PackageEntity>? featuredPackages,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
  }) {
    return PackageState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      featuredPackages: featuredPackages ?? this.featuredPackages,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    packages,
    selectedPackage,
    featuredPackages,
    errorMessage,
    hasMore,
    currentPage,
  ];
}
