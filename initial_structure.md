 ┣ main.dart
 ┃ import 'package:flutter/material.dart';
 ┃ 
 ┃ void main() {
 ┃   runApp(const MyApp());
 ┃ }
 ┃ 
 ┃ class MyApp extends StatelessWidget {
 ┃   const MyApp({super.key});
 ┃ 
 ┃   @override
 ┃   Widget build(BuildContext context) {
 ┃     return MaterialApp(
 ┃       debugShowCheckedModeBanner: false,
 ┃       title: 'Peso Path',
 ┃       theme: ThemeData(primarySwatch: Colors.blue),
 ┃       home: Scaffold(
 ┃         appBar: AppBar(),
 ┃         body: Center(child: Text('Hello, World!')),
 ┃       ),
 ┃     );
 ┃   }
 ┃ }

 ┣ shared
 ┣ assets
 ┃  ┣ images
 ┃  ┃  ┗ card-bg.png
 ┃  ┃    [Image File - Content Omitted]

 ┃  ┗ icons
 ┃     ┣ ic-peso-path-mipmap-xxhdpi.png
 ┃     ┃ [Image File - Content Omitted]

 ┃     ┣ ic-peso-path-mipmap-xxxhdpi.png
 ┃     ┃ [Image File - Content Omitted]

 ┃     ┣ ic-peso-path.png
 ┃     ┃ [Image File - Content Omitted]

 ┃     ┣ ic-peso-path-mipmap-hdpi.png
 ┃     ┃ [Image File - Content Omitted]

 ┃     ┣ ic-peso-path-mipmap-mdpi.png
 ┃     ┃ [Image File - Content Omitted]

 ┃     ┗ ic-peso-path-mipmap-xhdpi.png
 ┃       [Image File - Content Omitted]

 ┣ injection
 ┃  ┗ injection.dart
 ┃    import 'package:get_it/get_it.dart';
 ┃    
 ┃    final sl = GetIt.instance;
 ┃    
 ┃    Future<void> init() async {
 ┃      // blocs
 ┃    
 ┃      // usecases
 ┃    
 ┃      // repositories
 ┃    
 ┃      // datasources
 ┃    }

 ┣ core
 ┃  ┣ services
 ┃  ┣ theme
 ┃  ┃  ┣ app_theme.dart
 ┃  ┃  ┃ import 'package:flutter/material.dart';
 ┃  ┃  ┃ import 'package:google_fonts/google_fonts.dart';
 ┃  ┃  ┃ 
 ┃  ┃  ┃ import 'app_colors.dart';
 ┃  ┃  ┃ 
 ┃  ┃  ┃ class AppTheme {
 ┃  ┃  ┃   AppTheme._();
 ┃  ┃  ┃ 
 ┃  ┃  ┃   static ThemeData get lightTheme {
 ┃  ┃  ┃     return ThemeData(
 ┃  ┃  ┃       useMaterial3: true,
 ┃  ┃  ┃ 
 ┃  ┃  ┃       scaffoldBackgroundColor: AppColors.background,
 ┃  ┃  ┃ 
 ┃  ┃  ┃       colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
 ┃  ┃  ┃ 
 ┃  ┃  ┃       textTheme: GoogleFonts.interTextTheme(),
 ┃  ┃  ┃ 
 ┃  ┃  ┃       appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
 ┃  ┃  ┃     );
 ┃  ┃  ┃   }
 ┃  ┃  ┃ }

 ┃  ┃  ┣ app_text_styles.dart
 ┃  ┃  ┃ import 'package:flutter/material.dart';
 ┃  ┃  ┃ import 'package:google_fonts/google_fonts.dart';
 ┃  ┃  ┃ 
 ┃  ┃  ┃ class AppTextStyles {
 ┃  ┃  ┃   static final displayLarge = GoogleFonts.inter(
 ┃  ┃  ┃     fontSize: 32,
 ┃  ┃  ┃     fontWeight: FontWeight.w700,
 ┃  ┃  ┃   );
 ┃  ┃  ┃ 
 ┃  ┃  ┃   static final headlineLarge = GoogleFonts.inter(
 ┃  ┃  ┃     fontSize: 24,
 ┃  ┃  ┃     fontWeight: FontWeight.w700,
 ┃  ┃  ┃   );
 ┃  ┃  ┃ 
 ┃  ┃  ┃   static final titleLarge = GoogleFonts.inter(
 ┃  ┃  ┃     fontSize: 20,
 ┃  ┃  ┃     fontWeight: FontWeight.w600,
 ┃  ┃  ┃   );
 ┃  ┃  ┃ 
 ┃  ┃  ┃   static final bodyLarge = GoogleFonts.inter(
 ┃  ┃  ┃     fontSize: 16,
 ┃  ┃  ┃     fontWeight: FontWeight.w400,
 ┃  ┃  ┃   );
 ┃  ┃  ┃ 
 ┃  ┃  ┃   static final bodyMedium = GoogleFonts.inter(
 ┃  ┃  ┃     fontSize: 14,
 ┃  ┃  ┃     fontWeight: FontWeight.w400,
 ┃  ┃  ┃   );
 ┃  ┃  ┃ 
 ┃  ┃  ┃   static final labelMedium = GoogleFonts.inter(
 ┃  ┃  ┃     fontSize: 12,
 ┃  ┃  ┃     fontWeight: FontWeight.w500,
 ┃  ┃  ┃   );
 ┃  ┃  ┃ }

 ┃  ┃  ┗ app_colors.dart
 ┃  ┃    import 'package:flutter/material.dart';
 ┃  ┃    
 ┃  ┃    class AppColors {
 ┃  ┃      AppColors._();
 ┃  ┃    
 ┃  ┃      static const primary = Color(0xFF16A34A);
 ┃  ┃    
 ┃  ┃      static const primaryDark = Color(0xFF15803D);
 ┃  ┃    
 ┃  ┃      static const primaryLight = Color(0xFF22C55E);
 ┃  ┃    
 ┃  ┃      static const background = Color(0xFFF8FAFC);
 ┃  ┃    
 ┃  ┃      static const surface = Colors.white;
 ┃  ┃    
 ┃  ┃      static const income = Color(0xFF16A34A);
 ┃  ┃    
 ┃  ┃      static const expense = Color(0xFFDC2626);
 ┃  ┃    
 ┃  ┃      static const warning = Color(0xFFF59E0B);
 ┃  ┃    
 ┃  ┃      static const textPrimary = Color(0xFF0F172A);
 ┃  ┃    
 ┃  ┃      static const textSecondary = Color(0xFF64748B);
 ┃  ┃    
 ┃  ┃      static const border = Color(0xFFE2E8F0);
 ┃  ┃    }

 ┃  ┣ utils
 ┃  ┣ constants
 ┃  ┣ database
 ┃  ┃  ┗ database_helper.dart
 ┃  ┃    import 'package:path/path.dart';
 ┃  ┃    import 'package:sqflite/sqflite.dart';
 ┃  ┃    
 ┃  ┃    class DatabaseHelper {
 ┃  ┃      DatabaseHelper._();
 ┃  ┃    
 ┃  ┃      static final DatabaseHelper instance = DatabaseHelper._();
 ┃  ┃    
 ┃  ┃      Database? _database;
 ┃  ┃    
 ┃  ┃      Future<Database> get database async {
 ┃  ┃        _database ??= await _initDatabase();
 ┃  ┃        return _database!;
 ┃  ┃      }
 ┃  ┃    
 ┃  ┃      Future<Database> _initDatabase() async {
 ┃  ┃        final dbPath = await getDatabasesPath();
 ┃  ┃    
 ┃  ┃        return openDatabase(
 ┃  ┃          join(dbPath, 'peso_path.db'),
 ┃  ┃          version: 1,
 ┃  ┃          onCreate: (db, version) async {
 ┃  ┃            await db.execute('''
 ┃  ┃              CREATE TABLE users(
 ┃  ┃                id TEXT PRIMARY KEY,
 ┃  ┃                name TEXT,
 ┃  ┃                username TEXT UNIQUE,
 ┃  ┃                password TEXT,
 ┃  ┃                created_at TEXT
 ┃  ┃              )
 ┃  ┃            ''');
 ┃  ┃          },
 ┃  ┃        );
 ┃  ┃      }
 ┃  ┃    }

 ┃  ┗ router
 ┗ features
    ┗ auth
       ┣ presentation
       ┃  ┣ widgets
       ┃  ┣ pages
       ┃  ┃  ┣ splash_page.dart

       ┃  ┃  ┣ register_page.dart

       ┃  ┃  ┗ login_page.dart

       ┃  ┗ bloc
       ┃     ┣ auth_state.dart
       ┃     ┃ abstract class AuthState {}
       ┃     ┃ 
       ┃     ┃ class AuthInitial extends AuthState {}
       ┃     ┃ 
       ┃     ┃ class AuthLoading extends AuthState {}
       ┃     ┃ 
       ┃     ┃ class AuthSuccess extends AuthState {}
       ┃     ┃ 
       ┃     ┃ class AuthAuthenticated extends AuthState {
       ┃     ┃   final String username;
       ┃     ┃ 
       ┃     ┃   AuthAuthenticated(this.username);
       ┃     ┃ }
       ┃     ┃ 
       ┃     ┃ class AuthFailure extends AuthState {
       ┃     ┃   final String message;
       ┃     ┃ 
       ┃     ┃   AuthFailure(this.message);
       ┃     ┃ }

       ┃     ┣ auth_event.dart
       ┃     ┃ abstract class AuthEvent {}
       ┃     ┃ 
       ┃     ┃ class LoginRequested extends AuthEvent {
       ┃     ┃   final String username;
       ┃     ┃   final String password;
       ┃     ┃ 
       ┃     ┃   LoginRequested({required this.username, required this.password});
       ┃     ┃ }
       ┃     ┃ 
       ┃     ┃ class RegisterRequested extends AuthEvent {
       ┃     ┃   final String name;
       ┃     ┃   final String username;
       ┃     ┃   final String password;
       ┃     ┃ 
       ┃     ┃   RegisterRequested({
       ┃     ┃     required this.name,
       ┃     ┃     required this.username,
       ┃     ┃     required this.password,
       ┃     ┃   });
       ┃     ┃ }

       ┃     ┗ auth_bloc.dart

       ┣ domain
       ┃  ┣ usecases
       ┃  ┃  ┣ logout_user.dart

       ┃  ┃  ┣ register_user.dart
       ┃  ┃  ┃ import '../entities/user.dart';
       ┃  ┃  ┃ import '../repositories/auth_repository.dart';
       ┃  ┃  ┃ 
       ┃  ┃  ┃ class RegisterUser {
       ┃  ┃  ┃   final AuthRepository repository;
       ┃  ┃  ┃ 
       ┃  ┃  ┃   RegisterUser(this.repository);
       ┃  ┃  ┃ 
       ┃  ┃  ┃   Future<void> call(User user) {
       ┃  ┃  ┃     return repository.register(user);
       ┃  ┃  ┃   }
       ┃  ┃  ┃ }

       ┃  ┃  ┣ check_session.dart

       ┃  ┃  ┗ login_user.dart
       ┃  ┃    import '../entities/user.dart';
       ┃  ┃    import '../repositories/auth_repository.dart';
       ┃  ┃    
       ┃  ┃    class LoginUser {
       ┃  ┃      final AuthRepository repository;
       ┃  ┃    
       ┃  ┃      LoginUser(this.repository);
       ┃  ┃    
       ┃  ┃      Future<User?> call(String username, String password) {
       ┃  ┃        return repository.login(username, password);
       ┃  ┃      }
       ┃  ┃    }

       ┃  ┣ repositories
       ┃  ┃  ┗ auth_repository.dart
       ┃  ┃    import '../entities/user.dart';
       ┃  ┃    
       ┃  ┃    abstract class AuthRepository {
       ┃  ┃      Future<void> register(User user);
       ┃  ┃    
       ┃  ┃      Future<User?> login(String username, String password);
       ┃  ┃    }

       ┃  ┗ entities
       ┃     ┗ user.dart
       ┃       class User {
       ┃         final String id;
       ┃         final String name;
       ┃         final String username;
       ┃         final String password;
       ┃         final String createdAt;
       ┃       
       ┃         const User({
       ┃           required this.id,
       ┃           required this.name,
       ┃           required this.username,
       ┃           required this.password,
       ┃           required this.createdAt,
       ┃         });
       ┃       }

       ┗ data
          ┣ repositories
          ┃  ┗ auth_repository_impl.dart
          ┃    import '../../domain/entities/user.dart';
          ┃    import '../../domain/repositories/auth_repository.dart';
          ┃    import '../datasources/auth_local_datasource.dart';
          ┃    import '../models/user_model.dart';
          ┃    
          ┃    class AuthRepositoryImpl implements AuthRepository {
          ┃      final AuthLocalDataSource localDataSource;
          ┃    
          ┃      AuthRepositoryImpl(this.localDataSource);
          ┃    
          ┃      @override
          ┃      Future<void> register(User user) async {
          ┃        await localDataSource.registerUser(
          ┃          UserModel(
          ┃            id: user.id,
          ┃            name: user.name,
          ┃            username: user.username,
          ┃            password: user.password,
          ┃            createdAt: user.createdAt,
          ┃          ),
          ┃        );
          ┃      }
          ┃    
          ┃      @override
          ┃      Future<User?> login(String username, String password) async {
          ┃        return localDataSource.loginUser(username, password);
          ┃      }
          ┃    }

          ┣ models
          ┃  ┗ user_model.dart
          ┃    import '../../domain/entities/user.dart';
          ┃    
          ┃    class UserModel extends User {
          ┃      const UserModel({
          ┃        required super.id,
          ┃        required super.name,
          ┃        required super.username,
          ┃        required super.password,
          ┃        required super.createdAt,
          ┃      });
          ┃    
          ┃      factory UserModel.fromMap(Map<String, dynamic> map) {
          ┃        return UserModel(
          ┃          id: map['id'],
          ┃          name: map['name'],
          ┃          username: map['username'],
          ┃          password: map['password'],
          ┃          createdAt: map['created_at'],
          ┃        );
          ┃      }
          ┃    
          ┃      Map<String, dynamic> toMap() {
          ┃        return {
          ┃          'id': id,
          ┃          'name': name,
          ┃          'username': username,
          ┃          'password': password,
          ┃          'created_at': createdAt,
          ┃        };
          ┃      }
          ┃    }

          ┗ datasources
             ┗ auth_local_datasource.dart
               import '../../../../core/database/database_helper.dart';
               import '../models/user_model.dart';
               
               class AuthLocalDataSource {
                 final dbHelper = DatabaseHelper.instance;
               
                 Future<void> registerUser(UserModel user) async {
                   final db = await dbHelper.database;
               
                   await db.insert('users', user.toMap());
                 }
               
                 Future<UserModel?> loginUser(String username, String password) async {
                   final db = await dbHelper.database;
               
                   final result = await db.query(
                     'users',
                     where: 'username = ? AND password = ?',
                     whereArgs: [username, password],
                     limit: 1,
                   );
               
                   if (result.isEmpty) return null;
               
                   return UserModel.fromMap(result.first);
                 }
               
                 Future<UserModel?> getUserById(String id) async {
                   final db = await dbHelper.database;
               
                   final result = await db.query(
                     'users',
                     where: 'id = ?',
                     whereArgs: [id],
                     limit: 1,
                   );
               
                   if (result.isEmpty) return null;
               
                   return UserModel.fromMap(result.first);
                 }
               
                 Future<UserModel?> getUserByUsername(String username) async {
                   final db = await dbHelper.database;
               
                   final result = await db.query(
                     'users',
                     where: 'username = ?',
                     whereArgs: [username],
                     limit: 1,
                   );
               
                   if (result.isEmpty) return null;
               
                   return UserModel.fromMap(result.first);
                 }
               }



 https://chatgpt.com/share/6a3022cc-7704-83ec-818d-0b9b673c95f7