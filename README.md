# StaySafe – COVID-19 Safety Companion App

## Overview

StaySafe is a Flutter-based mobile application built during the COVID-19 pandemic to help users stay informed and “connected at a distance”.  
It combines WHO guidance, simple authentication, and device-to-device proximity features to support safer behaviour and awareness during outbreaks.

The app was originally developed as a learning/academic project and uses Firebase as a backend for authentication and data storage.

---

## Features

- **Onboarding & Education**
  - Swipe-through intro screens using WHO COVID-19 advice loaded from a local JSON asset (`who_corona_advice.json`).
  - Presents safety tips and recommended practices in a mobile-friendly format.

- **User Authentication**
  - Email/password sign-up and sign-in using Firebase Authentication.
  - Optional social sign-in via Facebook (`flutter_facebook_login`).
  - Basic form validation and error feedback on login/registration.

- **Country & Location Awareness**
  - Country picker for selecting the user’s country (via `country_pickers`).
  - Location access (via the `location` plugin) to support location-aware flows and potential regional behaviour.

- **Proximity / Nearby Device Support**
  - Integration with `nearby_connections` to allow peer-to-peer device discovery and communication over the local network.
  - Intended for use cases such as “nearby safe zone groups”, local check-ins, or sharing basic status between close devices without central servers.

- **Persistent User Preferences**
  - Uses `shared_preferences` to store small pieces of local state (e.g., whether onboarding has been seen, cached settings, etc.).
  - Remembers the last logged-in user and basic session info.

- **Firebase-Backed Data**
  - Firebase Core + Cloud Firestore for storing user profiles and app data.
  - Simple document-based structure to keep user and session data in sync across devices.

- **UX Helpers**
  - `modal_progress_hud` to show loading overlays while network/auth operations are in progress.
  - `flutter_swiper` for smooth onboarding/education carousels.

> Note: Because this was an early project, some flows are intentionally minimal and meant as a proof of concept rather than a production-grade COVID app.

---

## Tech Stack

**Framework**

- Flutter (Dart)

**Backend & Services**

- **Firebase**
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
- **Proximity / Device Connections**
  - `nearby_connections`
- **Location & Country**
  - `location`
  - `country_pickers`
- **Auth & Local Storage**
  - `flutter_facebook_login`
  - `shared_preferences`

**UI & Utilities**

- `flutter_swiper`
- `modal_progress_hud`
- `json_annotation`
- `cupertino_icons`

---

## Project Structure

High-level structure of the project:

```text
StaySafe/
├─ android/           # Android project (Gradle, native configs)
├─ ios/               # iOS project (Xcode configs)
├─ assets/
│  └─ who_corona_advice.json  # WHO COVID-19 advice content
├─ lib/
│  ├─ main.dart       # Flutter entry point
│  ├─ screens/        # UI screens (auth, onboarding, home, info, etc.)
│  ├─ models/         # Data models (e.g., advice items, user info)
│  ├─ services/       # Firebase, Nearby Connections, Location wrappers
│  └─ widgets/        # Reusable UI components
├─ pubspec.yaml       # Flutter & package configuration
└─ test/              # Flutter widget/unit tests (if any)
