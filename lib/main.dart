import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'viewmodels/app_viewmodels.dart';
import 'viewmodels/booking_viewmodel.dart';
import 'viewmodels/chat_viewmodel.dart';
import 'screens/my_bookings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth ViewModel
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        // Assistant ViewModel
        ChangeNotifierProvider(create: (_) => AssistantViewModel()),
        // Booking ViewModel
        ChangeNotifierProvider(create: (_) => BookingViewModel()),
        // Chat ViewModel
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: MaterialApp(
        title: 'PCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6CC2E8),
            primary: const Color(0xFF6CC2E8),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen(),
        routes: {
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/main': (context) => const MainScreen(),
          '/bookings': (context) => const MyBookingsScreen(),
        },
      ),
    );
  }
}

// ─── Auth Wrapper untuk handle auth state ───
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        // Jika user sudah login
        if (authVM.isAuthenticated && authVM.currentUser != null) {
          return const MainScreen();
        }
        // Jika user belum login
        return const SignInScreen();
      },
    );
  }
}
