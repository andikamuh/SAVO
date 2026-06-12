import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/pengaturan_pembayaran_controller.dart';

class PengaturanPembayaranView extends GetView<PengaturanPembayaranController> {
  const PengaturanPembayaranView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryDark, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'SAVO',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Halaman
              const Text(
                'Pengaturan Pembayaran',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tentukan metode penerimaan pembayaran Anda setelah menyelesaikan tugas sebagai Helper.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // 1. CARD: TRANSFER BANK
              Obx(() {
                final isEnabled = controller.isBankEnabled.value;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: _buildCardDecoration(isEnabled),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_outlined,
                            color: isEnabled ? AppColors.primaryDark : AppColors.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transfer Bank',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isEnabled ? AppColors.primaryDark : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Terima langsung ke rekening bank',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: isEnabled,
                            activeColor: AppColors.primaryDark,
                            onChanged: (val) => controller.isBankEnabled.value = val,
                          ),
                        ],
                      ),
                      
                      // Bidang input opsional bank
                      if (isEnabled) ...[
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        
                        const Text(
                          'Nama Bank',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: controller.selectedBank.value,
                          decoration: _buildInputDecoration('Pilih Bank'),
                          items: controller.banks.map((String bank) {
                            return DropdownMenuItem<String>(
                              value: bank,
                              child: Text(bank, style: const TextStyle(fontSize: 13)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) controller.selectedBank.value = val;
                          },
                        ),
                        const SizedBox(height: 14),

                        const Text(
                          'Nomor Rekening',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: controller.rekeningController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 13),
                          decoration: _buildInputDecoration('Masukkan nomor rekening bank Anda'),
                        ),
                        const SizedBox(height: 14),

                        const Text(
                          'Nama Pemilik Rekening',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: controller.namaPemilikController,
                          style: const TextStyle(fontSize: 13),
                          decoration: _buildInputDecoration('Nama lengkap pemilik rekening'),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // 2. CARD: E-WALLET
              Obx(() {
                final isEnabled = controller.isWalletEnabled.value;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: _buildCardDecoration(isEnabled),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            color: isEnabled ? AppColors.primaryDark : AppColors.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'E-Wallet',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isEnabled ? AppColors.primaryDark : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Dana, GoPay, OVO, LinkAja',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: isEnabled,
                            activeColor: AppColors.primaryDark,
                            onChanged: (val) => controller.isWalletEnabled.value = val,
                          ),
                        ],
                      ),

                      // Bidang input opsional e-wallet
                      if (isEnabled) ...[
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),

                        const Text(
                          'Jenis E-Wallet',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: controller.selectedWallet.value,
                          decoration: _buildInputDecoration('Pilih E-Wallet'),
                          items: controller.wallets.map((String wallet) {
                            return DropdownMenuItem<String>(
                              value: wallet,
                              child: Text(wallet, style: const TextStyle(fontSize: 13)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) controller.selectedWallet.value = val;
                          },
                        ),
                        const SizedBox(height: 14),

                        const Text(
                          'Nomor Handphone',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: controller.walletHpController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontSize: 13),
                          decoration: _buildInputDecoration('Contoh: 0812xxxxxxxx'),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // 3. CARD: TUNAI (CASH)
              Obx(() {
                final isEnabled = controller.isCashEnabled.value;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: _buildCardDecoration(isEnabled),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            color: isEnabled ? AppColors.primaryDark : AppColors.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tunai (Cash)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isEnabled ? AppColors.primaryDark : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Bayar langsung di tempat',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: isEnabled,
                            activeColor: AppColors.primaryDark,
                            onChanged: (val) => controller.isCashEnabled.value = val,
                          ),
                        ],
                      ),
                      if (isEnabled) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Catatan: Pembayaran dilakukan secara offline langsung dari peminta jasa kepada Anda sesaat setelah pekerjaan selesai terverifikasi.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => controller.saveSettings(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Simpan Preferensi',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(bool isActive) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.015),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: isActive ? AppColors.primaryDark.withOpacity(0.4) : Colors.grey.shade100,
        width: isActive ? 1.5 : 1.0,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      fillColor: AppColors.inputBackground,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
