import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gift_management_app/Models/event.dart';
import 'package:gift_management_app/Models/friend.dart';
import 'package:gift_management_app/Models/gift.dart';
import 'package:gift_management_app/Models/hedieaty_user.dart';

class LocalDatabase {
  static Database? _database;

  static Future<Database> get db async {
    if (_database == null) {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'hedieaty_database.db');
      _database = await openDatabase(path, version: 3, onCreate: _createTables);
    }
    return _database!;
  }

  static Future _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        uid TEXT PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL UNIQUE
      );
        
      CREATE TABLE events (
        id TEXT NOT NULL,
        name TEXT NOT NULL,
        date_time INTEGER NOT NULL,
        location TEXT NOT NULL,
        description TEXT NOT NULL,
        
        user_id TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES user(uid),
      );
      
      CREATE TABLE gifts (
        id TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        image_url TEXT NOT NULL,
        status TEXT NOT NULL,
        
        event_id TEXT NOT NULL,
        buyer_id TEXT
        FOREIGN KEY (event_id) REFERENCES event(id)
        FOREIGN KEY (buyer_id) REFERENCES user(id),
      );
      
      CREATE TABLE friends (
        user_id TEXT NOT NULL,
        friend_id TEXT NOT NULL,        
        FOREIGN KEY (user_id) REFERENCES user(id),
        FOREIGN KEY (friend_id) REFERENCES user(id),
        PRIMARY KEY (user_id, friend_id)       
      );
    ''');
  }
}

class UserLocalDAO {
  static Future insertUser(HedieatyUser user) async {
    final db = await LocalDatabase.db;
    await db.insert('users', user.toMap());
  }

  static Future<List<HedieatyUser>> getUsers() async {
    final db = await LocalDatabase.db;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return HedieatyUser.fromMap(maps[i]);
    });
  }

  static Future updateUser(HedieatyUser user) async {
    final db = await LocalDatabase.db;
    await db
        .update('users', user.toMap(), where: 'uid = ?', whereArgs: [user.id]);
  }

  static Future deleteUser(String uid) async {
    final db = await LocalDatabase.db;
    await db.delete('users', where: 'uid = ?', whereArgs: [uid]);
  }
}

class EventLocalDAO {
  static Future insertEvent(Event event) async {
    final db = await LocalDatabase.db;
    await db.insert('events', event.toMap());
  }

  static Future<List<Event>> getEvents() async {
    final db = await LocalDatabase.db;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  static Future updateEvent(Event event) async {
    final db = await LocalDatabase.db;
    await db.update('events', event.toMap(),
        where: 'id = ?', whereArgs: [event.id]);
  }

  static Future deleteEvent(String id) async {
    final db = await LocalDatabase.db;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}

class GiftLocalDAO {
  static Future insertGift(Gift gift) async {
    final db = await LocalDatabase.db;
    await db.insert('gifts', gift.toMap());
  }

  static Future<List<Gift>> getGifts() async {
    final db = await LocalDatabase.db;
    final List<Map<String, dynamic>> maps = await db.query('gifts');
    return List.generate(maps.length, (i) {
      return Gift.fromMap(maps[i]);
    });
  }

  static Future updateGift(Gift gift) async {
    final db = await LocalDatabase.db;
    await db
        .update('gifts', gift.toMap(), where: 'id = ?', whereArgs: [gift.id]);
  }

  static Future deleteGift(String id) async {
    final db = await LocalDatabase.db;
    await db.delete('gifts', where: 'id = ?', whereArgs: [id]);
  }
}

class FriendLocalDAO {
  Future<void> insertFriend(Friend friend) async {
    final db = await LocalDatabase.db;
    await db.insert('friends', friend.toMap());
  }

  Future<List<Friend>> getFriends() async {
    final db = await LocalDatabase.db;
    final List<Map<String, dynamic>> maps = await db.query('friends');
    return List.generate(maps.length, (i) {
      return Friend.fromMap(maps[i]);
    });
  }

  Future<void> deleteFriend(Friend friend) async {
    final db = await LocalDatabase.db;
    await db.delete(
      'friends',
      where: '(user_id = ? AND friend_id = ?)',
      whereArgs: [friend.userId, friend.friendId],
    );
  }
}
