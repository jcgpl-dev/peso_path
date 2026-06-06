PesoPath — Project Brief
What it is
PesoPath is an offline-first Android budgeting app built with Flutter and Dart, targeting Filipino students who need to track their allowance and daily expenses. It works fully without internet, stores all data locally using SQLite, and uses the BLoC pattern for state management.
Tech Stack

Framework: Flutter (Dart)
State management: BLoC
Local database: SQLite (via sqflite package)
Platform: Android (primary), potentially cross-platform later

The Mascot — Peso
A common shrew character named Peso. Chosen because shrews are naturally hyperactive, always hungry, hoard things, and are tiny but bold — all traits that map perfectly to a student managing a tight allowance. Peso reacts emotionally to the user's budget state:

Happy/holding a coin — when under budget
Worried with ?! — when nearing the spending limit
Celebrating with stars — when a savings goal is reached

Design direction: Pokemon-style clean vector illustration, warm brown fur, chubby friendly proportions, holding a single ₱ gold coin. No outfit, no accessories beyond the coin. Pure white background for the full mascot, golden-yellow (#F5A623) background for the app icon.

App Name
PesoPath — clean, memorable, bilingual-friendly, and directly tied to the Philippine peso.

Color Palette

Coin primary: #F5A623 (warm golden orange)
Coin light: #FDD87A
Coin dark: #E07B00
Warm background: #FFF8E7
Ink/text: #2D2A22
Income green: #4CAF50
Expense red: #E53935

Yellow-orange was chosen because it's the color of a coin, rare in finance apps (most use blue or green), and communicates optimism and energy — fitting for a student-targeted fun app.

Target User
Filipino college/senior high students managing their weekly or monthly allowance. The app uses localized details — ₱ peso sign throughout, Filipino expense categories (food, load, transport, school), and example entries like Jollibee, load, and allowance.

Core Features (planned)

Set a monthly/weekly budget
Log expenses with category, amount, and note
Log income (allowance deposits)
View remaining budget with a visual progress bar
Transaction history list
Peso mascot reactions based on budget state
Expense categories: food, transport, school, load, miscellaneous
Fully offline — no login, no account required

UI Design Direction

Warm off-white background (#FFF8E7) — not pure white, feels handmade
Coin orange as the primary action color (buttons, cards, progress bar)
Green/red strictly reserved for income vs expense — never decorative
Category pills instead of dropdowns — faster tapping on mobile
Peso appears on the add expense screen with a contextual nudge message in first person ("Don't forget to log your merienda!")
Filipino-localized entries and currency throughout
Feels human-made, not AI-generated — warm colors, personality-driven, opinionated layout

Two key screens designed so far:
Home screen — monthly budget card in coin orange with progress bar, income vs spent stat cards, and a recent transactions list.
Add expense screen — amount input, category pills, note field, and a Peso speech bubble giving a friendly reminder. Save button in coin orange.

What makes it stand out

Mascot with emotional states tied to real budget data
Filipino-first design (₱, local expense names, student context)
Offline-first — works in low-connectivity environments, relevant to the Philippine context
Fun and playful tone in a category (finance apps) that is usually cold and corporate
Inspired by Bryllim's Tarsi app concept but completely original character and direction

Gemini Prompts for Assets
Mascot:

"Create a mascot character illustration of a common shrew for a Filipino student budgeting app called PesoPath. Style: clean vector-style, flat shading with subtle cel-shading, thick clean outlines, friendly and slightly chubby proportions similar to Pokemon. Warm brown fur, holding a small golden ₱ coin in both paws, happy excited expression, standing upright. Pure white background, 1024x1024px, no text, no watermarks, no ground shadows."

App icon:

"App icon for a budgeting app called PesoPath. Cute chubby shrew face front-facing, cropped to head and shoulders, centered on warm golden-yellow background (#F5A623). Shrew holds a small ₱ coin. Rounded square composition like an iOS app icon. Flat vector style, clean thick outlines, no gradients, no text. 1024x1024px."

lib/
│
├── core/ # Shared utilities, constants, themes
│ ├── theme/ # App colors (#FFF8E7, #F5A623), styles
│ ├── errors/ # Failure & Exception classes
│ └── database/ # SQLite helper open/migration scripts
│
├── features/
│ ├── budget/ # Feature: Core Budget & Tracking
│ │ ├── domain/
│ │ │ ├── entities/ # Expense, Income, Budget
│ │ │ ├── repositories/ # budget_repository.dart (Abstract)
│ │ │ └── usecases/ # add_expense.dart, get_home_data.dart
│ │ ├── data/
│ │ │ ├── datasources/ # budget_local_datasource.dart (SQLite)
│ │ │ ├── models/ # expense_model.dart, income_model.dart
│ │ │ └── repositories/ # budget_repository_impl.dart
│ │ └── presentation/
│ │ ├── blocs/ # budget_bloc.dart, budget_event.dart, budget_state.dart
│ │ ├── screens/ # home_screen.dart, add_expense_screen.dart
│ │ └── widgets/ # progress_bar.dart, category_pill.dart
│ │
│ └── mascot/ # Feature: Peso's Reactions & Nudges
│ ├── domain/ # Logic to determine Peso's mood based on % spent
│ └── presentation/ # PesoSpeechBubble widget, mascot animations
│
└── main.dart # Dependency injection setup & app entry point
