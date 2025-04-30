# product_catelog_app
 product_catelog_app

Advanced Product Catalog App
============================

A Flutter-based product catalog app with robust architecture, offline support, theme switching, and smooth user experience. Built using GetX, Hive, and Dio.

------------------------------
FEATURES
------------------------------

Core Features:
- Fetch products from REST API
- Offline caching using Hive
- Paginated product listing
- Search with 500ms debounce
- Favorite/unfavorite products (persisted locally)
- Product detail view
- Pull-to-refresh functionality
- Offline mode fallback

Architecture & Technical Features:
- Clean Architecture (Data → Domain → Presentation)
- GetX for state management & routing
- Hive for local persistence
- Dio for API integration
- Fully null-safe

Bonus Features:
- Dark mode with animated theme switch
- Circular reveal animation on theme toggle
- Custom reusable widgets (e.g., rating stars, shimmer loader)
- CI/CD-ready structure (GitHub Actions scaffolded)
- Graceful error handling & offline support

------------------------------
PROJECT STRUCTURE
------------------------------

lib/
├── controller/         - GetX controllers (state logic)
├── core/               - Theme, constants, utils
├── data/               - Models, genrated class
├── domain/             - Hive (Cache),
├── screen/             - UI layer: screens,
├── widgets/            - Common Widgets
└── main.dart

------------------------------
SETUP & RUN
------------------------------

Requirements:
- Flutter 3.x (null safety)
- Dart >= 2.17

Steps:
1. git clone https://github.com/Uday-bonhq/product_catelog_app.git
2. cd product_catalog_app
3. flutter pub get
4. flutter run

Run Tests:
flutter test

------------------------------
STATE MANAGEMENT
------------------------------

Using GetX for:
- Dependency Injection
- Theme Management
- State Updates
- Offline data save and retrieve

Example:
Get.put(ProductController());
Get.put(ThemeController());

------------------------------
CACHING STRATEGY
------------------------------

- Products & Favorites: Hive
- Cart: Hive (with quantity tracking)
- Theme Mode: Hive (persisted across sessions)
- Offline fallback: Products load from cache if no connection

------------------------------
API INTEGRATION
------------------------------

- Dio for HTTP calls
- Interceptors used with dio_http_formatter
- Errors handled via GetX reactive UI

------------------------------
ASSUMPTIONS
------------------------------

- API supports pagination via ?page= and ?limit=
- Product IDs are unique integers
- Hive is used for caching due to speed and simplicity

------------------------------
UI/UX NOTES
------------------------------

- Shimmer placeholders with skeletonizer
- Cached images with cached_network_image
- Responsive design
- Cupertino-style switch with light/dark icons
- Ripple reveal animation when toggling theme

------------------------------
PACKAGES USED
------------------------------

get                  - State management, routing, DI
dio                  - REST API integration
hive                 - Local data persistence
hive_flutter         - Hive integration with Flutter
connectivity_plus    - Network monitoring
pull_to_refresh      - Pull-to-refresh UI
skeletonizer         - Shimmer loading effects
dio_http_formatter   - Clean API log formatting
carousel_slider      - Image carousels
timeago              - Human-readable time display
cached_network_image - Efficient image caching
flutter_staggered_animations - List animations
toast                - Simple toast messages


------------------------------
LICENSE
------------------------------

MIT License. Free to use and contribute.

------------------------------
AUTHOR
------------------------------

Created by: UDAY SINGH
GitHub: https://github.com/udaysingh7737
