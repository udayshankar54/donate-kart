import 'package:flutter/material.dart';

// Locally defined AppColors to match your project's color palette
class AppColors {
  static const emerald = Color(0xFF0F5969);
  static const emeraldDark = Color(0xFF047857);
  static const emeraldLight = Color(0xFF10B981);
  static const emeraldSoft = Color(0xFFFD1FAE5);
}

class LocationHeader extends StatefulWidget {
  final VoidCallback? onTap;

  const LocationHeader({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {
  // Default/current location state
  String _currentLocation = "Patti Bagheru, Haryana";
  String _subLocality = "Patti Bagheru";

  // Simulate picking a new location
  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Search Input Field
              TextField(
                decoration: InputDecoration(
                  hintText: "Search city, area or landmark...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 20),
              // Use Current Location Option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.my_location, color: AppColors.emerald),
                ),
                title: const Text(
                  "Use Current Location",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text("Patti Bagheru, Haryana, India"),
                onTap: () {
                  setState(() {
                    _currentLocation = "Patti Bagheru, Haryana";
                    _subLocality = "Patti Bagheru";
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              // Popular Locations / Quick Select List
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  "POPULAR CITIES",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildPopularLocationTile("New Delhi", "Delhi, India"),
                    _buildPopularLocationTile("Gurugram", "Haryana, India"),
                    _buildPopularLocationTile("Mumbai", "Maharashtra, India"),
                    _buildPopularLocationTile("Bengaluru", "Karnataka, India"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularLocationTile(String city, String fullAddress) {
    return ListTile(
      leading: const Icon(Icons.location_city, color: Colors.grey),
      title: Text(city),
      subtitle: Text(fullAddress),
      onTap: () {
        setState(() {
          _currentLocation = fullAddress;
          _subLocality = city;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? _showLocationPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Location Indicator Icon
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.emerald.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.emerald,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            // Text Details
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _subLocality,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ),
                Text(
                  _currentLocation,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}