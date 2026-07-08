---

## 📱 README 2: For `fiorenzo_flutter-MAD2`

Copy and paste this raw markdown into the `README.md` file of your **Flutter mobile application** repository:

```markdown
# Fiorenzo Luxury Boutique — Cross-Platform Mobile Application (MAD2)

Fiorenzo is a premium, client-facing mobile application designed for cross-platform efficiency and high-fidelity interaction[cite: 7]. Engineered specifically around the user-experience expectations of the luxury consumer market, the platform delivers fluid interactions, state persistence, and adaptive device hardware operations[cite: 7].

---

## 🎨 UI/UX Strategy & Human-Centric Design
The interface layout relies entirely on a modern, immersive aesthetic optimized through extensive product requirement planning[cite: 7]:
* **Material Design 3 Guidelines:** Structured utilizing premium spacing conventions, editorial typography treatments, and unified dark/light theme configurations[cite: 7].
* **Deep Screen Mapping:** Features **over 14 custom-designed view modules** including curated landing grids, item detail showcases, user account portfolios, dynamic shopping bags, and clear, interactive checkout flows[cite: 7].
* **Scannable Layouts:** Avoids complex reference tags in customer interactions, centering access layouts around familiar, human identifiers like phone and email credentials.

---

## 🏗️ Technical Architecture & State Design

The application scales using a robust **Feature-First Layered Architecture**, dividing presentation layers cleanly away from domain models and API data communication lines[cite: 7].

lib/
│
├── src/
│   ├── features/          # Encapsulated application domains (Auth, Catalog, Cart)
│   │   ├── presentation/  # UI Views, Screens, and custom Widget assets
│   │   ├── domain/        # Business Logic entities and data models
│   │   └── data/          # Local & Remote data sources / API contracts
│   │
│   └── core/              # Shared utility helpers, routing, and themes


### Key Engineering Frameworks:
* **UI Engine:** Flutter SDK & Dart Language[cite: 7].
* **State Management:** **Provider (v6.1.2)** architecture running centralized `AuthProvider`, `CartProvider`, and `ProductProvider` modules to drive synchronous view updates[cite: 7].
* **Http Networking:** **Dio Client** handling optimized JSON asynchronous payloads to connect cleanly with the Laravel REST API backend[cite: 7].

---

## 📱 Hardware Integration & Offline Resilience

### 1. Smart Local Device Caching
* **SQLite Database Engine (SQFLite):** Caches live product inventory arrays directly on-device to enable immediate UI loading states[cite: 7].
* **SharedPreferences:** Persists system theme choices and lightweight authentication session data across app restarts[cite: 7].

### 2. Native Device Capabilities
* **Connectivity Awareness:** Continuously evaluates active device internet status, adapting UI elements dynamically when connections drop[cite: 7].
* **Geolocation Mapping:** Captures user positions to automatically map precise physical billing and shipping coordinates[cite: 7].
* **Camera Access:** Integrates device camera hooks securely for immediate profile image updates[cite: 7].
* **Battery-Level Adaptation:** Monitors system resource levels to optimize background asset polling under low-power states[cite: 7].

---

## ⚙️ Mobile Compilation & Local Execution

### Prerequisites
* Flutter SDK (Latest Stable Channel)
* Android Studio / Xcode (for device emulators)

### Step-by-Step Build
1. **Clone the project:**
   ```bash
   git clone [https://github.com/Demian1233/fiorenzo_flutter-MAD2.git](https://github.com/Demian1233/fiorenzo_flutter-MAD2.git)
   cd fiorenzo_flutter-MAD2


# mad2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
