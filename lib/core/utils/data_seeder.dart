import '../../domain/entities/user.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/journey.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/journey_repository.dart';
import '../../domain/repositories/transaction_repository.dart';

class DataSeeder {
  final UserRepository userRepository;
  final CardRepository cardRepository;
  final JourneyRepository journeyRepository;
  final TransactionRepository transactionRepository;

  DataSeeder({
    required this.userRepository,
    required this.cardRepository,
    required this.journeyRepository,
    required this.transactionRepository,
  });

  Future<void> seedInitialData() async {
    // Check if data already exists
    final users = await userRepository.getAllUsers();
    if (users.isNotEmpty) {
      // Data already seeded
      return;
    }

    // Create a test user
    final user = User(
      id: 'user_001',
      name: 'Rakib Ahmed',
      email: 'rakib@example.com',
      phoneNumber: '+8801712345678',
      profileImageUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      cardIds: [],
    );

    await userRepository.createUser(user);

    // Create test metro cards
    final card1 = MetroCard(
      id: 'card_001',
      cardNumber: 'MC-2024-001234',
      balance: 450.0,
      lastUsed: DateTime.now().subtract(const Duration(hours: 2)),
      isActive: true,
      userId: user.id,
    );

    final card2 = MetroCard(
      id: 'card_002',
      cardNumber: 'MC-2024-005678',
      balance: 120.0,
      lastUsed: DateTime.now().subtract(const Duration(days: 5)),
      isActive: true,
      userId: user.id,
    );

    await cardRepository.createCard(card1);
    await cardRepository.createCard(card2);

    // Create test journeys
    final now = DateTime.now();

    // Recent completed journey
    final journey1 = Journey(
      id: 'journey_001',
      cardId: card1.id,
      userId: user.id,
      startStationId: 'stn_001', // Uttara North
      endStationId: 'stn_011', // Farmgate
      startTime: now.subtract(const Duration(hours: 3)),
      endTime: now.subtract(const Duration(hours: 2, minutes: 45)),
      fare: 30.0,
      status: JourneyStatus.completed,
    );

    // Yesterday's journey
    final journey2 = Journey(
      id: 'journey_002',
      cardId: card1.id,
      userId: user.id,
      startStationId: 'stn_011', // Farmgate
      endStationId: 'stn_016', // Motijheel
      startTime: now.subtract(const Duration(days: 1, hours: 9)),
      endTime: now.subtract(const Duration(days: 1, hours: 8, minutes: 40)),
      fare: 25.0,
      status: JourneyStatus.completed,
    );

    // Last week's journey
    final journey3 = Journey(
      id: 'journey_003',
      cardId: card2.id,
      userId: user.id,
      startStationId: 'stn_004', // Pallabi
      endStationId: 'stn_013', // Shahbagh
      startTime: now.subtract(const Duration(days: 7, hours: 14)),
      endTime: now.subtract(const Duration(days: 7, hours: 13, minutes: 35)),
      fare: 35.0,
      status: JourneyStatus.completed,
    );

    await journeyRepository.createJourney(journey1);
    await journeyRepository.createJourney(journey2);
    await journeyRepository.createJourney(journey3);

    // Create test transactions
    // Initial recharge for card 1
    final transaction1 = Transaction(
      id: 'txn_001',
      cardId: card1.id,
      userId: user.id,
      amount: 500.0,
      type: TransactionType.recharge,
      timestamp: now.subtract(const Duration(days: 30)),
      description: 'Initial recharge',
      journeyId: null,
    );

    // Fare deduction for journey 1
    final transaction2 = Transaction(
      id: 'txn_002',
      cardId: card1.id,
      userId: user.id,
      amount: -30.0,
      type: TransactionType.fare,
      timestamp: journey1.endTime!,
      description: 'Uttara North to Farmgate',
      journeyId: journey1.id,
    );

    // Fare deduction for journey 2
    final transaction3 = Transaction(
      id: 'txn_003',
      cardId: card1.id,
      userId: user.id,
      amount: -25.0,
      type: TransactionType.fare,
      timestamp: journey2.endTime!,
      description: 'Farmgate to Motijheel',
      journeyId: journey2.id,
    );

    // Recent recharge for card 1
    final transaction4 = Transaction(
      id: 'txn_004',
      cardId: card1.id,
      userId: user.id,
      amount: 200.0,
      type: TransactionType.recharge,
      timestamp: now.subtract(const Duration(days: 2)),
      description: 'Mobile recharge via bKash',
      journeyId: null,
    );

    // Initial recharge for card 2
    final transaction5 = Transaction(
      id: 'txn_005',
      cardId: card2.id,
      userId: user.id,
      amount: 300.0,
      type: TransactionType.recharge,
      timestamp: now.subtract(const Duration(days: 20)),
      description: 'Initial recharge',
      journeyId: null,
    );

    // Fare deduction for journey 3
    final transaction6 = Transaction(
      id: 'txn_006',
      cardId: card2.id,
      userId: user.id,
      amount: -35.0,
      type: TransactionType.fare,
      timestamp: journey3.endTime!,
      description: 'Pallabi to Shahbagh',
      journeyId: journey3.id,
    );

    await transactionRepository.createTransaction(transaction1);
    await transactionRepository.createTransaction(transaction2);
    await transactionRepository.createTransaction(transaction3);
    await transactionRepository.createTransaction(transaction4);
    await transactionRepository.createTransaction(transaction5);
    await transactionRepository.createTransaction(transaction6);
  }
}
