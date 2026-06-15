# PORTIS - Healthcare Mobile Application


<p align="center">
  Healthcare Mobile Application built with Flutter and Firebase
</p>

---

## About PORTIS

PORTIS is a healthcare mobile application developed using Flutter and Firebase technologies. The application is designed to provide users with easy access to healthcare-related services through a modern, responsive, and user-friendly mobile interface.

The system integrates cloud-based authentication and database services, allowing users to securely register, log in, manage personal information, communicate through chat features, and access healthcare-related information.

PORTIS aims to support digital healthcare transformation by providing a simple, accessible, and efficient platform that improves user interaction and healthcare service accessibility.

This project was developed as part of the **Mobile Programming Course** at **Telkom University Jakarta**.

---

## Project Objectives

The objectives of PORTIS are:

- Provide secure user authentication and profile management.
- Deliver a modern healthcare-oriented mobile experience.
- Implement cloud-based data management using Firebase.
- Demonstrate CRUD operations in a mobile application environment.
- Apply Flutter development best practices using modular architecture.
- Improve accessibility and efficiency of healthcare-related services.

---

## Features

### User Authentication

- User Registration (Sign Up)
- User Login (Sign In)
- Password Reset
- Session Management
- Firebase Authentication Integration

### User Profile Management

- View Profile Information
- Edit User Profile
- Profile Data Storage
- User Session Tracking

### Booking & Transaction Management

- Healthcare Service Booking
- Booking Details
- Checkout Process
- Order Confirmation
- Booking History

### Chat & Communication

- Chat Interface
- Chat Detail View
- Assistant Interaction Feature
- Real-time Communication Support

### Activity Management

- Activity Tracking
- Ongoing Activities
- Notifications
- Activity Monitoring

### Cloud Database Integration

- Firebase Cloud Firestore
- Real-time Data Synchronization
- Secure Cloud Storage
- Structured Data Management

### CRUD Functionality

- Create Data
- Read Data
- Update Data
- Delete Data

### Additional Features

- Modern UI/UX Design
- Responsive Layout
- Cross-Platform Development
- Firebase Backend Services
- Modular Architecture

---

## Application Architecture

The application follows modern Flutter development practices and adopts the MVVM (Model-View-ViewModel) architectural pattern.

### Architecture Pattern

```text
Presentation Layer
│
├── Screens
├── Widgets
│
ViewModel Layer
│
├── Business Logic
├── State Management
│
Model Layer
│
├── Data Models
├── Firebase Services
│
Backend Layer
│
├── Firebase Authentication
└── Cloud Firestore
```

### Advantages of MVVM

- Better Code Organization
- Improved Maintainability
- Scalability
- Separation of Concerns
- Reusable Business Logic

---

## Technology Stack

### Frontend

- Flutter
- Dart

### Backend Services

- Firebase Authentication
- Cloud Firestore

### Development Tools

- Android Studio
- Visual Studio Code
- Git
- GitHub

---

## Packages Used

```yaml
firebase_core
firebase_auth
cloud_firestore
image_picker
flutter
cupertino_icons
```

Additional packages may be added according to future project requirements.

---

## Project Structure

```text
lib/
│
├── models/
│   └── app_models.dart
│
├── screens/
│   ├── activity_screen.dart
│   ├── assistant_detail_screen.dart
│   ├── auth_screen.dart
│   ├── booking_detail_screen.dart
│   ├── chat_detail_screen.dart
│   ├── chat_screen.dart
│   ├── checkout_screen.dart
│   ├── edit_profile_screen.dart
│   ├── home_screen.dart
│   ├── main_screen.dart
│   ├── my_bookings_screen.dart
│   ├── notification_screen.dart
│   ├── ongoing_activity_screen.dart
│   ├── order_confirmation_screen.dart
│   ├── profile_screen.dart
│   ├── reset_password_screen.dart
│   └── splash_screen.dart
│
├── services/
│   └── firebase_service.dart
│
├── viewmodels/
│   ├── app_viewmodels.dart
│   ├── booking_viewmodel.dart
│   └── chat_viewmodel.dart
│
├── widgets/
│   ├── category_chip.dart
│   ├── chat_list_item.dart
│   ├── profile_menu_item.dart
│   └── service_card.dart
│
├── firebase_options.dart
└── main.dart
```

---

## Installation Guide

### Prerequisites

Before running the project, make sure the following software is installed:

- Flutter SDK
- Android Studio
- Visual Studio Code
- Git

### Clone Repository

```bash
git clone https://github.com/yaw-ongit/PORTIS.git
```

### Navigate to Project Folder

```bash
cd PORTIS
```

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

---

## Build APK

Generate Release APK:

```bash
flutter build apk --release
```

APK Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---



## Team Members

| Name | Student ID |
|--------|------------|
| Arief Rachman Wicaksana | 103062300012 |
| Qays Gabriel Ommar Yuniargo | 103062300013 |
| Rafly Firmansyah | 103062300017 |
| Evan Gerard Leones Tahiya | 103062300020 |
| Muhammad Wisnu Haryanto | 103062300038 |

---

## Task Distribution

| Team Member | Responsibility |
|------------|---------------|
| Arief Rachman Wicaksana | Firebase Integration, Activity Management, Project Coordination & Deployment |
| Qays Gabriel Ommar Yuniargo | Authentication & User Profile Module Development |
| Rafly Firmansyah | Booking & Transaction Module Development |
| Evan Gerard Leones Tahiya | Chat Module Development, Application Testing & Documentation |
| Muhammad Wisnu Haryanto | UI/UX Implementation, Home Screen & Navigation Development |

---

## Academic Information

**Course:** Mobile Programming

**Institution:** Telkom University Jakarta

**Project Type:** Final Project (UAS)

**Project Title:** PORTIS - Healthcare Mobile Application

**Academic Year:** 2025/2026

---

## Repository

GitHub Repository:

https://github.com/yaw-ongit/PORTIS

---

## APK Download

Download APK:

(Add APK Link Here)

Example:

```text
https://drive.google.com/your-apk-link
```

---

## Showcase Video

Project Demonstration:

(Add Video Link Here)

Example:

```text
https://youtu.be/your-showcase-link
```

---

## Future Development

Potential future improvements include:

- Online Consultation Features
- Video Call Integration
- Health Monitoring Dashboard
- AI-Based Health Assistant
- Push Notifications
- Appointment Scheduling System
- Healthcare Analytics

---

## License

This project was developed for educational purposes as part of the Mobile Programming course at Telkom University Jakarta.

© 2026 PORTIS Team. All Rights Reserved.
