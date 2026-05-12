# Agenda Nusantara 📝

**Agenda Nusantara** adalah aplikasi manajemen tugas (*to-do list*) berbasis mobile yang dirancang untuk membantu pengguna mengorganisir produktivitas harian secara efisien. Aplikasi ini dikembangkan sebagai bagian dari **Soal Tes Observasi SERTIKOM BNSP DIPA 2026** untuk skema **Pemrograman Aplikasi Mobile Berbasis Database**.

Aplikasi ini mengutamakan kemandirian data dengan menggunakan **SQLite** sebagai database lokal, sehingga seluruh informasi tersimpan aman di dalam perangkat tanpa memerlukan koneksi internet.

---

## 🚀 Fitur Utama

* **Sistem Autentikasi:** Login aman untuk menjaga privasi data tugas.
* **Manajemen Tugas Terstruktur:** Memisahkan tugas berdasarkan kategori **Penting** dan **Biasa**.
* **Dashboard Informatif:** Menampilkan ringkasan statistik jumlah tugas yang selesai dan belum selesai.
* **Database Lokal (SQLite):** Penyimpanan data yang cepat dan dapat diakses secara offline.
* **Visual Indikator:** Pembedaan prioritas tugas menggunakan warna (Merah untuk Penting, Hijau untuk Biasa).
* **Pengaturan Akun:** Fitur untuk memperbarui kata sandi dan melihat informasi profil pengembang.

---

## 🛠️ Teknologi yang Digunakan

* **Bahasa Pemrograman:** Java/Kotlin (Android SDK)
* **Database:** SQLite
* **UI Component:** Material Design Components

---

## 📸 Cuplikan Layar (Preview)

| Halaman Login | Halaman Beranda | Daftar Tugas |
|---|---|---|
| ![Login](login.png) | ![Beranda](beranda.png) | ![Daftar](daftar%20tugas.png) |

| Tambah Tugas Penting | Tambah Tugas Biasa | Pengaturan |
|---|---|---|
| ![Penting](penting.png) | ![Biasa](biasa.png) | ![Pengaturan](pengaturan.png) |

---

## 📁 Struktur Database

Aplikasi menggunakan SQLite dengan tabel utama untuk menyimpan data tugas yang mencakup kolom:
* `id` (Primary Key)
* `judul` (String)
* `deskripsi` (Text)
* `tanggal_jatuh_tempo` (Date)
* `kategori` (Penting/Biasa)
* `status` (Selesai/Belum Selesai)

---

## 👨‍💻 Informasi Pengembang

Aplikasi ini dikembangkan oleh:
* **Nama:** [Isi Nama Anda]
* **NIM:** [Isi NIM Anda]
* **Instansi:** [Isi Nama Kampus/Sekolah]

---
*Proyek ini dibuat untuk memenuhi persyaratan Sertifikasi Kompetensi BNSP 2026.*
