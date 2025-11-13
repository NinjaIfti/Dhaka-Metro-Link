// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:metro_link/core/theme/app_theme.dart';
import 'package:metro_link/core/di/service_locator.dart';
import 'package:metro_link/domain/entities/card.dart';
import 'package:metro_link/domain/entities/journey.dart';
import 'package:metro_link/domain/entities/station.dart';
import 'package:metro_link/domain/repositories/card_repository.dart';
import 'package:metro_link/domain/repositories/journey_repository.dart';
import 'package:metro_link/domain/repositories/station_repository.dart';
import 'package:metro_link/presentation/pages/scan_card_page.dart';
import 'package:metro_link/presentation/pages/recharge_page.dart';
import 'package:metro_link/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardRepository _cardRepository = sl<CardRepository>();
  final JourneyRepository _journeyRepository = sl<JourneyRepository>();
  final StationRepository _stationRepository = sl<StationRepository>();

  // Data loaded from repository
  MetroCard? _demoCard;
  List<Journey> _recentJourneys = [];
  List<Station> _stations = [];
  bool _isLoading = true;
  String _userId = 'user_001'; // Will be replaced with actual auth later

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load user's cards
      final cards = await _cardRepository.getActiveCardsByUserId(_userId);

      // Load recent journeys
      final journeys =
          await _journeyRepository.getRecentJourneysByUserId(_userId, limit: 5);

      // Load stations
      final stations = await _stationRepository.getAllStations();

      setState(() {
        _demoCard = cards.isNotEmpty ? cards.first : null;
        _recentJourneys = journeys;
        _stations = stations;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('MetroLink'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MetroLink'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'My Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ScanCardPage()),
          );
        },
        child: const Icon(Icons.nfc),
        backgroundColor: AppTheme.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildCardTab();
      case 2:
        return _buildHistoryTab();
      case 3:
        return _buildMapTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardWidget(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildRecentJourneys(),
        ],
      ),
    );
  }

  Widget _buildCardWidget() {
    if (_demoCard == null) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.credit_card_off,
                  size: 48,
                  color: Colors.white70,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Card Found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Scan your metro card to get started',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ScanCardPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('Scan Card'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Metro Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _demoCard!.isActive ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Card No: ${_demoCard!.cardNumber}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Used: ${_demoCard!.lastUsed != null ? _formatDate(_demoCard!.lastUsed!) : "Never"}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '৳ ${_demoCard!.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RechargePage(card: _demoCard!),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('Recharge'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionItem(Icons.contactless, 'Scan Card'),
            _buildActionItem(Icons.schedule, 'Schedule'),
            _buildActionItem(Icons.payments, 'Fare Info'),
            _buildActionItem(Icons.help_outline, 'Help'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Scan Card') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ScanCardPage()),
          );
        }
        // Add other actions for other items as needed
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppTheme.accentColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJourneys() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Journeys',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to history page
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_recentJourneys.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No recent journeys'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentJourneys.length,
            itemBuilder: (context, index) {
              final journey = _recentJourneys[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(journey.startTime),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '৳ ${journey.fare.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 12, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Uttara North',
                              // We'll replace this with actual station names
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(journey.startTime),
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.circle, size: 12, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Motijheel',
                              // We'll replace this with actual station names
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ),
                          Text(
                            journey.endTime != null
                                ? _formatTime(journey.endTime!)
                                : '--:--',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // Placeholder methods for other tabs

  Widget _buildCardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardWidget(), // Reuse the card widget from the home tab
          const SizedBox(height: 24),
          const Text(
            'Card Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCardDetails(),
          const SizedBox(height: 24),
          const Text(
            'Card Management',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCardManagementOptions(),
        ],
      ),
    );
  }

  Widget _buildCardDetails() {
    if (_demoCard == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Text('No card data available'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow(Icons.credit_card, 'Card Number', _demoCard!.cardNumber),
            const Divider(),
            _buildDetailRow(Icons.calendar_today, 'Last Used',
                _demoCard!.lastUsed != null ? _formatDate(_demoCard!.lastUsed!) : 'Never'),
            const Divider(),
            _buildDetailRow(Icons.verified, 'Status',
                _demoCard!.isActive ? 'Active' : 'Inactive'),
            const Divider(),
            _buildDetailRow(Icons.account_balance_wallet, 'Balance',
                '৳ ${_demoCard!.balance.toStringAsFixed(2)}'),
            const Divider(),
            _buildDetailRow(Icons.person, 'Owner', 'Rakib Ahmed'), // Will be replaced with actual user data
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardManagementOptions() {
    return Column(
      children: [
        _buildManagementOption(
          Icons.autorenew,
          'Replace Card',
          'Report lost card and get a new one',
              () {
            // Show "Coming Soon" dialog
            _showComingSoonDialog('Replace Card');
          },
        ),
        const SizedBox(height: 12),
        _buildManagementOption(
          Icons.block,
          'Block Card',
          'Temporarily disable your card',
              () {
            // Show "Coming Soon" dialog
            _showComingSoonDialog('Block Card');
          },
        ),
        const SizedBox(height: 12),
        _buildManagementOption(
          Icons.history,
          'Transaction History',
          'View all card transactions',
              () {
            setState(() {
              _selectedIndex = 2; // Switch to History tab
            });
          },
        ),
      ],
    );
  }

  Widget _buildManagementOption(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature Coming Soon'),
        content: Text('We\'re working on bringing you the $feature functionality. Stay tuned for updates!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    // Create a list of mock transactions with both journeys and recharges
    final List<Map<String, dynamic>> transactions = [
      {
        'id': '1',
        'type': 'journey',
        'amount': -25.0,
        'date': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        'from': 'Uttara North',
        'to': 'Motijheel',
      },
      {
        'id': '2',
        'type': 'recharge',
        'amount': 100.0,
        'date': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'id': '3',
        'type': 'journey',
        'amount': -30.0,
        'date': DateTime.now().subtract(const Duration(days: 3, hours: 5)),
        'from': 'Agargaon',
        'to': 'Shahbagh',
      },
      {
        'id': '4',
        'type': 'recharge',
        'amount': 200.0,
        'date': DateTime.now().subtract(const Duration(days: 7)),
      },
      {
        'id': '5',
        'type': 'journey',
        'amount': -15.0,
        'date': DateTime.now().subtract(const Duration(days: 8, hours: 1)),
        'from': 'Farmgate',
        'to': 'Karwan Bazar',
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: 'All',
                items: ['All', 'Journeys', 'Recharges']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  // Filter logic would go here
                },
                icon: const Icon(Icons.filter_list),
                underline: Container(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return _buildTransactionItem(transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final bool isJourney = transaction['type'] == 'journey';
    final bool isPositive = transaction['amount'] > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(transaction['date']),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.add_circle : Icons.remove_circle,
                      size: 16,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '৳ ${transaction['amount'].abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isJourney ? 'Journey' : 'Recharge',
              style: TextStyle(
                color: isJourney ? AppTheme.primaryColor : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isJourney) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    transaction['from'],
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(transaction['date']),
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  height: 16,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    transaction['to'],
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'Added to card ${_demoCard?.cardNumber ?? "N/A"}',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMapTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          color: AppTheme.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Metro Map',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Interactive map coming soon! For now, browse all stations below.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search stations',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _stations.isEmpty
              ? const Center(
                  child: Text('No stations available'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: _stations.length,
                  itemBuilder: (context, index) {
                    final station = _stations[index];
                    return _buildStationItem(station, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStationItem(Station station, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryColor,
        child: Text(
          '${station.position}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        station.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text('MRT ${station.lineId.toUpperCase().replaceAll('_', ' ')}'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: station.isActive ? Colors.green : Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          station.isActive ? 'Open' : 'Closed',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
      onTap: () {
        // Show station details
        _showComingSoonDialog('Station Details');
      },
    );
  }

  // Helper methods
  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
