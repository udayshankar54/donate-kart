import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'screens/enhanced_auth_screen.dart';
import 'package:donate_kart/main.dart';
import 'screens/payment_method_screen.dart';
import 'screens/location_header.dart';
import 'services/payment_service.dart';
import 'firebase_options.dart';

void main() async {
  // 2. Tell Flutter to finish initializing its internal components first
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Initialize Firebase using the automatic configuration options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(
    const DonateKartApp(),
  ); // <-- 4. Replace 'MyApp()' with your actual main widget name if it's different
}

class AppColors {
  // Primary Colors
  static const emerald = Color(0xFF059669);
  static const emeraldDark = Color(0xFF047857);
  static const emeraldLight = Color(0xFF10B981);
  static const emeraldSoft = Color(0xFFD1FAE5);

  // Neutral Colors
  static const slate = Color(0xFF0F172A);
  static const slateDark = Color(0xFF020617);
  static const slateLight = Color(0xFF64748B);
  static const surface = Color(0xFFF8FAFC);
  static const surfaceLight = Color(0xFFF1F5F9);

  // Accent Colors
  static const rose = Color(0xFFE11D48);
  static const roseSoft = Color(0xFFFFE4E8);
  static const orange = Color(0xFFEA580C);
  static const orangeSoft = Color(0xFFFFF7ED);
  static const blue = Color(0xFF2563EB);
  static const blueSoft = Color(0xFFEFF6FF);
  static const purple = Color(0xFF9333EA);
  static const purpleSoft = Color(0xFFF3E8FF);
  static const amber = Color(0xFFFB923C);
  static const amberSoft = Color(0xFFFEF3C7);
  static const teal = Color(0xFF14B8A6);
  static const tealSoft = Color(0xFFCCFBF1);

  // Status Colors
  static const success = Color(0xFF059669);
  static const warning = Color(0xFFA16207);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF2563EB);
}

class DonateKartApp extends StatelessWidget {
  const DonateKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DonateKart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.emerald,
          primary: AppColors.emerald,
          secondary: AppColors.teal,
          tertiary: AppColors.orange,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.surfaceLight,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emerald,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.emerald.withValues(alpha: 0.5),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainAppRouter(),
    );
  }
}

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String role;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });
}

class DonationKit {
  final String id;
  final String title;
  final int price;
  final String description;
  final String category;
  final String image;

  const DonationKit({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });
}

class NgoPartner {
  final String id;
  final String name;
  final String cause;
  final double rating;
  final String image;

  const NgoPartner({
    required this.id,
    required this.name,
    required this.cause,
    required this.rating,
    required this.image,
  });
}

class PickupRequest {
  final String id;
  final String donorName;
  final String itemType;
  final String quantity;
  final String address;
  final String date;
  final String phone;
  String status;

  PickupRequest({
    required this.id,
    required this.donorName,
    required this.itemType,
    required this.quantity,
    required this.address,
    required this.date,
    required this.phone,
    required this.status,
  });
}

class VolunteerEntry {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String skills;
  String status;

  VolunteerEntry({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.skills,
    required this.status,
  });
}

class Testimonial {
  final String id;
  final String name;
  final String message;
  final double rating;
  final String image;
  final String role;

  const Testimonial({
    required this.id,
    required this.name,
    required this.message,
    required this.rating,
    required this.image,
    required this.role,
  });
}

class ImpactStory {
  final String id;
  final String title;
  final String description;
  final String image;
  final String impact;
  final String date;
  final String category;

  const ImpactStory({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.impact,
    required this.date,
    required this.category,
  });
}

class DonationHistory {
  final String id;
  final String kitName;
  final int amount;
  final String date;
  final String ngoName;
  final String status;

  DonationHistory({
    required this.id,
    required this.kitName,
    required this.amount,
    required this.date,
    required this.ngoName,
    required this.status,
  });
}

extension NumberFormatting on int {
  String toLocaleString() {
    final source = toString();
    if (source.length <= 3) return source;
    final lastThree = source.substring(source.length - 3);
    final head = source.substring(0, source.length - 3);
    final formattedHead = head.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return '$formattedHead,$lastThree';
  }
}

class MainAppRouter extends StatefulWidget {
  const MainAppRouter({super.key});

  @override
  State<MainAppRouter> createState() => _MainAppRouterState();
}

class _MainAppRouterState extends State<MainAppRouter> {
  String _currentView = 'splash';
  UserProfile? _currentUser;
  final List<DonationKit> _cart = [];
  final PaymentService _paymentService = PaymentService();

  final List<DonationKit> _donationKits = [
    const DonationKit(
      id: '101',
      title: 'Family Food Relief Kit',
      price: 2000,
      description: 'Provides basic groceries for a family of 4 for a week.',
      category: 'Food',
      image:
          'https://images.unsplash.com/photo-1593113565694-c708fa0d42b5?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '102',
      title: 'Child Education Kit',
      price: 1200,
      description: 'Notebooks, pens, and basic stationery for one child.',
      category: 'Education',
      image:
          'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '103',
      title: 'Winter Blanket',
      price: 800,
      description: 'Warm, durable blanket for the homeless during winter.',
      category: 'Relief',
      image:
          'https://images.unsplash.com/photo-1581451551694-28b3f11d9d95?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '104',
      title: 'Hygiene Essentials Kit',
      price: 500,
      description: 'Soap, toothpaste, sanitary pads, and sanitizers.',
      category: 'Health',
      image:
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '105',
      title: 'Medical Emergency Kit',
      price: 1500,
      description: 'First aid supplies, bandages, and essential medicines.',
      category: 'Medical',
      image:
          'https://images.unsplash.com/photo-1587854692152-cbe660dbde0f?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '106',
      title: 'Shelter Bedding Kit',
      price: 2500,
      description: 'Mattress, pillows, and bedsheets for homeless shelter.',
      category: 'Shelter',
      image:
          'https://images.unsplash.com/photo-1515182629504-727d7753751f?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '107',
      title: 'Clean Water Supply Kit',
      price: 3000,
      description: 'Water purification system for a village (100 people).',
      category: 'Water',
      image:
          'https://images.unsplash.com/photo-1584368694282-757b62b2f573?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '108',
      title: 'Skill Training Kit',
      price: 1800,
      description: 'Tools and materials for vocational skill training.',
      category: 'Skills',
      image:
          'https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '109',
      title: 'Agricultural Tools Kit',
      price: 4000,
      description: 'Basic farming tools for rural farmers.',
      category: 'Agriculture',
      image:
          'https://images.unsplash.com/photo-1574943320219-553eb213f72d?auto=format&fit=crop&w=400&q=80',
    ),
    const DonationKit(
      id: '110',
      title: 'Technology Access Kit',
      price: 5000,
      description: 'Tablets and learning apps for underprivileged students.',
      category: 'Technology',
      image:
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  final List<NgoPartner> _ngos = [
    const NgoPartner(
      id: '1',
      name: 'Care India',
      cause: 'Child Education',
      rating: 4.8,
      image:
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    ),
    const NgoPartner(
      id: '2',
      name: 'Green Earth',
      cause: 'Environment',
      rating: 4.9,
      image:
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    ),
    const NgoPartner(
      id: '3',
      name: 'Food for All',
      cause: 'Hunger Relief',
      rating: 4.7,
      image:
          'https://images.unsplash.com/photo-1593113565694-c708fa0d42b5?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    ),
    const NgoPartner(
      id: '4',
      name: 'Health for All',
      cause: 'Medical Aid',
      rating: 4.6,
      image:
          'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    ),
    const NgoPartner(
      id: '5',
      name: 'Safe Shelter',
      cause: 'Housing & Welfare',
      rating: 4.8,
      image:
          'https://images.unsplash.com/photo-1564629238241-c6a6e4e6bb3b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    ),
    const NgoPartner(
      id: '6',
      name: 'Water Initiative',
      cause: 'Clean Water Access',
      rating: 4.9,
      image:
          'https://images.unsplash.com/photo-1559027615-cd2628902d4a?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    ),
    const NgoPartner(
      id: '7',
      name: 'Skill Development',
      cause: 'Vocational Training',
      rating: 4.5,
      image:
          'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    ),
    const NgoPartner(
      id: '8',
      name: 'Women Empowerment',
      cause: 'Gender Equality',
      rating: 4.7,
      image:
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    ),
  ];

  final List<PickupRequest> _pickups = [
    PickupRequest(
      id: 'p1',
      donorName: 'Rohan Sharma',
      itemType: 'Clothes',
      quantity: '3 boxes',
      address: 'Sector 15, Gurugram, HR',
      date: '2026-05-20',
      phone: '+91 9876543210',
      status: 'Pending',
    ),
    PickupRequest(
      id: 'p2',
      donorName: 'Aditi Rao',
      itemType: 'Books & Stationery',
      quantity: '1 carton',
      address: 'HSR Layout, Bengaluru, KA',
      date: '2026-05-22',
      phone: '+91 9988776655',
      status: 'Out for Pickup',
    ),
  ];

  final List<VolunteerEntry> _volunteers = [
    VolunteerEntry(
      id: 'v1',
      name: 'Amit Patel',
      email: 'amit.p@example.com',
      phone: '+91 9123456789',
      city: 'Mumbai',
      skills: 'Have a motorcycle for logistics help.',
      status: 'Verified',
    ),
    VolunteerEntry(
      id: 'v2',
      name: 'Priya Nair',
      email: 'priya@example.com',
      phone: '+91 8887776665',
      city: 'Pune',
      skills: 'Community outreach and crowd management.',
      status: 'Pending',
    ),
  ];

  int _totalDonationsCollected = 128400;
  final List<DonationHistory> _donationHistory = [];

  final List<Testimonial> _testimonials = [
    const Testimonial(
      id: 't1',
      name: 'Rajesh Kumar',
      message:
          'DonateKart made it easy to help. I got the medical kit delivered within 2 days!',
      rating: 5.0,
      image:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      role: 'NGO Partner',
    ),
    const Testimonial(
      id: 't2',
      name: 'Priya Singh',
      message:
          'Transparent, reliable, and truly impactful. I\'ve donated 5 times already!',
      rating: 4.8,
      image:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
      role: 'Donor',
    ),
    const Testimonial(
      id: 't3',
      name: 'Amit Patel',
      message:
          'Volunteering with DonateKart is incredibly rewarding. Great platform!',
      rating: 5.0,
      image:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      role: 'Volunteer',
    ),
    const Testimonial(
      id: 't4',
      name: 'Neha Gupta',
      message: 'The water kit we received helped 500+ families in our village!',
      rating: 5.0,
      image:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      role: 'Beneficiary',
    ),
  ];

  final List<ImpactStory> _impactStories = [
    const ImpactStory(
      id: 'is1',
      title: 'Education transforms lives in rural Maharashtra',
      description:
          'Our education kits have helped 1,200+ children access quality learning materials.',
      image:
          'https://images.unsplash.com/photo-1427504494785-cddfb5b27c0a?auto=format&fit=crop&w=600&q=80',
      impact: '1,200+ Children Impacted',
      date: '2026-05-15',
      category: 'Education',
    ),
    const ImpactStory(
      id: 'is2',
      title: 'Clean water initiative reaches remote villages',
      description:
          'Water purification systems installed in 15 villages, serving 5,000+ people.',
      image:
          'https://images.unsplash.com/photo-1559027615-cd2628902d4a?auto=format&fit=crop&w=600&q=80',
      impact: '5,000+ People',
      date: '2026-05-10',
      category: 'Water',
    ),
    const ImpactStory(
      id: 'is3',
      title: 'Medical aid saves lives in underserved areas',
      description:
          'Emergency medical kits distributed to 50 health centers, reaching thousands.',
      image:
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=600&q=80',
      impact: '10,000+ Lives',
      date: '2026-05-05',
      category: 'Medical',
    ),
    const ImpactStory(
      id: 'is4',
      title: 'Winter relief brings warmth to homeless',
      description:
          '2,500 blankets distributed in New Delhi providing warmth to vulnerable communities.',
      image:
          'https://images.unsplash.com/photo-1581451551694-28b3f11d9d95?auto=format&fit=crop&w=600&q=80',
      impact: '2,500+ People',
      date: '2026-04-30',
      category: 'Relief',
    ),
    const ImpactStory(
      id: 'is5',
      title: 'Skill training creates employment opportunities',
      description:
          '300+ individuals trained in vocational skills, 85% employed within 6 months.',
      image:
          'https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=600&q=80',
      impact: '300+ Trained',
      date: '2026-04-20',
      category: 'Skills',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _paymentService.initialize(
      onSuccess: (payment) => _completeCheckout(),
      onError: (error) => _showToast('Payment failed: $error'),
    );

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() => _currentView = 'home');
    });
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  void _startCheckout() {
    if (_currentUser == null) {
      _showToast('Please login to continue');
      _navigateTo('auth');
      return;
    }

    if (_cart.isEmpty) {
      _showToast('Please add items to your cart');
      return;
    }

    final total = _cart.fold(0.0, (sum, item) => sum + item.price);

    if (total <= 0) {
      _showToast('Invalid cart total. Please check your items.');
      return;
    }

    print('🛒 Starting checkout: Total=$total, Items=${_cart.length}');
    print('📧 Email: ${_currentUser!.email}');
    print('👤 UserID: ${_currentUser!.uid}');

    // Show payment method selection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          amount: total,
          userEmail: _currentUser!.email,
          userName: _currentUser!.name,
          onRazorpaySelected: () {
            _processRazorpayPayment(total);
          },
          onUPISelected: (upiId) {
            _processUPIPayment(total, upiId);
          },
        ),
      ),
    );
  }

  void _processRazorpayPayment(double amount) {
    _showToast('Processing payment of ₹$amount...');

    _paymentService.processPayment(
      paymentId: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      email: _currentUser!.email,
      phoneNumber: '9999999999',
      description: 'Donation for ${_cart.length} kits',
      metadata: {'userId': _currentUser!.uid, 'type': 'donation'},
    );
  }

  void _processUPIPayment(double amount, String upiId) {
    _showToast('Processing UPI payment of ₹$amount...');

    _paymentService.processUPIPayment(
      paymentId: 'PAY-UPI-${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      upiId: upiId,
      email: _currentUser!.email,
      metadata: {
        'userId': _currentUser!.uid,
        'type': 'donation',
        'method': 'upi',
      },
    );
  }

  void _completeCheckout() {
    setState(() {
      final checkoutTime = DateTime.now();
      final donationTotal = _cart.fold(0, (sum, item) => sum + item.price);
      _totalDonationsCollected += donationTotal;
      _donationHistory.insertAll(
        0,
        _cart.map(
          (item) => DonationHistory(
            id: 'dh_${item.id}_${checkoutTime.microsecondsSinceEpoch}',
            kitName: item.title,
            amount: item.price,
            date: checkoutTime.toIso8601String().split('T').first,
            ngoName: 'DonateKart NGO Network',
            status: 'Completed',
          ),
        ),
      );
      _cart.clear();
    });
    _showToast('Thank you for your generous contribution!');
    _navigateTo('home');
  }

  void _navigateTo(String view) {
    if (view == 'admin' &&
        (_currentUser == null || _currentUser!.role != 'admin')) {
      _showToast('Access Denied: Only Admins can enter!');
      setState(() => _currentView = 'auth');
      return;
    }
    setState(() => _currentView = view);
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _shouldShowChrome() ? _buildAppBar() : null,
      body: _buildCurrentView(),
      bottomNavigationBar: _shouldShowChrome() ? _buildBottomBar() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite, color: AppColors.rose, size: 28),
          const SizedBox(width: 8),
          const Text(
            'DonateKart',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.slate,
              fontSize: 22,
            ),
          ),
          const SizedBox(width: 16), // Space between the logo text and your picker
          
          // Your new location selector added in!
          const LocationHeader(),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      actions: [
        if (_currentUser != null) ...[
          PopupMenuButton(
            icon: const Icon(Icons.menu, color: AppColors.slate),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => _navigateTo('profile'),
                child: const Row(
                  children: [
                    Icon(Icons.person, color: AppColors.emerald),
                    SizedBox(width: 12),
                    Text('My Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => _navigateTo('history'),
                child: const Row(
                  children: [
                    Icon(Icons.history, color: AppColors.blue),
                    SizedBox(width: 12),
                    Text('Donation History'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => _navigateTo('stories'),
                child: const Row(
                  children: [
                    Icon(Icons.auto_stories, color: AppColors.purple),
                    SizedBox(width: 12),
                    Text('Impact Stories'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => _navigateTo('testimonials'),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: AppColors.amber),
                    SizedBox(width: 12),
                    Text('Testimonials'),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _currentUser!.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _currentUser!.role.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              setState(() => _currentUser = null);
              _showToast('Successfully signed out.');
              _navigateTo('auth');
            },
          ),
        ] else
          TextButton.icon(
            onPressed: () => _navigateTo('auth'),
            icon: const Icon(Icons.login),
            label: const Text('Login'),
          ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.emerald, AppColors.teal],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          height: 2,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      currentIndex: _getBottomBarIndex(),
      onTap: (index) {
        switch (index) {
          case 0:
            _navigateTo('home');
          case 1:
            _navigateTo('ngos');
          case 2:
            _navigateTo('donate');
          case 3:
            _navigateTo(_currentUser?.role == 'admin' ? 'admin' : 'pickup');
        }
      },
      selectedItemColor: AppColors.emerald,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedItemColor: AppColors.slateLight,
      backgroundColor: Colors.white,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'NGOs',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.favorite_outline),
              if (_cart.isNotEmpty)
                Positioned(
                  right: -6,
                  top: -3,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: AppColors.rose,
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          activeIcon: const Icon(Icons.favorite),
          label: 'Donate',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _currentUser?.role == 'admin'
                ? Icons.security
                : Icons.local_shipping_outlined,
          ),
          activeIcon: Icon(
            _currentUser?.role == 'admin'
                ? Icons.security
                : Icons.local_shipping,
          ),
          label: _currentUser?.role == 'admin' ? 'Admin' : 'Pickup',
        ),
      ],
    );
  }

  bool _shouldShowChrome() =>
      _currentView != 'splash' && _currentView != 'auth';

  int _getBottomBarIndex() {
    return switch (_currentView) {
      'ngos' => 1,
      'donate' => 2,
      'pickup' || 'admin' => 3,
      _ => 0,
    };
  }

  Widget _buildCurrentView() {
    return switch (_currentView) {
      'splash' => const SplashScreen(),
      'auth' => EnhancedAuthScreen(
        onSuccess: (userData) {
          setState(() {
            _currentUser = UserProfile(
              uid: userData['uid'],
              name: userData['name'],
              email: userData['email'],
              role: userData['role'],
            );
          });
          // Route them based on their role!
          _navigateTo(userData['role'] == 'admin' ? 'admin' : 'home');
        },
      ),
      'home' => HomeDashboard(
        totalCollected: _totalDonationsCollected,
        onNavigate: _navigateTo,
      ),
      'ngos' => NgoListingScreen(ngos: _ngos),
      'donate' => DonateKartScreen(
        kits: _donationKits,
        cart: _cart,
        onAddToCart: (kit) {
          setState(() => _cart.add(kit));
          _showToast('Added ${kit.title} to your Kart');
        },
        onCheckout: _startCheckout,
      ),
      'pickup' => PickupRequestScreen(
        currentUser: _currentUser,
        onSubmit: (request) {
          setState(() => _pickups.add(request));
          _showToast('Pickup scheduled successfully!');
          _navigateTo('home');
        },
      ),
      'volunteer' => VolunteerRegistrationScreen(
        onSubmit: (entry) {
          setState(() => _volunteers.add(entry));
          _showToast('Application submitted successfully!');
          _navigateTo('home');
        },
      ),
      'map' => const DonationCentersMapScreen(),
      'admin' => AdminDashboard(
        ngos: _ngos,
        kits: _donationKits,
        pickups: _pickups,
        volunteers: _volunteers,
        totalCollected: _totalDonationsCollected,
        onAddKit: (newKit) {
          setState(() => _donationKits.add(newKit));
          _showToast('Kit published successfully!');
        },
        onDeleteKit: (id) {
          setState(
            () => _donationKits.removeWhere((element) => element.id == id),
          );
          _showToast('Kit deleted.');
        },
        onAddNgo: (ngo) {
          setState(() => _ngos.add(ngo));
          _showToast('NGO partner added!');
        },
        onDeleteNgo: (id) {
          setState(() => _ngos.removeWhere((element) => element.id == id));
          _showToast('NGO removed.');
        },
        onUpdatePickup: (id, currentStatus) {
          setState(() {
            final index = _pickups.indexWhere((pickup) => pickup.id == id);
            if (index == -1) return;
            _pickups[index].status = currentStatus == 'Pending'
                ? 'Out for Pickup'
                : 'Completed';
          });
          _showToast('Pickup status updated.');
        },
        onVerifyVolunteer: (id) {
          setState(() {
            final index = _volunteers.indexWhere(
              (volunteer) => volunteer.id == id,
            );
            if (index == -1) return;
            _volunteers[index].status = _volunteers[index].status == 'Verified'
                ? 'Pending'
                : 'Verified';
          });
          _showToast('Volunteer verification toggled.');
        },
      ),
      'profile' => UserProfileScreen(user: _currentUser),
      'history' => DonationHistoryScreen(history: _donationHistory),
      'stories' => ImpactStoriesScreen(stories: _impactStories),
      'testimonials' => TestimonialScreen(testimonials: _testimonials),
      _ => const Center(child: Text('Route exception')),
    };
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.emerald,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'DonateKart',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Delivering Hope, Box by Box.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.emeraldSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  final ValueChanged<UserProfile> onSuccess;

  const AuthScreen({super.key, required this.onSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _showAdminKeyGate = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _adminKeyController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _adminKeyController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();

    if (email.toLowerCase() == 'admin@donatekart.com') {
      setState(() => _showAdminKeyGate = true);
      return;
    }

    widget.onSuccess(
      UserProfile(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name.isNotEmpty ? name : email.split('@').first,
        email: email,
        role: 'donor',
      ),
    );
  }

  void _verifyAdminKey() {
    final key = _adminKeyController.text.trim();
    if (key == 'DKADMIN999' || _passwordController.text == 'admin123') {
      widget.onSuccess(
        UserProfile(
          uid: 'admin_verified_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Admin Director',
          email: 'admin@donatekart.com',
          role: 'admin',
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Access Denied: Invalid Security Key'),
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.slate,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _showAdminKeyGate
                    ? _buildAdminGate()
                    : _buildLoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminGate() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock, color: Colors.amber, size: 48),
        const SizedBox(height: 16),
        const Text(
          'Secure Admin Verification',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'A security lock has been triggered. Please enter the master administrative secret access key.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _adminKeyController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Master Security Key (Demo: DKADMIN999)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _showAdminKeyGate = false),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rose,
                ),
                onPressed: _verifyAdminKey,
                child: const Text(
                  'Authorize',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.favorite, color: AppColors.emerald, size: 40),
        const SizedBox(height: 8),
        Text(
          _isLogin ? 'Welcome Back' : 'Create Account',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 24),
        if (!_isLogin) ...[
          _buildTextField(_nameController, 'Full Name'),
          const SizedBox(height: 16),
        ],
        _buildTextField(
          _emailController,
          'Email Address',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(_passwordController, 'Password', obscureText: true),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _submitForm,
            child: Text(
              _isLogin ? 'Sign In' : 'Sign Up',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'OR',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            _emailController.text = 'admin@donatekart.com';
            _passwordController.text = 'admin123';
            setState(() => _showAdminKeyGate = true);
          },
          icon: const Icon(Icons.shield, color: Colors.redAccent),
          label: const Text(
            'Quick Access Admin Console',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _isLogin = !_isLogin),
          child: Text(
            _isLogin
                ? "Don't have an account? Sign Up"
                : 'Already have an account? Sign In',
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  final int totalCollected;
  final ValueChanged<String> onNavigate;

  const HomeDashboard({
    super.key,
    required this.totalCollected,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [AppColors.emeraldDark, AppColors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.emerald.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Direct & Transparent\nDonations in Rupees.',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Donate essential kits directly to trusted NGO partners. 100% of your contributions buy raw materials delivered to beneficiaries.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.emeraldSoft,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.emerald,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => onNavigate('donate'),
                    child: const Text(
                      'Start Donating',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => onNavigate('pickup'),
                    icon: const Icon(Icons.local_shipping),
                    label: const Text('Book Pickup'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'How would you like to help?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _CategoryCard(
              icon: Icons.inventory,
              title: 'Browse Kits',
              backgroundColor: AppColors.blueSoft,
              iconColor: AppColors.blue,
              gradientColors: [
                AppColors.blue.withValues(alpha: 0.1),
                AppColors.blueSoft,
              ],
              onTap: () => onNavigate('donate'),
            ),
            _CategoryCard(
              icon: Icons.local_shipping,
              title: 'Donate Material',
              backgroundColor: AppColors.orangeSoft,
              iconColor: AppColors.orange,
              gradientColors: [
                AppColors.orange.withValues(alpha: 0.1),
                AppColors.orangeSoft,
              ],
              onTap: () => onNavigate('pickup'),
            ),
            _CategoryCard(
              icon: Icons.groups,
              title: 'Partner NGOs',
              backgroundColor: AppColors.purpleSoft,
              iconColor: AppColors.purple,
              gradientColors: [
                AppColors.purple.withValues(alpha: 0.1),
                AppColors.purpleSoft,
              ],
              onTap: () => onNavigate('ngos'),
            ),
            _CategoryCard(
              icon: Icons.person_add,
              title: 'Volunteer App',
              backgroundColor: AppColors.roseSoft,
              iconColor: AppColors.rose,
              gradientColors: [
                AppColors.rose.withValues(alpha: 0.1),
                AppColors.roseSoft,
              ],
              onTap: () => onNavigate('volunteer'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.emerald.withValues(alpha: 0.2),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.emerald.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                '✓ Verified Transparent Impact',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 32,
                runSpacing: 20,
                children: [
                  const _StatCol(count: '10,500+', label: 'Donors'),
                  const _StatCol(count: '54+', label: 'NGOs'),
                  _StatCol(
                    count: '₹${totalCollected.toLocaleString()}',
                    label: 'Direct Funds',
                  ),
                  const _StatCol(count: '21.8k+', label: 'Pickups'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final List<Color>? gradientColors;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.iconColor,
    this.gradientColors,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: () {
          _controller.forward().then((_) {
            _controller.reverse();
            widget.onTap();
          });
        },
        onHover: (isHovering) {
          if (isHovering) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: widget.iconColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.iconColor.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradientColors ?? [widget.backgroundColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final String count;
  final String label;

  const _StatCol({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.emerald.withValues(alpha: 0.1),
                AppColors.teal.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.emerald,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.slateLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class NgoListingScreen extends StatelessWidget {
  final List<NgoPartner> ngos;

  const NgoListingScreen({super.key, required this.ngos});

  @override
  Widget build(BuildContext context) {
    if (ngos.isEmpty) {
      return const Center(child: Text('No NGOs found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ngos.length,
      itemBuilder: (context, index) {
        final ngo = ngos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shadowColor: Colors.black12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    ngo.image,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.slate.withValues(alpha: 0.3),
                            AppColors.slate.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade400,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            ngo.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ngo.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.slate,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.emerald.withValues(alpha: 0.15),
                            AppColors.teal.withValues(alpha: 0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '🎯 ${ngo.cause}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DonateKartScreen extends StatelessWidget {
  final List<DonationKit> kits;
  final List<DonationKit> cart;
  final ValueChanged<DonationKit> onAddToCart;
  final VoidCallback onCheckout;

  const DonateKartScreen({
    super.key,
    required this.kits,
    required this.cart,
    required this.onAddToCart,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kits.length,
            itemBuilder: (context, index) {
              final kit = kits[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: AppColors.emerald.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                elevation: 3,
                shadowColor: AppColors.emerald.withValues(alpha: 0.2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        AppColors.emeraldSoft.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          kit.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.emerald.withValues(alpha: 0.3),
                                      AppColors.teal.withValues(alpha: 0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.card_giftcard,
                                  color: AppColors.emerald,
                                  size: 32,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kit.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.slate,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              kit.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.slateLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.emerald.withValues(alpha: 0.2),
                                    AppColors.teal.withValues(alpha: 0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '₹${kit.price.toLocaleString()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.emerald,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.emerald.withValues(alpha: 0.15),
                              AppColors.teal.withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => onAddToCart(kit),
                          icon: const Icon(Icons.add_shopping_cart),
                          color: AppColors.emerald,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (cart.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Total Donation',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${cart.fold(0, (sum, item) => sum + item.price).toLocaleString()}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onCheckout,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Checkout',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PickupRequestScreen extends StatefulWidget {
  final UserProfile? currentUser;
  final ValueChanged<PickupRequest> onSubmit;

  const PickupRequestScreen({
    super.key,
    this.currentUser,
    required this.onSubmit,
  });

  @override
  State<PickupRequestScreen> createState() => _PickupRequestScreenState();
}

class _PickupRequestScreenState extends State<PickupRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String _itemType = 'Clothes';
  String _quantity = '';
  String _address = '';
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule a Pickup',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.slate,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We will collect usable clothes, books, toys, or electronics directly from your doorstep.',
              style: TextStyle(color: AppColors.slateLight, height: 1.5),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              initialValue: _itemType,
              decoration: InputDecoration(
                labelText: 'What are you donating?',
                prefixIcon: const Icon(Icons.category, color: AppColors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.orange,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.orange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.orangeSoft.withValues(alpha: 0.3),
              ),
              items: [
                'Clothes',
                'Books & Stationery',
                'Toys',
                'Electronics',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _itemType = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Approximate Quantity (e.g., 2 boxes)',
                prefixIcon: const Icon(
                  Icons.inventory,
                  color: AppColors.emerald,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.emerald,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.emerald.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.emeraldSoft.withValues(alpha: 0.2),
              ),
              validator: (v) => v!.isEmpty ? 'Please enter a quantity' : null,
              onSaved: (v) => _quantity = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Pickup Address',
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: AppColors.rose,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.rose, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.rose.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.roseSoft.withValues(alpha: 0.2),
              ),
              validator: (v) => v!.isEmpty ? 'Please enter your address' : null,
              onSaved: (v) => _address = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                prefixIcon: const Icon(Icons.phone, color: AppColors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.teal, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.teal.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.tealSoft.withValues(alpha: 0.2),
              ),
              validator: (v) =>
                  v!.isEmpty ? 'Please enter a phone number' : null,
              onSaved: (v) => _phone = v!,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.emerald.withValues(alpha: 0.4),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSubmit(
                      PickupRequest(
                        id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                        donorName: widget.currentUser?.name ?? 'Guest Donor',
                        itemType: _itemType,
                        quantity: _quantity,
                        address: _address,
                        date: DateTime.now().toString().split(' ')[0],
                        phone: _phone,
                        status: 'Pending',
                      ),
                    );
                  }
                },
                child: const Text(
                  'Book Pickup Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VolunteerRegistrationScreen extends StatefulWidget {
  final ValueChanged<VolunteerEntry> onSubmit;

  const VolunteerRegistrationScreen({super.key, required this.onSubmit});

  @override
  State<VolunteerRegistrationScreen> createState() =>
      _VolunteerRegistrationScreenState();
}

class _VolunteerRegistrationScreenState
    extends State<VolunteerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _city = '';
  String _skills = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.purple, AppColors.rose],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Become a Volunteer',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Join our on-ground task force. Help with logistics, crowd management, or community outreach.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person, color: AppColors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.blue, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.blue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.blueSoft.withValues(alpha: 0.2),
              ),
              validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
              onSaved: (v) => _name = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email, color: AppColors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.orange,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.orange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.orangeSoft.withValues(alpha: 0.2),
              ),
              validator: (v) => v!.isEmpty ? 'Please enter your email' : null,
              onSaved: (v) => _email = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone, color: AppColors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.teal, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.teal.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.tealSoft.withValues(alpha: 0.2),
              ),
              validator: (v) => v!.isEmpty ? 'Please enter phone' : null,
              onSaved: (v) => _phone = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'City of Residence',
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: AppColors.amber,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.amber,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.amber.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.amberSoft.withValues(alpha: 0.2),
              ),
              validator: (v) => v!.isEmpty ? 'Please enter your city' : null,
              onSaved: (v) => _city = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Skills / How can you help? (e.g., Have a vehicle)',
                prefixIcon: const Icon(Icons.star, color: AppColors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.purple,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.purple.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.purpleSoft.withValues(alpha: 0.2),
                alignLabelWithHint: true,
              ),
              onSaved: (v) => _skills = v ?? '',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.purple.withValues(alpha: 0.4),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSubmit(
                      VolunteerEntry(
                        id: 'v_${DateTime.now().millisecondsSinceEpoch}',
                        name: _name,
                        email: _email,
                        phone: _phone,
                        city: _city,
                        skills: _skills,
                        status: 'Pending',
                      ),
                    );
                  }
                },
                child: const Text(
                  'Submit Application',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  final List<NgoPartner> ngos;
  final List<DonationKit> kits;
  final List<PickupRequest> pickups;
  final List<VolunteerEntry> volunteers;
  final int totalCollected;

  final ValueChanged<DonationKit> onAddKit;
  final ValueChanged<String> onDeleteKit;
  final ValueChanged<NgoPartner> onAddNgo;
  final ValueChanged<String> onDeleteNgo;
  final void Function(String, String) onUpdatePickup;
  final ValueChanged<String> onVerifyVolunteer;

  const AdminDashboard({
    super.key,
    required this.ngos,
    required this.kits,
    required this.pickups,
    required this.volunteers,
    required this.totalCollected,
    required this.onAddKit,
    required this.onDeleteKit,
    required this.onAddNgo,
    required this.onDeleteNgo,
    required this.onUpdatePickup,
    required this.onVerifyVolunteer,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.slate, AppColors.slateDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '💰 Total Impact Driven',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${totalCollected.toLocaleString()}',
                        style: const TextStyle(
                          color: AppColors.emeraldLight,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: AppColors.emerald,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.emerald,
              indicatorWeight: 3,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(icon: Icon(Icons.inventory), text: 'Kits'),
                Tab(icon: Icon(Icons.local_shipping), text: 'Pickups'),
                Tab(icon: Icon(Icons.people), text: 'NGOs'),
                Tab(icon: Icon(Icons.badge), text: 'Volunteers'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _AdminKitsTab(kits: kits, onDelete: onDeleteKit),
                _AdminPickupsTab(pickups: pickups, onUpdate: onUpdatePickup),
                _AdminNgosTab(ngos: ngos, onDelete: onDeleteNgo),
                _AdminVolunteersTab(
                  volunteers: volunteers,
                  onVerify: onVerifyVolunteer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminKitsTab extends StatelessWidget {
  final List<DonationKit> kits;
  final ValueChanged<String> onDelete;

  const _AdminKitsTab({required this.kits, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kits.length,
      itemBuilder: (context, index) {
        final kit = kits[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.emerald.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          elevation: 2,
          shadowColor: AppColors.emerald.withValues(alpha: 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  AppColors.emeraldSoft.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.blue.withValues(alpha: 0.2),
                      AppColors.emerald.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: AppColors.emerald,
                  size: 24,
                ),
              ),
              title: Text(
                kit.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate,
                  fontSize: 15,
                ),
              ),
              subtitle: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '₹${kit.price}',
                      style: const TextStyle(
                        color: AppColors.emerald,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      kit.category,
                      style: const TextStyle(
                        color: AppColors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever, color: AppColors.rose),
                onPressed: () => onDelete(kit.id),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminPickupsTab extends StatelessWidget {
  final List<PickupRequest> pickups;
  final void Function(String, String) onUpdate;

  const _AdminPickupsTab({required this.pickups, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pickups.length,
      itemBuilder: (context, index) {
        final req = pickups[index];
        final isCompleted = req.status == 'Completed';
        final statusColor = isCompleted
            ? AppColors.success
            : req.status == 'Out for Pickup'
            ? AppColors.orange
            : AppColors.amber;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: statusColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          elevation: 2,
          shadowColor: statusColor.withValues(alpha: 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.white, statusColor.withValues(alpha: 0.08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withValues(alpha: 0.2),
                      statusColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.local_shipping, color: statusColor, size: 24),
              ),
              title: Text(
                req.itemType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    req.donorName,
                    style: const TextStyle(
                      color: AppColors.slateLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    req.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => onUpdate(req.id, req.status),
                child: Text(
                  req.status,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminNgosTab extends StatelessWidget {
  final List<NgoPartner> ngos;
  final ValueChanged<String> onDelete;

  const _AdminNgosTab({required this.ngos, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ngos.length,
      itemBuilder: (context, index) {
        final ngo = ngos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.purple.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          elevation: 2,
          shadowColor: AppColors.purple.withValues(alpha: 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  AppColors.purpleSoft.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ngo.image),
                backgroundColor: AppColors.purple.withValues(alpha: 0.2),
              ),
              title: Text(
                ngo.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate,
                  fontSize: 15,
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.favorite, size: 14, color: AppColors.rose),
                  const SizedBox(width: 4),
                  Text(
                    ngo.cause,
                    style: const TextStyle(
                      color: AppColors.slateLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 12,
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          ngo.rating.toString(),
                          style: const TextStyle(
                            color: AppColors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever, color: AppColors.rose),
                onPressed: () => onDelete(ngo.id),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminVolunteersTab extends StatelessWidget {
  final List<VolunteerEntry> volunteers;
  final ValueChanged<String> onVerify;

  const _AdminVolunteersTab({required this.volunteers, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: volunteers.length,
      itemBuilder: (context, index) {
        final vol = volunteers[index];
        final isVerified = vol.status == 'Verified';
        final statusColor = isVerified ? AppColors.success : AppColors.warning;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: statusColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          elevation: 2,
          shadowColor: statusColor.withValues(alpha: 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.white, statusColor.withValues(alpha: 0.08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withValues(alpha: 0.2),
                      statusColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.volunteer_activism,
                  color: statusColor,
                  size: 24,
                ),
              ),
              title: Text(
                vol.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    vol.city,
                    style: const TextStyle(
                      color: AppColors.slateLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    vol.skills,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              trailing: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(
                  isVerified ? Icons.verified_user : Icons.person_add,
                  size: 14,
                ),
                label: Text(
                  isVerified ? 'Verified' : 'Verify',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => onVerify(vol.id),
              ),
            ),
          ),
        );
      },
    );
  }
}
// ==================== DONATION CENTERS MAP SCREEN ====================

class DonationCentersMapScreen extends StatefulWidget {
  const DonationCentersMapScreen({super.key});

  @override
  State<DonationCentersMapScreen> createState() =>
      _DonationCentersMapScreenState();
}

class _DonationCentersMapScreenState extends State<DonationCentersMapScreen> {
  final List<Map<String, dynamic>> _centers = [
    {
      'name': 'Hope Foundation',
      'address': 'Connaught Place, New Delhi',
      'lat': 28.6315,
      'lng': 77.2167,
      'type': 'Food & Clothes',
      'color': AppColors.emerald,
    },
    {
      'name': 'Care Home Delhi',
      'address': 'Lajpat Nagar, New Delhi',
      'lat': 28.5677,
      'lng': 77.2436,
      'type': 'Electronics & Books',
      'color': AppColors.blue,
    },
    {
      'name': 'Green Earth NGO',
      'address': 'Dwarka, New Delhi',
      'lat': 28.5921,
      'lng': 77.0460,
      'type': 'Clothes & Toys',
      'color': AppColors.teal,
    },
    {
      'name': 'Helping Hands',
      'address': 'Rohini, New Delhi',
      'lat': 28.7041,
      'lng': 77.1025,
      'type': 'Food & Medicine',
      'color': AppColors.orange,
    },
    {
      'name': 'Seva Kendra',
      'address': 'Gurugram, Haryana',
      'lat': 28.4595,
      'lng': 77.0266,
      'type': 'All Donations',
      'color': AppColors.purple,
    },
  ];

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Centers Near You'),
        backgroundColor: AppColors.emerald,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(28.6139, 77.2090),
                    initialZoom: 11,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.donate_kart',
                    ),
                    MarkerLayer(
                      markers: _centers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final center = entry.value;
                        final isSelected = _selectedIndex == index;
                        return Marker(
                          point: LatLng(center['lat'], center['lng']),
                          width: isSelected ? 50 : 40,
                          height: isSelected ? 50 : 40,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedIndex = index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? center['color']
                                    : center['color'].withOpacity(0.7),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: center['color'].withOpacity(0.5),
                                    blurRadius: isSelected ? 12 : 6,
                                    spreadRadius: isSelected ? 2 : 0,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: isSelected ? 24 : 20,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.emerald,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_centers.length} Centers',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.surfaceLight,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _centers.length,
                itemBuilder: (context, index) {
                  final center = _centers[index];
                  final isSelected = _selectedIndex == index;
                  final centerColor = center['color'];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? centerColor
                            : centerColor.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    elevation: isSelected ? 4 : 1,
                    shadowColor: centerColor.withOpacity(
                      isSelected ? 0.3 : 0.1,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.white, centerColor.withOpacity(0.08)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: centerColor.withOpacity(0.2),
                          child: Icon(
                            Icons.volunteer_activism,
                            color: centerColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          center['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.slate,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      center['address'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: centerColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        center['type'],
                                        style: TextStyle(
                                          color: centerColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Icon(
                          isSelected
                              ? Icons.arrow_forward_ios
                              : Icons.chevron_right,
                          size: 16,
                          color: centerColor,
                        ),
                        isThreeLine: true,
                        onTap: () {
                          setState(() => _selectedIndex = index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// User Profile Screen
class UserProfileScreen extends StatelessWidget {
  final UserProfile? user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('No user logged in'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.emerald, AppColors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user!.role.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user!.email,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Account Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email, color: AppColors.orange),
                    title: const Text('Email'),
                    subtitle: Text(user!.email),
                    dense: true,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security, color: AppColors.rose),
                    title: const Text('Account Type'),
                    subtitle: Text(
                      user!.role == 'admin' ? 'Administrator' : 'Donor',
                    ),
                    dense: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Donation History Screen
class DonationHistoryScreen extends StatelessWidget {
  final List<DonationHistory> history;

  const DonationHistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.purple, AppColors.rose],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Donation Impact',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              if (history.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Donated',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${history.fold(0, (sum, item) => sum + item.amount)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Donations',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${history.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else
                const Text(
                  'No donations yet. Start giving today!',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (history.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'Your donations will appear here',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          ...history.map(
            (donation) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            donation.kitName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '₹${donation.amount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: ${donation.date}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            donation.status,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Impact Stories Screen
class ImpactStoriesScreen extends StatelessWidget {
  final List<ImpactStory> stories;

  const ImpactStoriesScreen({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.slate, AppColors.emerald],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📖 Impact Stories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Real stories from the communities we serve',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...stories.map(
          (story) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  color: AppColors.slate.withValues(alpha: 0.1),
                  child: Image.network(
                    story.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.slate.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              story.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              story.category,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        story.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.slateLight,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.emerald.withValues(alpha: 0.1),
                                    AppColors.teal.withValues(alpha: 0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.people,
                                    size: 14,
                                    color: AppColors.emerald,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      story.impact,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.emerald,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            story.date,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Testimonial Screen
class TestimonialScreen extends StatelessWidget {
  final List<Testimonial> testimonials;

  const TestimonialScreen({super.key, required this.testimonials});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.rose, AppColors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⭐ What People Say',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Real feedback from our community members',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...testimonials.map(
          (testimonial) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.emerald.withValues(
                          alpha: 0.2,
                        ),
                        backgroundImage: NetworkImage(testimonial.image),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              testimonial.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.emerald.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                testimonial.role,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.emerald,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: index < testimonial.rating.toInt()
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    testimonial.message,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.slateLight,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
