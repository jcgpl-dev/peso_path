# Peso Path

Peso Path is an offline-first personal budgeting and expense tracking mobile application built with Flutter. It helps users manage their finances by tracking expenses, monitoring budgets, setting savings goals, and calculating a safe daily spending limit based on available funds.

The project is designed with scalability and maintainability in mind using Clean Architecture, Riverpod, and SQLite.

---

## Features

### Authentication

* Local user registration
* Local user login
* Session management

### Budget Management

* Monthly allowance setup
* Fixed monthly expenses
* Automatic budget calculations
* Daily spending limit calculation

### Expense Tracking

* Add expenses
* Edit expenses
* Delete expenses
* Categorize transactions
* Transaction history

### Savings Goals

* Create savings goals
* Track goal progress
* Monitor target completion

### Dashboard

* Monthly budget overview
* Expense summary
* Remaining budget
* Daily spending recommendation
* Savings progress

---

## Core Concept

Most budgeting applications focus on showing how much money remains.

Peso Path focuses on helping users answer a more practical question:

> How much can I safely spend today and still stay within my monthly budget?

The application calculates a daily spending allowance using:

```text
Monthly Allowance
- Fixed Expenses
- Savings Allocation
= Available Budget

Available Budget
÷ Remaining Days
= Daily Spending Limit
```

---

## Tech Stack

### Frontend

* Flutter
* Dart

### Local Storage

* SQLite

### Architecture

* Clean Architecture
* Feature-First Structure
* Repository Pattern
* Dependency Injection

### State Management

* Riverpod

---

## Project Structure

```text
lib/
│
├── core/
│   ├── constants/
│   ├── database/
│   ├── error/
│   ├── services/
│   ├── usecases/
│   └── utils/
│
├── features/
│   ├── auth/
│   ├── budgeting/
│   ├── transaction/
│   ├── savings/
│   └── settings/
│
├── shared/
│   ├── themes/
│   ├── widgets/
│   └── helpers/
│
└── main.dart
```

Each feature follows Clean Architecture:

```text
feature/
│
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
└── presentation/
    ├── pages/
    ├── providers/
    └── widgets/
```

---

## Database Schema

### users

```sql
id INTEGER PRIMARY KEY
name TEXT
username TEXT
password TEXT
created_at TEXT
```

### wallets

```sql
id INTEGER PRIMARY KEY
name TEXT
balance REAL
created_at TEXT
```

### categories

```sql
id INTEGER PRIMARY KEY
name TEXT
icon TEXT
type TEXT
```

### transactions

```sql
id INTEGER PRIMARY KEY
wallet_id INTEGER
category_id INTEGER
amount REAL
note TEXT
type TEXT
date TEXT
created_at TEXT
```

### budgets

```sql
id INTEGER PRIMARY KEY
monthly_allowance REAL
month INTEGER
year INTEGER
```

### fixed_expenses

```sql
id INTEGER PRIMARY KEY
name TEXT
amount REAL
```

### savings_goals

```sql
id INTEGER PRIMARY KEY
name TEXT
target_amount REAL
current_amount REAL
deadline TEXT
```

---

## Design Principles

* Offline-first
* Simple and intuitive user experience
* Fast and lightweight performance
* Scalable architecture
* Maintainable codebase
* Easy future feature integration
* Separation of concerns

---

## Planned Screens

### Authentication

* Splash Screen
* Login Screen
* Register Screen

### Main Application

* Dashboard
* Transactions
* Savings Goals
* Settings

### Modals

* Add Expense
* Add Income
* Add Savings Goal

---

## Future Roadmap

### Version 1.0

* Authentication
* Expense Tracking
* Budget Management
* Savings Goals
* Dashboard

### Version 1.5

* Recurring Expenses
* Recurring Income
* Budget Notifications
* Monthly Reports

### Version 2.0

* Multiple Wallets
* Financial Analytics
* Spending Trends
* Category Insights

### Version 3.0

* Cloud Backup
* Cross-Device Synchronization
* Family Budgeting
* Data Export

---

## Theme

### Primary Color

```text
#16A34A
```

### Secondary Color

```text
#22C55E
```

The green palette represents financial growth, savings, stability, and healthy spending habits.

---

## Development Status

Currently under active development.

---

## License

This project is developed for educational purposes and personal finance management.
