# Fiorenzo — Luxury Fashion E-Commerce Mobile App (Flutter)

Fiorenzo is a cross-platform mobile shopping app built for a luxury fashion retail concept, focused on a smooth, high-end user experience with offline resilience and native device integration.

## UI/UX
- Built following Material Design 3 guidelines — clean spacing, editorial typography, dark/light theme support
- Over 14 custom screens: landing/browse, product detail, account, cart, checkout, and more
- Simple, familiar login flow using phone/email instead of complex reference codes

## Architecture
Feature-first layered structure, separating UI, business logic, and data access:

```
lib/
├── src/
│   ├── features/          # Auth, Catalog, Cart modules
│   │   ├── presentation/  # Screens and widgets
│   │   ├── domain/        # Business logic and models
│   │   └── data/          # Local and remote data sources
│   └── core/               # Shared utilities, routing, theming
```

**Stack:**
- Flutter & Dart
- Provider (v6.1.2) for state management — `AuthProvider`, `CartProvider`, `ProductProvider`
- Dio for HTTP networking, connecting to a Laravel REST API backend

## Offline Support & Device Features
- SQLite (SQFLite) for local caching of product data, so the app loads instantly even offline
- SharedPreferences for saving theme and lightweight session data
- Live connectivity detection, geolocation for shipping/billing, camera access for profile photos, and battery-aware background behavior

## Running Locally

**Prerequisites:** Flutter SDK (latest stable), Android Studio or Xcode

```bash
git clone https://github.com/Demian1223/fiorenzo_flutter-MAD2.git
cd fiorenzo_flutter-MAD2
flutter pub get
flutter run
```

---
*Built as an individual coursework project (Mobile App Development module).*
