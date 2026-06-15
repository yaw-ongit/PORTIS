# ⚡ PCare App - Quick Start Guide

## 🎯 Dalam 5 Menit

Ikuti langkah ini untuk memulai aplikasi dengan cepat:

---

## 📦 STEP 1: Install Dependencies (1 menit)

```bash
cd pcare_app
flutter pub get
```

**Tunggu sampai selesai. Ini akan install:**
- Firebase packages
- Provider (state management)
- Google Fonts

---

## 🔥 STEP 2: Setup Firebase (3 menit)

### **Option A: Cepat (Test Mode)**

Jika Anda tidak punya Firebase project:

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Create Project"** → nama: `pcare-app`
3. Di Android:
   - Klik **"<>"** → nama package: `com.example.pcare_app`
   - **Download `google-services.json`**
   - Taruh di: `android/app/google-services.json`

4. Edit `lib/firebase_options.dart`:
   ```dart
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'PASTE_WEB_API_KEY_HERE',
     appId: 'PASTE_APP_ID_HERE',
     messagingSenderId: 'PASTE_SENDER_ID_HERE',
     projectId: 'pcare-app',
     storageBucket: 'pcare-app.appspot.com',
   );
   ```

5. Di Firebase Console → Firestore Database:
   - **Create database** → Start in test mode
   - Region: **asia-southeast2**

6. Di Firebase Console → Authentication:
   - Enable **Email/Password**

### **Option B: Detailed**
→ Lihat `FIREBASE_SETUP.md` untuk langkah detail lengkap

---

## 💾 STEP 3: Add Demo Data (1 menit)

Di Firebase Console → Firestore:

1. Create collection **"assistants"**
2. Add document dengan ID: `asisten_001`
3. Paste data ini:

```json
{
  "id": "asisten_001",
  "name": "Dania Permaisuri",
  "type": "Suster",
  "rating": 5,
  "imagePath": "https://via.placeholder.com/300",
  "description": "Lulusan Keperawatan STIKes Jakarta dengan 8 tahun pengalaman dalam perawatan luka dan manajemen penyakit kronis.",
  "phoneNumber": "+6281234567890",
  "location": "Kebun Jeruk, Jakarta Barat, DKI Jakarta",
  "experience": 8,
  "qualifications": ["D3 Keperawatan STIKes Jakarta", "Sertifikasi Perawat Terdaftar (RN)"],
  "expertise": ["Perawatan luka", "Manajemen penyakit kronis", "Perawatan pasien lansia"]
}
```

4. Tambah document lagi dengan ID: `asisten_002`:
```json
{
  "id": "asisten_002",
  "name": "Budi Santoso",
  "type": "ART",
  "rating": 4.5,
  "imagePath": "https://via.placeholder.com/300",
  "description": "Pengalaman 5 tahun sebagai pembantu rumah tangga profesional.",
  "phoneNumber": "+6281234567891",
  "location": "Senayan, Jakarta Selatan, DKI Jakarta",
  "experience": 5,
  "qualifications": ["Berpengalaman di rumah tangga modern"],
  "expertise": ["Pembersihan rumah", "Memasak", "Perawatan tanaman"]
}
```

---

## ▶️ STEP 4: Run Application

```bash
# Android
flutter run

# atau jika ingin specify device
flutter run -d emulator-5554

# atau iOS (jika ada)
flutter run -d ios

# atau Web
flutter run -d chrome
```

**Tunggu sampai aplikasi terbuka!**

---

## 🧪 STEP 5: Test Features

### **Test 1: Sign Up**
1. Klik **"Daftar"** tab
2. Isi form:
   - Nama: `Test User`
   - Email: `test@example.com`
   - Telepon: `081234567890`
   - Password: `password123`
3. Centang **"Saya setuju..."**
4. Klik **"Register"**
5. Seharusnya berhasil & pindah ke Home screen

### **Test 2: Sign In**
1. Klik **"Masuk"** tab
2. Email: `test@example.com`
3. Password: `password123`
4. Klik **"Log In"**

### **Test 3: Filter Assistants**
1. Di Home screen, klik chip **"Suster"**
2. Hanya data Suster yang muncul
3. Klik **"ART"** → hanya ART
4. Klik **"Rekomendasi"** → tampil semua

### **Test 4: View Detail**
1. Klik salah satu asisten card
2. Lihat detail lengkap (profil, kualifikasi, expertise)
3. Klik **"Booking"** atau **"Chat"** button

### **Test 5: Sign Out**
1. Pergi ke **Profile** tab (icon orang di bottom)
2. Klik **"Sign Out"** button
3. Confirm dialog → klik **"Sign Out"**
4. Seharusnya kembali ke Sign In screen

---

## ✅ Checklist

- [ ] `flutter pub get` selesai
- [ ] Firebase project dibuat
- [ ] `google-services.json` di `android/app/`
- [ ] `firebase_options.dart` sudah diupdate
- [ ] Firestore & Auth aktif di Firebase
- [ ] Demo data sudah ditambah di Firestore
- [ ] `flutter run` berhasil
- [ ] Sign up/login berhasil
- [ ] Filter & detail screen berhasil

---

## 🐛 Troubleshooting

| Error | Solusi |
|-------|--------|
| **"Could not reach cloud firestore backend"** | Pastikan Firestore database sudah di-create |
| **"Firebase not initialized"** | Pastikan `firebase_options.dart` credentials benar |
| **"Invalid API key"** | Pastikan API key di `firebase_options.dart` benar dari Firebase Console |
| **"Auth disabled"** | Aktifkan Email/Password auth di Firebase Console |
| **App crash saat sign up** | Check Android logcat: `flutter logs` |

---

## 📁 File Penting

- `lib/firebase_options.dart` - **EDIT INI DENGAN CREDENTIALS ANDA**
- `lib/main.dart` - Entry point dengan Firebase init
- `android/app/google-services.json` - **HARUS ADA**

---

## 📖 Dokumentasi Lengkap

- Untuk step-by-step detail: `FIREBASE_SETUP.md`
- Untuk overview lengkap: `IMPLEMENTATION_SUMMARY.md`

---

## 🚀 Siap!

Sekarang aplikasi Anda ready:
- ✅ Authentication (Sign In/Sign Up)
- ✅ Database CRUD
- ✅ Real-time data
- ✅ Professional UI

**Happy coding! 🎉**
