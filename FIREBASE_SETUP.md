# 📱 PCare App - Setup Guide

## ✅ Apa yang Telah Diimplementasikan

### 1. **Firebase CRUD Database**
- ✅ Firebase Authentication (Sign In/Sign Up)
- ✅ Cloud Firestore untuk menyimpan data User & Assistant
- ✅ Real-time data streaming
- ✅ Error handling

### 2. **Authentication UI**
- ✅ Sign In Screen (dengan UI seperti mockup)
- ✅ Sign Up Screen (dengan validasi)
- ✅ Auth State Management

### 3. **MVVM Architecture & State Management**
- ✅ AuthViewModel (untuk manage auth state)
- ✅ AssistantViewModel (untuk manage data asisten)
- ✅ Provider package untuk state management

### 4. **Assistant Features**
- ✅ Navigasi ke detail screen saat klik asisten
- ✅ Filter berdasarkan type (Suster, ART, RS)
- ✅ Assistant Detail Page dengan profil lengkap

### 5. **User Display**
- ✅ Menampilkan user aktif di profile screen
- ✅ Sign Out functionality

---

## 🚀 STEP-BY-STEP FIREBASE SETUP

### **STEP 1: Create Firebase Project**

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Create a project"**
3. Nama project: `pcare-app` (atau nama apapun)
4. Klik **"Create project"**
5. Tunggu hingga selesai

---

### **STEP 2: Setup Android**

1. Di Firebase Console, klik tombol **"<>"** untuk menambah Android app
2. Android package name: `com.example.pcare_app`
3. Klik **"Register app"**
4. **Download `google-services.json`**
5. Pindahkan file ke: `android/app/google-services.json`
6. Di Android, Firebase sudah terintegrasi

---

### **STEP 3: Setup iOS** (Optional, jika ingin test di iOS)

1. Klik **"<>"** di Firebase Console untuk iOS
2. Bundle ID: `com.example.pcareApp`
3. Klik **"Register app"**
4. **Download `GoogleService-Info.plist`**
5. Di Xcode: Project → Runner → Targets → Runner
   - Drag & drop file ke Xcode
   - Centang **"Copy items if needed"**

---

### **STEP 4: Get Firebase Credentials**

1. Di Firebase Console, buka **"Project Settings"** (gear icon)
2. Pergi ke tab **"Service Accounts"**
3. Pilih **"Generate new private key"** (untuk backend, opsional)
4. Pergi ke tab **"General"**
5. Copy nilai berikut ke file [firebase_options.dart](lib/firebase_options.dart):

**Dari section "Your apps":**
- **apiKey** → `Web API Key`
- **projectId** → `Project ID`
- **storageBucket** → `Storage Bucket`
- **messagingSenderId** → `Sender ID` (bisa dilihat di service account)
- **appId** → `App ID`

**Cara mendapatkan Sender ID:**
- Pergi ke **"Project Settings"** → **"Cloud Messaging"**
- Copy **"Sender ID"**

---

### **STEP 5: Update Firebase Options**

Edit file `lib/firebase_options.dart`:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY_DARI_FIREBASE',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'pcare-app',
    storageBucket: 'pcare-app.appspot.com',
  );
}
```

---

### **STEP 6: Enable Firebase Services**

Di Firebase Console:

#### **Enable Authentication**
1. Buka **"Authentication"** → **"Sign-in method"**
2. Aktifkan **"Email/Password"**
3. Klik **"Enable"** dan **"Save"**

#### **Create Firestore Database**
1. Buka **"Firestore Database"** → **"Create database"**
2. Pilih **"Start in test mode"** (untuk development)
3. Pilih region: **"asia-southeast2"** (Indonesia)
4. Klik **"Create"**

#### **Setup Security Rules** (untuk production):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    match /assistants/{document=**} {
      allow read: if request.auth != null;
      allow write: if false; // Hanya admin yang bisa write
    }
  }
}
```

---

## 🛠️ SETUP LOKAL

### **1. Install Dependencies**

```bash
cd pcare_app
flutter pub get
```

---

### **2. Add Sample Data ke Firestore**

Langkah ini untuk menambahkan data contoh agar bisa test aplikasi.

Di Firebase Console → **Firestore Database**:

#### **Create Collection "users"** (otomatis saat sign up)

#### **Create Collection "assistants"** dengan dokumen:

```json
{
  "id": "asisten_001",
  "name": "Dania Permaisuri",
  "type": "Suster",
  "rating": 5.0,
  "imagePath": "https://via.placeholder.com/300",
  "description": "Lulusan Keperawatan STIKes Jakarta dengan 8 tahun pengalaman...",
  "phoneNumber": "+6281234567890",
  "location": "Kebun Jeruk, Jakarta Barat, DKI Jakarta",
  "experience": 8,
  "qualifications": [
    "D3 Keperawatan STIKes Jakarta (lulus 2023)",
    "Sertifikasi Perawat Terdaftar (RN)"
  ],
  "expertise": [
    "Perawatan luka",
    "Manajemen penyakit kronis",
    "Perawatan pasien lansia"
  ]
}
```

**Tambahkan lebih banyak dokumen dengan data berbeda:**

```json
{
  "id": "asisten_002",
  "name": "Budi Santoso",
  "type": "ART",
  "rating": 4.5,
  "imagePath": "https://via.placeholder.com/300",
  "description": "Pengalaman 5 tahun sebagai pembantu rumah tangga...",
  "phoneNumber": "+6281234567891",
  "location": "Senayan, Jakarta Selatan, DKI Jakarta",
  "experience": 5,
  "qualifications": [
    "Berpengalaman di rumah tangga modern",
    "Terlatih dalam housekeeping"
  ],
  "expertise": [
    "Pembersihan rumah",
    "Memasak",
    "Perawatan tanaman"
  ]
}
```

---

### **3. Run Aplikasi**

```bash
# Android
flutter run

# atau iOS
flutter run -d ios

# atau Web
flutter run -d chrome
```

---

## 🧪 Testing

### **Test Sign Up:**
1. Buka aplikasi
2. Klik **"Daftar"**
3. Isi data:
   - Nama: `Nama Anda`
   - Email: `email@example.com`
   - Nomor: `081234567890`
   - Password: `password123`
4. Centang terms & klik **"Register"**

### **Test Sign In:**
1. Gunakan email & password dari sign up
2. Klik **"Log In"**

### **Test Filter Asisten:**
1. Di Home, klik chip **"Suster"**, **"ART"**, atau **"RS"**
2. Data akan di-filter dari Firestore

### **Test Detail Screen:**
1. Klik salah satu asisten card
2. Detail page akan menampilkan profil lengkap

---

## 📁 Struktur Project

```
lib/
├── main.dart                 # Entry point + Firebase init
├── firebase_options.dart     # Firebase credentials (EDIT INI)
├── models/
│   └── app_models.dart       # User, Assistant models
├── services/
│   └── firebase_service.dart # Firebase CRUD operations
├── viewmodels/
│   └── app_viewmodels.dart   # AuthViewModel, AssistantViewModel
├── screens/
│   ├── auth_screen.dart      # Sign In/Sign Up screens
│   ├── main_screen.dart      # Main app screen
│   ├── home_screen.dart      # Home dengan filter
│   ├── assistant_detail_screen.dart # Detail page
│   ├── profile_screen.dart   # Profile dengan user aktif & Sign Out
│   ├── chat_screen.dart
│   ├── activity_screen.dart
│   └── notification_screen.dart
└── widgets/
    ├── service_card.dart
    ├── category_chip.dart
    └── profile_menu_item.dart
```

---

## 🔑 Poin Penting

1. **Firebase Credentials**: Edit `firebase_options.dart` dengan data Anda
2. **Google Services**: Pastikan `google-services.json` ada di `android/app/`
3. **Firestore Rules**: Update rules untuk production (jangan gunakan test mode)
4. **Data Contoh**: Tambahkan data asisten ke Firestore untuk testing

---

##  ⚠️ Troubleshooting

### **Error: Firebase not initialized**
- Pastikan `Firebase.initializeApp()` dipanggil di `main()`
- Check `firebase_options.dart` sudah benar

### **Error: Permission denied (Firestore)**
- Gunakan **"Start in test mode"** untuk development
- Update security rules untuk production

### **Sign Up/Login gagal**
- Pastikan **Email/Password authentication** sudah aktif di Firebase
- Check console untuk error message

---

## 📚 Resources

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Provider Package Documentation](https://pub.dev/packages/provider)

---

**Happy Coding! 🎉**
