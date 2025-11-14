import '../../domain/entities/card.dart';
import '../../domain/repositories/card_repository.dart';
import '../../core/database/database_helper.dart';
import '../models/card_model.dart';

class CardRepositoryImpl implements CardRepository {
  final DatabaseHelper _dbHelper;

  CardRepositoryImpl(this._dbHelper);

  @override
  Future<MetroCard> createCard(MetroCard card) async {
    final db = await _dbHelper.database;
    final cardModel = CardModel.fromEntity(card);
    await db.insert('metro_cards', cardModel.toMap());
    return card;
  }

  @override
  Future<MetroCard?> getCardById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'metro_cards',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return CardModel.fromMap(maps.first).toEntity();
  }

  @override
  Future<MetroCard?> getCardByNumber(String cardNumber) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'metro_cards',
      where: 'card_number = ?',
      whereArgs: [cardNumber],
    );

    if (maps.isEmpty) return null;

    return CardModel.fromMap(maps.first).toEntity();
  }

  @override
  Future<List<MetroCard>> getCardsByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'metro_cards',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'last_used DESC',
    );

    return maps.map((map) => CardModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<MetroCard> updateCard(MetroCard card) async {
    final db = await _dbHelper.database;
    final cardModel = CardModel.fromEntity(card);
    await db.update(
      'metro_cards',
      cardModel.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
    return card;
  }

  @override
  Future<void> updateCardBalance(String cardId, double newBalance) async {
    final db = await _dbHelper.database;
    await db.update(
      'metro_cards',
      {'balance': newBalance, 'last_used': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [cardId],
    );
  }

  @override
  Future<void> deleteCard(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'metro_cards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<MetroCard>> getAllCards() async {
    final db = await _dbHelper.database;
    final maps = await db.query('metro_cards', orderBy: 'last_used DESC');
    return maps.map((map) => CardModel.fromMap(map).toEntity()).toList();
  }

  @override
  Future<bool> cardExists(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'metro_cards',
      columns: ['COUNT(*) as count'],
      where: 'id = ?',
      whereArgs: [id],
    );

    final count = result.first['count'] as int;
    return count > 0;
  }

  @override
  Future<List<MetroCard>> getActiveCardsByUserId(String userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'metro_cards',
      where: 'user_id = ? AND is_active = ?',
      whereArgs: [userId, 1],
      orderBy: 'last_used DESC',
    );

    return maps.map((map) => CardModel.fromMap(map).toEntity()).toList();
  }
}
