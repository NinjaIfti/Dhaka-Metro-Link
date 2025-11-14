import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('metro_link.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String path = join(appDocumentsDir.path, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone_number TEXT NOT NULL,
        profile_image_url TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Metro cards table
    await db.execute('''
      CREATE TABLE metro_cards (
        id TEXT PRIMARY KEY,
        card_number TEXT NOT NULL UNIQUE,
        balance REAL NOT NULL DEFAULT 0.0,
        last_used TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        user_id TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Stations table
    await db.execute('''
      CREATE TABLE stations (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        line_id TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        position INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Journeys table
    await db.execute('''
      CREATE TABLE journeys (
        id TEXT PRIMARY KEY,
        card_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        start_station_id TEXT NOT NULL,
        end_station_id TEXT,
        start_time TEXT NOT NULL,
        end_time TEXT,
        fare REAL,
        status TEXT NOT NULL,
        FOREIGN KEY (card_id) REFERENCES metro_cards (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (start_station_id) REFERENCES stations (id),
        FOREIGN KEY (end_station_id) REFERENCES stations (id)
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        card_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        description TEXT,
        journey_id TEXT,
        FOREIGN KEY (card_id) REFERENCES metro_cards (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (journey_id) REFERENCES journeys (id) ON DELETE SET NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_cards_user_id ON metro_cards(user_id)');
    await db.execute('CREATE INDEX idx_journeys_card_id ON journeys(card_id)');
    await db.execute('CREATE INDEX idx_journeys_user_id ON journeys(user_id)');
    await db.execute('CREATE INDEX idx_journeys_start_time ON journeys(start_time)');
    await db.execute('CREATE INDEX idx_transactions_card_id ON transactions(card_id)');
    await db.execute('CREATE INDEX idx_transactions_user_id ON transactions(user_id)');
    await db.execute('CREATE INDEX idx_transactions_timestamp ON transactions(timestamp)');

    // Insert default stations (Dhaka Metro Line 6)
    await _insertDefaultStations(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle future database migrations
    if (oldVersion < 2) {
      // Future migration logic
    }
  }

  Future<void> _insertDefaultStations(Database db) async {
    final List<Map<String, dynamic>> stations = [
      {
        'id': 'stn_001',
        'name': 'Uttara North',
        'line_id': 'line_6',
        'latitude': 23.8759,
        'longitude': 90.3795,
        'position': 1,
        'is_active': 1
      },
      {
        'id': 'stn_002',
        'name': 'Uttara Center',
        'line_id': 'line_6',
        'latitude': 23.8697,
        'longitude': 90.3795,
        'position': 2,
        'is_active': 1
      },
      {
        'id': 'stn_003',
        'name': 'Uttara South',
        'line_id': 'line_6',
        'latitude': 23.8627,
        'longitude': 90.3795,
        'position': 3,
        'is_active': 1
      },
      {
        'id': 'stn_004',
        'name': 'Pallabi',
        'line_id': 'line_6',
        'latitude': 23.8253,
        'longitude': 90.3687,
        'position': 4,
        'is_active': 1
      },
      {
        'id': 'stn_005',
        'name': 'Mirpur 11',
        'line_id': 'line_6',
        'latitude': 23.8166,
        'longitude': 90.3687,
        'position': 5,
        'is_active': 1
      },
      {
        'id': 'stn_006',
        'name': 'Mirpur 10',
        'line_id': 'line_6',
        'latitude': 23.8073,
        'longitude': 90.3687,
        'position': 6,
        'is_active': 1
      },
      {
        'id': 'stn_007',
        'name': 'Kazipara',
        'line_id': 'line_6',
        'latitude': 23.7993,
        'longitude': 90.3687,
        'position': 7,
        'is_active': 1
      },
      {
        'id': 'stn_008',
        'name': 'Shewrapara',
        'line_id': 'line_6',
        'latitude': 23.7921,
        'longitude': 90.3687,
        'position': 8,
        'is_active': 1
      },
      {
        'id': 'stn_009',
        'name': 'Agargaon',
        'line_id': 'line_6',
        'latitude': 23.7777,
        'longitude': 90.3833,
        'position': 9,
        'is_active': 1
      },
      {
        'id': 'stn_010',
        'name': 'Bijoy Sarani',
        'line_id': 'line_6',
        'latitude': 23.7657,
        'longitude': 90.3833,
        'position': 10,
        'is_active': 1
      },
      {
        'id': 'stn_011',
        'name': 'Farmgate',
        'line_id': 'line_6',
        'latitude': 23.7573,
        'longitude': 90.3883,
        'position': 11,
        'is_active': 1
      },
      {
        'id': 'stn_012',
        'name': 'Karwan Bazar',
        'line_id': 'line_6',
        'latitude': 23.7503,
        'longitude': 90.3933,
        'position': 12,
        'is_active': 1
      },
      {
        'id': 'stn_013',
        'name': 'Shahbagh',
        'line_id': 'line_6',
        'latitude': 23.7389,
        'longitude': 90.3953,
        'position': 13,
        'is_active': 1
      },
      {
        'id': 'stn_014',
        'name': 'Dhaka University',
        'line_id': 'line_6',
        'latitude': 23.7322,
        'longitude': 90.3953,
        'position': 14,
        'is_active': 1
      },
      {
        'id': 'stn_015',
        'name': 'Bangladesh Secretariat',
        'line_id': 'line_6',
        'latitude': 23.7253,
        'longitude': 90.3993,
        'position': 15,
        'is_active': 1
      },
      {
        'id': 'stn_016',
        'name': 'Motijheel',
        'line_id': 'line_6',
        'latitude': 23.7177,
        'longitude': 90.4177,
        'position': 16,
        'is_active': 1
      },
    ];

    for (final station in stations) {
      await db.insert('stations', station);
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('transactions');
    await db.delete('journeys');
    await db.delete('metro_cards');
    await db.delete('users');
    // Don't clear stations as they are reference data
  }
}
