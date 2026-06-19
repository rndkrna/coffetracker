import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_routes.dart';
import '../../../../core/app_config.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../location/providers/location_provider.dart';
import '../../../../features/recommendation/providers/recommendation_provider.dart';
import 'package:geolocator/geolocator.dart';

class CoffeeshopFinderScreen extends ConsumerStatefulWidget {
  const CoffeeshopFinderScreen({super.key});

  @override
  ConsumerState<CoffeeshopFinderScreen> createState() =>
      _CoffeeshopFinderScreenState();
}

class _CoffeeshopFinderScreenState
    extends ConsumerState<CoffeeshopFinderScreen> {
  bool _isMapView = false;
  String _searchQuery = '';
  bool _filterOpenNow = false;
  bool _filterDistance = false;
  bool _filterPrice = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).fetchLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Cari Kedai',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list_rounded : Icons.map_rounded,
                color: AppColors.primary),
            onPressed: () => setState(() => _isMapView = !_isMapView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Badge & Search
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 16, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locationState.isLoading
                            ? 'Mencari lokasi...'
                            : locationState.error != null
                                ? 'Gagal: ${locationState.error}'
                                : locationState.location.address,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!locationState.isLoading)
                      GestureDetector(
                        onTap: () =>
                            ref.read(locationProvider.notifier).fetchLocation(),
                        child: Icon(Icons.refresh_rounded,
                            size: 16, color: AppColors.primary),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                CoffeeSearchBar(
                  hint: 'Cari nama kedai atau area...',
                  onChanged: (v) {
                    setState(() {
                      _searchQuery = v;
                    });
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Buka Sekarang',
                          Icons.access_time_rounded, _filterOpenNow, () {
                        setState(() => _filterOpenNow = !_filterOpenNow);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Jarak: < 3km',
                          Icons.directions_walk_rounded, _filterDistance, () {
                        setState(() => _filterDistance = !_filterDistance);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Harga: < Rp 50k',
                          Icons.attach_money_rounded, _filterPrice, () {
                        setState(() => _filterPrice = !_filterPrice);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGeminiSyncDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
        label: Text(
          'Generate via AI',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 14, color: isSelected ? Colors.white : AppColors.primary),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isSelected ? Colors.white : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    final recommendationState = ref.watch(recommendationProvider);

    if (recommendationState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var items = recommendationState.allShops.toList();

    // Apply Search Query
    if (_searchQuery.isNotEmpty) {
      items = items.where((shop) {
        return shop.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            shop.address.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply Filters
    if (_filterPrice) {
      items =
          items.where((shop) => shop.menu.any((m) => m.price < 50000)).toList();
    }

    final locState = ref.read(locationProvider);
    final userLat =
        locState.location.latitude != 0.0 ? locState.location.latitude : null;
    final userLng =
        locState.location.longitude != 0.0 ? locState.location.longitude : null;

    if (_filterDistance && userLat != null && userLng != null) {
      items = items.where((shop) {
        if (shop.latitude == null || shop.longitude == null) return false;
        final dist = Geolocator.distanceBetween(
            userLat, userLng, shop.latitude!, shop.longitude!);
        return dist <= 3000;
      }).toList();
    }

    if (userLat != null && userLng != null) {
      items.sort((a, b) {
        if (a.latitude == null || a.longitude == null) return 1;
        if (b.latitude == null || b.longitude == null) return -1;
        final distA = Geolocator.distanceBetween(
            userLat, userLng, a.latitude!, a.longitude!);
        final distB = Geolocator.distanceBetween(
            userLat, userLng, b.latitude!, b.longitude!);
        return distA.compareTo(distB);
      });
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data kedai.\nKlik tombol AI di bawah untuk mencari di kota kamu.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        // Calculate min and max price from menu
        int minPrice = item.menu.isEmpty
            ? 0
            : item.menu.map((e) => e.price).reduce((a, b) => a < b ? a : b);
        int maxPrice = item.menu.isEmpty
            ? 0
            : item.menu.map((e) => e.price).reduce((a, b) => a > b ? a : b);

        int distMeters = 1500; // Placeholder
        if (userLat != null &&
            userLng != null &&
            item.latitude != null &&
            item.longitude != null) {
          distMeters = Geolocator.distanceBetween(
                  userLat, userLng, item.latitude!, item.longitude!)
              .toInt();
        }

        return CoffeeshopCard(
          name: item.name,
          rating: item.rating,
          distanceMeters: distMeters,
          priceRangeMin: minPrice,
          priceRangeMax: maxPrice,
          isOpen: true, // Placeholder
          moodTags: item.vibes,
          facilities: const ['WiFi', 'Stopkontak'], // Placeholder
          onTap: () {
            context.push('${AppRoutes.coffeeshopDetail}/${item.id}');
          },
        );
      },
    );
  }

  void _showGeminiSyncDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Cari Kedai Nyata + AI',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Masukkan nama kota atau area. Aplikasi akan mencari kedai nyata dari MapTiler, lalu AI hanya melengkapi menu dan vibes.',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nama Kota',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(recommendationProvider.notifier)
                    .trainDataWithHybrid(controller.text.trim())
                    .then((_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Data kedai nyata berhasil diperkaya AI!',
                      ),
                    ),
                  );
                }).catchError((e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal: $e')),
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    if (AppConfig.googleMapsApiKey.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_rounded,
                  size: 64, color: AppColors.textSecondary.withAlpha(80)),
              const SizedBox(height: 16),
              Text(
                'Google Maps API key belum diatur',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Build ulang aplikasi dengan --dart-define="GOOGLE_MAPS_API_KEY=..." untuk menampilkan peta.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final recommendationState = ref.watch(recommendationProvider);
    final locationState = ref.watch(locationProvider);
    final shops = recommendationState.allShops
        .where((shop) => shop.latitude != null && shop.longitude != null)
        .toList();

    final userLat = locationState.location.latitude != 0.0
        ? locationState.location.latitude
        : null;
    final userLng = locationState.location.longitude != 0.0
        ? locationState.location.longitude
        : null;

    final initialTarget = userLat != null && userLng != null
        ? LatLng(userLat, userLng)
        : shops.isNotEmpty
            ? LatLng(shops.first.latitude!, shops.first.longitude!)
            : const LatLng(-2.5489, 118.0149); // Indonesia

    final markers = <Marker>{
      if (userLat != null && userLng != null)
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(userLat, userLng),
          infoWindow: const InfoWindow(title: 'Lokasi kamu'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      ...shops.map(
        (shop) => Marker(
          markerId: MarkerId(shop.id),
          position: LatLng(shop.latitude!, shop.longitude!),
          infoWindow: InfoWindow(
            title: shop.name,
            snippet: shop.address,
            onTap: () =>
                context.push('${AppRoutes.coffeeshopDetail}/${shop.id}'),
          ),
        ),
      ),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialTarget,
          zoom: userLat != null && userLng != null ? 14 : 11,
        ),
        markers: markers,
        myLocationEnabled: userLat != null && userLng != null,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        mapToolbarEnabled: true,
      ),
    );
  }
}
