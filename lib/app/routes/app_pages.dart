import 'package:get/get.dart';

import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/feed/bindings/feed_binding.dart';
import '../modules/feed/views/feed_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/kyc_data_diri/bindings/kyc_data_diri_binding.dart';
import '../modules/kyc_data_diri/views/kyc_data_diri_view.dart';
import '../modules/kyc_pending/bindings/kyc_pending_binding.dart';
import '../modules/kyc_pending/views/kyc_pending_view.dart';
import '../modules/kyc_verifikasi/bindings/kyc_verifikasi_binding.dart';
import '../modules/kyc_verifikasi/views/kyc_verifikasi_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/post_gig/bindings/post_gig_binding.dart';
import '../modules/post_gig/views/post_gig_view.dart';
import '../modules/detail_gig/bindings/detail_gig_binding.dart';
import '../modules/detail_gig/views/detail_gig_view.dart';
import '../modules/konfirmasi_gig/bindings/konfirmasi_gig_binding.dart';
import '../modules/konfirmasi_gig/views/konfirmasi_gig_view.dart';
import '../modules/penyelesaian/bindings/penyelesaian_binding.dart';
import '../modules/penyelesaian/views/penyelesaian_view.dart';
import '../modules/chat_room/bindings/chat_room_binding.dart';
import '../modules/chat_room/views/chat_room_view.dart';
import '../modules/rating_helper/bindings/rating_helper_binding.dart';
import '../modules/rating_helper/views/rating_helper_view.dart';
import '../modules/report/bindings/report_binding.dart';
import '../modules/report/views/report_view.dart';
import '../modules/pengaturan_pembayaran/bindings/pengaturan_pembayaran_binding.dart';
import '../modules/pengaturan_pembayaran/views/pengaturan_pembayaran_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/lupa_password/bindings/lupa_password_binding.dart';
import '../modules/lupa_password/views/lupa_password_view.dart';
import '../modules/password_baru/bindings/password_baru_binding.dart';
import '../modules/password_baru/views/password_baru_view.dart';
import '../modules/otp_verifikasi/bindings/otp_verifikasi_binding.dart';
import '../modules/otp_verifikasi/views/otp_verifikasi_view.dart';
import '../modules/maintenance/bindings/maintenance_binding.dart';
import '../modules/maintenance/views/maintenance_view.dart';
import '../modules/public_profile/bindings/public_profile_binding.dart';
import '../modules/public_profile/views/public_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.KYC_DATA_DIRI,
      page: () => const KycDataDiriView(),
      binding: KycDataDiriBinding(),
    ),
    GetPage(
      name: _Paths.KYC_VERIFIKASI,
      page: () => const KycVerifikasiView(),
      binding: KycVerifikasiBinding(),
    ),
    GetPage(
      name: _Paths.KYC_PENDING,
      page: () => const KycPendingView(),
      binding: KycPendingBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.FEED,
      page: () => const FeedView(),
      binding: FeedBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.POST_GIG,
      page: () => const PostGigView(),
      binding: PostGigBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_GIG,
      page: () => const DetailGigView(),
      binding: DetailGigBinding(),
    ),
    GetPage(
      name: _Paths.KONFIRMASI_GIG,
      page: () => const KonfirmasiGigView(),
      binding: KonfirmasiGigBinding(),
    ),
    GetPage(
      name: _Paths.PENYELESAIAN_GIG,
      page: () => const PenyelesaianView(),
      binding: PenyelesaianBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => const ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.RATING_HELPER,
      page: () => const RatingHelperView(),
      binding: RatingHelperBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: _Paths.PENGATURAN_PEMBAYARAN,
      page: () => const PengaturanPembayaranView(),
      binding: PengaturanPembayaranBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LUPA_PASSWORD,
      page: () => const LupaPasswordView(),
      binding: LupaPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_BARU,
      page: () => const PasswordBaruView(),
      binding: PasswordBaruBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFIKASI,
      page: () => const OtpVerifikasiView(),
      binding: OtpVerifikasiBinding(),
    ),
    GetPage(
      name: _Paths.MAINTENANCE,
      page: () => const MaintenanceView(),
      binding: MaintenanceBinding(),
    ),
    GetPage(
      name: _Paths.PUBLIC_PROFILE,
      page: () => const PublicProfileView(),
      binding: PublicProfileBinding(),
    ),
  ];
}
