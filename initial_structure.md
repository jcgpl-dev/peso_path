lib
 ┣ assets
 ┃ ┣ icons
 ┃ ┃ ┣ ic-peso-path-mipmap-hdpi.png
 ┃ ┃ ┣ ic-peso-path-mipmap-mdpi.png
 ┃ ┃ ┣ ic-peso-path-mipmap-xhdpi.png
 ┃ ┃ ┣ ic-peso-path-mipmap-xxhdpi.png
 ┃ ┃ ┣ ic-peso-path-mipmap-xxxhdpi.png
 ┃ ┃ ┗ ic-peso-path.png
 ┃ ┗ images
 ┃ ┃ ┗ card-bg.png
 ┣ core
 ┃ ┣ constants
 ┃ ┣ database
 ┃ ┃ ┗ database_helper.dart
 ┃ ┣ router
 ┃ ┣ services
 ┃ ┣ theme
 ┃ ┃ ┣ app_colors.dart
 ┃ ┃ ┣ app_text_styles.dart
 ┃ ┃ ┗ app_theme.dart
 ┃ ┗ utils
 ┣ features
 ┃ ┗ auth
 ┃ ┃ ┣ data
 ┃ ┃ ┃ ┣ datasources
 ┃ ┃ ┃ ┃ ┗ auth_local_datasource.dart
 ┃ ┃ ┃ ┣ models
 ┃ ┃ ┃ ┃ ┗ user_model.dart
 ┃ ┃ ┃ ┗ repositories
 ┃ ┃ ┃ ┃ ┗ auth_repository_impl.dart
 ┃ ┃ ┣ domain
 ┃ ┃ ┃ ┣ entities
 ┃ ┃ ┃ ┃ ┗ user.dart
 ┃ ┃ ┃ ┣ repositories
 ┃ ┃ ┃ ┃ ┗ auth_repository.dart
 ┃ ┃ ┃ ┗ usecases
 ┃ ┃ ┃ ┃ ┣ check_session.dart
 ┃ ┃ ┃ ┃ ┣ login_user.dart
 ┃ ┃ ┃ ┃ ┣ logout_user.dart
 ┃ ┃ ┃ ┃ ┗ register_user.dart
 ┃ ┃ ┗ presentation
 ┃ ┃ ┃ ┣ bloc
 ┃ ┃ ┃ ┃ ┣ auth_bloc.dart
 ┃ ┃ ┃ ┃ ┣ auth_event.dart
 ┃ ┃ ┃ ┃ ┗ auth_state.dart
 ┃ ┃ ┃ ┣ pages
 ┃ ┃ ┃ ┃ ┣ login_page.dart
 ┃ ┃ ┃ ┃ ┣ register_page.dart
 ┃ ┃ ┃ ┃ ┗ splash_page.dart
 ┃ ┃ ┃ ┗ widgets
 ┣ injection
 ┃ ┗ injection.dart
 ┣ shared
 ┗ main.dart