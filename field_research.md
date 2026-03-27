# Field Research Report — Marketplace App
**Date:** March 24, 2026  
**Location:** Kigali, Rwanda (Kimironko Market & Surrounding Area)  
**Research Lead:** Team MarketConnect  

## Overview

This field research documents real observations and interviews conducted independently by each team member.

## Member 1 — Research Session
**Timestamp:** 2026-03-23 | 08:30 – 09:00 AM  
**Location:** Kimironko Market, Section A (Vegetables & Fruits)

### Observations
1. **Friction Point 1 — Price Discovery**  
   A customer spent 12 minutes walking between 6 different stalls asking for tomato prices before buying.  
   > *"I don't know if the price is good — I have to walk around first before I find where it's fair."*

2. **Friction Point 2 -Payment Methods**  
   Vendors reject mobile money under 2,000 RWF because of perceived transaction delay.  
   > *"MoMo is good but it takes too long when I have many customers."*  
  

3. **Friction Point 3 — Stock Visibility**  
   Buyers walked 20 minutes to find ripe avocados only to find them sold out.  
   > *"I was told there were ripe ones in the back — I came for nothing."*  
  

4. **Friction Point 4 — Advertising**  
   Sellers use handwritten cardboard signs. No digital presence at all.  
   > *"My phone doesn't work for business — that's not how I earn money."*  
   

5. **Friction Point 5 — Wait Times**  
   Lines form at popular stalls while adjacent stalls sit empty.  
   > *"This person is always busy but I think people don't know the others also have good products."*  


## Member 2 — Research Session
**Timestamp:** 2026-03-23 | 09:15 – 09:45 AM  
**Location:** Nyamirambo Roadside Vendors

### Observations
1. **Friction Point 1 — No Address/Location**  
   A vendor couldn't explain their location clearly over the phone to a returning customer.  
   > *"I tell them 'near the church' but they don't find it. Google Maps doesn't work well here."*  

2. **Friction Point 2 — No Pre-ordering**  
   Customers unable to reserve items for later pickup.  
   > *"I was coming at 9am but the goods were gone. Taken by my neighbor."*  

3. **Friction Point 3 — Kutabona reviews (No Ratings/Trust)**  
   New customers afraid to buy from unfamiliar vendors.  
   > *"I don't know if they're good. I need to know what people who've bought from them say."*  
   

4. **Friction Point 4 — Communication Loss**  
   Sellers don't have a way to notify loyal customers of new stock or specials.  
   > *"When I have new items, I hope they come — but who do I tell?"*  
  

5. **Friction Point 5 — Data Usage**  
   Both vendors and buyers avoid apps due to mobile data cost fears.  
   > *"All apps use too much data — I avoid using them for business."*  
   

## Member 3 — Research Session
**Timestamp:** 2026-03-24 | 10:00 – 10:30 AM  
**Location:** Remera Trading Center

### Observations
1. **Friction Point 1 — Restocking Chaos**  
   Small vendors don't know when their supplier will deliver next.  
   > *"My supplier comes whenever — I never know the exact day."*  

2. **Friction Point 2 — No Delivery System**  
   Customers with disabilities or far from market have no option to get goods delivered.  
   > *"Nobody brings things to my home. I have to come every day."*  

3. **Friction Point 3 — Price changes**  
   Prices change seasonally but buyers have no way to track this.  
   > *"Avocado is 300 RWF in season, 800 in dry season — I don't know when to buy."*  


4. **Friction Point 4 — Unsold Stock**  
   End-of-day unsold perishables go to waste because sellers can't notify potential buyers.  
   > *"By 6pm, things I couldn't sell — I go and leave them to waste."
"*  

5. **Friction Point 5 — Counterfeit Goods**  
   Buyers worry about fake cooking oil and other branded goods.  
   > *"I don't know if the cooking oil is real. I need to buy from someone I trust."*  
   

## Team Synthesis 

### Problem Selection Rationale
After analyzing all findings, the team identified **3 recurring themes** across all 15 friction points:

| Theme | Frequency | Severity |
|-------|-----------|----------|
| Price/product visibility | 7/15 points | High — causes wasted trips |
| Trust & reliability | 5/15 points | High — blocks new transactions |
| Communication between buyer-seller | 3/15 points | Medium — limits repeat business |

### Core Problem Statement 
> *"Buyers in Kigali's markets waste time, money, and trust because they cannot see products, prices, or reliable sellers before making the trip, while sellers lose customers due to limited ways to advertise and communicate."*

### Real-World Constraints Mapped (from Progressive Project Guide)
1. **Connectivity Constraint** — Many vendors operate in areas with intermittent internet; app must function with low data usage and offline caching.
2. **Device Constraint** — Target users have entry-level Android devices (2–3GB RAM); Flutter app must be lightweight and performant.
3. **Payment Constraint** — Primary payment method is MTN MoMo / Airtel Money; app must integrate with local mobile money APIs or simulate integration.

* This data is authentic, collected in-field by team members.*
