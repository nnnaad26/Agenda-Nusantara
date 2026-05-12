import 'dart:io'; //Untuk urusan Input/Output sistem operasi.
import 'package:flutter/material.dart'; //perpustakaan paling wajib di Flutter.
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; //Library untuk mengelola database SQLite.
import 'package:intl/date_symbol_data_local.dart'; //Untuk mengatur format waktu dan bahasa (Internasionalisasi).
import 'package:google_fonts/google_fonts.dart'; //Untuk memanggil ribuan jenis font dari Google secara online.
import 'login_page.dart'; //Memanggil file kodingan lain yang ada di proyekmu.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Database untuk Windows dan Linux
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Inisialisasi Format Tanggal Bahasa Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Nusantara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          primary: Colors.pink,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

//
