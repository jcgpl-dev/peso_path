import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'peso_path.db'),
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS users(
          id TEXT PRIMARY KEY,
          name TEXT,
          username TEXT UNIQUE,
          password TEXT,
          profile_picture TEXT,
          created_at TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS transactions(
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          note TEXT,
          transaction_date TEXT NOT NULL,
          created_at TEXT NOT NULL,
          FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
        )
        ''');

        await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_transactions_user_id
        ON transactions(user_id)
        ''');
        await db.execute('''
        CREATE TABLE IF NOT EXISTS budget_cycles(
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          budget_amount REAL NOT NULL,
          start_date TEXT NOT NULL,
          end_date TEXT NOT NULL,
          is_active INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
        )
        ''');

        await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_budget_cycles_user_id
        ON budget_cycles(user_id)
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute(
            "ALTER TABLE transactions ADD COLUMN user_id TEXT NOT NULL DEFAULT ''",
          );
          await db.execute('''
          CREATE INDEX IF NOT EXISTS idx_transactions_user_id
          ON transactions(user_id)
          ''');
          await db.delete('transactions');
        }
        if (oldVersion < 6) {
          await db.execute(
            "ALTER TABLE users ADD COLUMN profile_picture TEXT;",
          );
        }
        await db.execute('''
        CREATE TABLE IF NOT EXISTS budget_cycles(
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          budget_amount REAL NOT NULL,
          start_date TEXT NOT NULL,
          end_date TEXT NOT NULL,
          is_active INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
        )
        ''');

        await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_budget_cycles_user_id
        ON budget_cycles(user_id)
        ''');
      },
    );
  }
}
