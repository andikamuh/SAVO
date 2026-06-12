import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../main/controllers/main_controller.dart';
import '../../feed/controllers/feed_controller.dart';

class PostGigController extends GetxController {
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final lokasiController = TextEditingController();
  final hargaController = TextEditingController(text: "50000");

  final tanggal = "".obs;
  final waktu = "".obs;
  final selectedCategory = "Select Category".obs;

  DateTime _selectedDateTime = DateTime.now().add(const Duration(days: 1));

  final isLoading = false.obs;

  final categories = [
    "Tugas Kuliah",
    "Desain",
    "Antar Barang",
    "Lainnya",
  ];

  final presetPrices = [
    "15000",
    "30000",
    "50000",
    "100000",
    "150000",
    "200000",
  ];

  final hargaTerpilih = "50000".obs;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize date and time strings dynamically based on selected date
    final listBulan = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    tanggal.value = "${_selectedDateTime.day} ${listBulan[_selectedDateTime.month - 1]} ${_selectedDateTime.year}";
    
    final hourStr = _selectedDateTime.hour.toString().padLeft(2, '0');
    final minuteStr = _selectedDateTime.minute.toString().padLeft(2, '0');
    waktu.value = "$hourStr:$minuteStr ${_getIndonesianTimeZone()}";

    hargaController.addListener(() {
      hargaTerpilih.value = hargaController.text;
    });
  }

  String _getIndonesianTimeZone() {
    final offsetHours = DateTime.now().timeZoneOffset.inHours;
    if (offsetHours == 7) {
      return "WIB";
    } else if (offsetHours == 8) {
      return "WITA";
    } else if (offsetHours == 9) {
      return "WIT";
    }
    return "WIB"; // fallback default
  }

  @override
  void onClose() {
    judulController.dispose();
    deskripsiController.dispose();
    lokasiController.dispose();
    hargaController.dispose();
    super.onClose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime.isBefore(DateTime.now()) ? DateTime.now().add(const Duration(days: 1)) : _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(minutes: 5)),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF190000),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1A1A),
              surface: Colors.white,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: const Color(0xFF190000),
              headerForegroundColor: Colors.white,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              dividerColor: Colors.transparent,
              dayStyle: const TextStyle(fontWeight: FontWeight.bold),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(const Color(0xFF190000)),
                textStyle: WidgetStateProperty.all(const TextStyle(fontWeight: FontWeight.bold)),
              ),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(const Color(0xFF190000)),
                textStyle: WidgetStateProperty.all(const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _selectedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
      // Format to simple string Indonesian style e.g. "9 Mei 2026"
      final listBulan = [
        "Januari", "Februari", "Maret", "April", "Mei", "Juni",
        "Juli", "Agustus", "September", "Oktober", "November", "Desember"
      ];
      tanggal.value = "${picked.day} ${listBulan[picked.month - 1]} ${picked.year}";
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _selectedDateTime.hour, minute: _selectedDateTime.minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF190000),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1A1A),
              surface: Colors.white,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? const Color(0xFF190000)
                      : const Color(0xFF190000).withOpacity(0.05)),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.white
                      : const Color(0xFF190000)),
              dialHandColor: const Color(0xFF190000),
              dialBackgroundColor: const Color(0xFF190000).withOpacity(0.05),
              dialTextColor: const Color(0xFF1A1A1A),
              entryModeIconColor: const Color(0xFF190000),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(const Color(0xFF190000)),
                textStyle: WidgetStateProperty.all(const TextStyle(fontWeight: FontWeight.bold)),
              ),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(const Color(0xFF190000)),
                textStyle: WidgetStateProperty.all(const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        picked.hour,
        picked.minute,
      );
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minuteStr = picked.minute.toString().padLeft(2, '0');
      waktu.value = "$hourStr:$minuteStr ${_getIndonesianTimeZone()}";
    }
  }

  Future<void> postGig() async {
    if (isLoading.value) return;
    if (judulController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Judul pekerjaan tidak boleh kosong",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (deskripsiController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Deskripsi pekerjaan tidak boleh kosong",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (lokasiController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Lokasi tidak boleh kosong",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (selectedCategory.value == "Select Category" || selectedCategory.value.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Silakan pilih kategori pekerjaan",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (hargaController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Silakan masukkan harga imbalan",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final priceStr = hargaController.text.replaceAll('Rp', '').replaceAll('.', '').replaceAll(' ', '').trim();
      final priceVal = double.tryParse(priceStr) ?? 0.0;

      if (priceVal <= 0) {
        Get.snackbar(
          "Peringatan",
          "Harga imbalan harus lebih besar dari 0",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      final deadlineDate = "${_selectedDateTime.year}-${_selectedDateTime.month.toString().padLeft(2, '0')}-${_selectedDateTime.day.toString().padLeft(2, '0')}";
      final deadlineTime = "${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}:00";

      final body = {
        'title': judulController.text.trim(),
        'description': deskripsiController.text.trim(),
        'location': lokasiController.text.trim(),
        'category': selectedCategory.value,
        'price': priceVal,
        'deadline_date': deadlineDate,
        'deadline_time': deadlineTime,
      };

      final response = await ApiService.to.postRequest('/gigs', body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          "Sukses",
          "Pekerjaan berhasil diposting!",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Return success to the caller
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back(result: true);
          try {
            if (Get.isRegistered<MainController>()) {
              Get.find<MainController>().changeTab(1);
            }
            if (Get.isRegistered<FeedController>()) {
              Get.find<FeedController>().fetchGigs();
            }
          } catch (e) {
            debugPrint("Error switching to feed tab and refreshing: $e");
          }
        });
      } else {
        final message = response.body?['message'] ?? 'Gagal memposting pekerjaan';
        Get.snackbar(
          "Gagal",
          message.toString(),
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Koneksi Gagal",
        "Terjadi kesalahan saat memposting pekerjaan.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
