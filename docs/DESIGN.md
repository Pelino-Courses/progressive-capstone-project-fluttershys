# DESIGN.md — SukaApp Mini-Capstone Part A–D

## Project Name
SukaApp — *Your Market, In Your Hands*

## Purpose
This document captures the design mockups and UI structure for the Mini-Capstone integration milestone. It documents 3–5 screen designs created in Google Stitch, and describes how each screen supports the Flutter widgets, navigation, forms, and data model requirements for Parts A–D.

## Mockup Screens

### 1. Splash + Language Selection
- Purpose: Welcome users and let them choose Kinyarwanda or English before entering the marketplace.
- Layout:
  - Full-screen branded splash image with SukaApp logo.
  - Two large buttons: "Kinyarwanda" and "English".
  - Small progress indicator or app slogan.
- Design details:
  - Material 3 elevated buttons.
  - `Text` widgets with large `displayLarge` typography.
  - Simple `Column` centered inside `SafeArea`.
- Assignment alignment:
  - Part A: uses strings and null-safe variables for selected language.
  - Part D: initial route / named route to the home screen.

### 2. Home Marketplace
- Purpose: Main browsing screen for buyers to search listings, filter by category, and open product details.
- Layout:
  - Top app bar with app title, search icon, and a menu button.
  - Category chips row with categories such as Vegetables, Meat, Clothing, and Electronics.
  - Scrollable product cards grid or vertical list.
  - Bottom navigation allowing `Home`, `Orders`, and `Profile`.
- Design details:
  - `AppBar`, `TabBar`-style chips, `ListView.builder` or `GridView.builder`.
  - Custom `ProductCard` widget showing image, title, price, availability badge, and rating.
  - Low-data mode uses icon placeholders and compressed image thumbnails.
- Assignment alignment:
  - Part B: uses `Product` model class, collections of products, and custom widgets.
  - Part C: Material 3 theming with cards, color scheme, and responsive layout.

### 3. Product Detail + Reserve
- Purpose: Show item details, seller rating, and allow buyers to reserve or add to cart.
- Layout:
  - Large product image at top.
  - Item name, price, quantity status, seller name, and rating chips.
  - Reserve button and `Description` section.
  - Option to choose quantity and buyer note.
- Design details:
  - `Column` with `Padding`, `Card`, and `ElevatedButton`.
  - `RatingBar` or custom star widget for trust indicators.
  - `TextButton` for additional seller details.
- Assignment alignment:
  - Part D: data passed via named route arguments to detail screen.
  - Part A: functions to calculate total cost and availability status.

### 4. Checkout / MoMo Payment
- Purpose: Complete a purchase using MoMo payment flow and validate buyer information.
- Layout:
  - Order summary card with item, price, quantity, and delivery method.
  - Payment form fields: phone number, amount, payment method.
  - Submit button with validation state.
  - Confirmation message or dialog after payment.
- Design details:
  - `Form` widget with `TextFormField`, validators, and `AutovalidateMode.onUserInteraction`.
  - `SnackBar` or `AlertDialog` after successful submission.
  - `ElevatedButton` disabled until the form is valid.
- Assignment alignment:
  - Part D: form validation, `GlobalKey<FormState>`, and input validation rules.
  - Part B: async `Future` to simulate MoMo payment and show loading state.

### 5. Seller Dashboard / Profile
- Purpose: Allow sellers to manage listings, view ratings, and update inventory.
- Layout:
  - Seller profile header with name, rating, and verified status.
  - Quick action cards for `Add Listing`, `Update Stock`, `View Orders`.
  - Inventory list with edit buttons.
- Design details:
  - `ExpansionTile` or `ListTile` for existing products.
  - `FloatingActionButton` to add new listing.
  - `Form` for listing creation with category, price, quantity, and photo.
- Assignment alignment:
  - Part B: seller and product classes, plus inheritance or mixins if needed for shared behavior.
  - Part C: custom widgets and responsive layout for both buyer and seller roles.

## Visual and UI Design Approach
- Material Design 3 with a warm primary palette inspired by local markets.
- Bold card surfaces, rounded corners, and accessible touch targets.
- Strong use of icons, color-coded availability badges, and readable Kinyarwanda text.
- Low-data mode design prioritized: text-first content, lightweight icons, optional image loading.

## Navigation Structure
- Named routes for all main screens:
  - `/` — splash/language selection
  - `/home` — marketplace home
  - `/product` — product detail
  - `/checkout` — payment
  - `/dashboard` — seller dashboard
- Data passing via route arguments and simple `Map<String, dynamic>` payloads.

## Design Assets
- Google Stitch mockups were prepared for the five screens above.
- Supporting wireframes are available in `sukaapp_wireframes.html`.
- Final mockups are committed to the repository as part of the project documentation.

## Next Steps
1. Convert the mockup layouts into Flutter screens.
2. Build the `Product`, `Seller`, and `Order` data models.
3. Implement named route navigation and argument passing.
4. Add form validation to the checkout and seller listing forms.
5. Test on an Android emulated device for low-data and small-screen behavior.
