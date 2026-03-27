# App Concept Document — **SukaApp** 🛒
*"Suka" is the word tha represent Marketplace*

**Version:** 1.0  
**Date:** March 23, 2026  
**Team:** MarketConnect  

## 1. App Overview

**App Name:** SukaApp  
**Tagline:** *"Your market, in your hands*  
**Platform:** Flutter (Android-first, iOS compatible)  
**Target Market:** Kigali, Rwanda — expandable to East Africa  

## 2. Problem-Solution Fit

### The Problem
Buyers in Kigali's informal markets waste significant time and resources due to lack of product visibility, price transparency, and seller trustworthiness indicators before making a physical trip. Sellers simultaneously lose revenue because they cannot communicate stock updates or attract new customers digitally.

### The Solution
SukaApp creates a **lightweight, offline-capable digital marketplace** connecting Kigali's informal vendors with local buyers. Buyers can browse real listings, see prices, read seller ratings, and pre-order. All before leaving home. Sellers get a simple listing tool optimized for low-data, low-literacy use.

### Why SukaApp is Unique vs. Existing Solutions
| Feature | SukaApp | WhatsApp Groups | Jumia | Facebook Marketplace |
|---------|---------|-----------------|-------|----------------------|
| Offline-capable | ✅ | ❌ | ❌ | ❌ |
| MoMo payment integration | ✅ | ❌ | Partial | ❌ |
| Kinyarwanda UI | ✅ | N/A | ❌ | ❌ |
| Vendor trust ratings | ✅ | ❌ | ✅ | Partial |
| Informal market focused | ✅ | ✅ | ❌ | Partial |
| Low data mode | ✅ | Partial | ❌ | ❌ |


## 3. Target Users

### Primary Users — Buyers 
- Age: 18–45
- Location: Kigali suburbs (Kimironko, Nyamirambo, Remera, Gisozi)
- Device: Android, entry-level (Samsung Galaxy A-series, Tecno)
- Data: Prepaid MTN/Airtel bundles
- Tech literacy: Moderate — uses WhatsApp, MoMo daily

### Secondary Users — Sellers
- Age: 25–60
- Type: Informal market vendors, small shops, home-based sellers
- Device: Basic Android smartphone
- Pain level: HIGH currently invisible to digital buyers
- Tech literacy: Low-moderate, may need simplified on boarding


## 4. Core MVP Features

### Feature 1 - Product Discovery
**Problem it solves:** Buyers walk 20+ minutes only to find items unavailable  
**Implementation:** Sellers list items with photo (camera capture), price, and quantity. Buyers browse by category ( Vegetables, Meat, Clothing, etc.)  
**Flutter widgets used:** `GridView`, `Card`, `SearchDelegate`, `Image.file`  
**Constraint addressed:** Low data mode — images compressed to <50KB, text-first loading

### Feature 2 — Live Pricing & Availability
**Problem it solves:** Price capacity and wasted trips for out-of-stock items  
**Implementation:** Sellers update stock/price with one tap. Color-coded availability: 🟢 Available, 🟡 Low, 🔴 Out  
**Flutter widgets used:** `Switch`, `Slider`, `Badge`, `StreamBuilder`  
**Constraint addressed:** Entry-level device performance — minimal animations, no heavy real-time sync

### Feature 3 — Seller Trust Ratings
**Problem it solves:** New buyers afraid to transact with unknown vendors  
**Implementation:** After each purchase, buyer rates seller (1–5 stars + optional text). Profile shows verified badge for sellers with 10+ ratings above 4.0  
**Flutter widgets used:** `RatingBar` (package), `CircleAvatar`, `Chip`  
**Constraint addressed:** Trust constraint — visible social proof replaces in-person reputation

### Feature 4 — Pre-ordering & Reservation
**Problem it solves:** Goods sold out before buyer arrives  
**Implementation:** Buyer taps"Reserve" seller gets notification, item held for 2 hours. Simple confirm/decline flow.  
**Flutter widgets used:** `ElevatedButton`, `Dialog`, `local_notifications` package, `CountdownTimer`  
**Constraint addressed:** Communication constraint — replaces informal phone calls

### Feature 5 — Mobile Money Payment
**Problem it solves:** Cash-only friction and transaction recording  
**Implementation:** In-app payment initiation via MTN MoMo API simulation (Phase 1) → real integration (Phase 3). Generates digital receipt.  
**Flutter widgets used:** `TextField`, `Form`, `SnackBar`, `receipt` custom widget  
**Constraint addressed:** Payment infrastructure constraint — leverages existing MoMo behavior


## 5. Constraint Integration Plan

| Constraint | How SukaApp Addresses It |
|-----------|--------------------------|
| **Connectivity** | Offline mode caches last-known listings using `Hive` local DB; syncs when connection restored |
| **Device Performance** | No heavy animations; lazy loading with `ListView.builder`; image compression on upload |
| **Payment** | MoMo integration via deep-link to MTN app; fallback to cash-on-delivery option |
| **Language** | Full Kinyarwanda UI with English toggle; icons used where literacy may be lower |
| **Screen Size** | Responsive layouts using `MediaQuery`; tested on 5-inch screens |


## 6. App Architecture 

```
SukaApp/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart        # Browse listings
│   │   ├── seller_dashboard.dart  # Seller management
│   │   ├── product_detail.dart    # Item view + reserve
│   │   ├── checkout_screen.dart   # MoMo payment
│   │   └── profile_screen.dart    # Ratings & history
│   ├── widgets/
│   │   ├── product_card.dart
│   │   ├── seller_badge.dart
│   │   └── rating_bar.dart
│   ├── models/
│   │   ├── product.dart
│   │   └── seller.dart
│   └── services/
│       ├── local_db_service.dart  # Hive offline
│       └── momo_service.dart      # Payment
```


## 7. Innovation Statement

SukaApp is **not** a copy of Jumia or Kilimall. Those platforms target formal retailers with high inventory and digital infrastructure. SukaApp specifically targets **informal market vendors**  the 80%+ of Kigali commerce that is offline today with tools designed for their reality: low data, basic phones, Kinyarwanda first, and MoMo payments. The trust rating system is specifically designed around Rwanda's existing "social vouching" culture, making digital trust feel as natural as asking a neighbor for a recommendation.


*This concept was developed by the team — it is not a copy of an existing product.*
