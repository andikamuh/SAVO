<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kode OTP Reset Password SAVO</title>
</head>
<body style="margin: 0; padding: 0; background-color: #F6F6F6; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #F6F6F6; padding: 40px 0;">
        <tr>
            <td align="center">
                <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 520px; background-color: #FFFFFF; border-radius: 24px; overflow: hidden; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03); border: 1px solid #EEEEEE;">
                    <!-- Header -->
                    <tr>
                        <td align="center" style="padding: 40px 40px 20px 40px;">
                            <span style="font-size: 28px; font-weight: 900; letter-spacing: 4px; color: #190000; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;">SAVO</span>
                        </td>
                    </tr>
                    
                    <!-- Content -->
                    <tr>
                        <td style="padding: 0 40px; text-align: center; color: #1A1A1A;">
                            <h2 style="font-size: 20px; font-weight: 700; margin-top: 10px; margin-bottom: 8px;">Atur Ulang Kata Sandi</h2>
                            <p style="font-size: 14px; line-height: 1.6; color: #666666; margin-bottom: 24px;">
                                Kami menerima permintaan untuk mengatur ulang kata sandi akun SAVO Anda. Silakan gunakan kode verifikasi OTP di bawah ini untuk melanjutkan:
                            </p>
                        </td>
                    </tr>

                    <!-- OTP Code Display -->
                    <tr>
                        <td align="center" style="padding: 0 40px;">
                            <div style="background-color: #190000; color: #FFFFFF; font-size: 36px; font-weight: 800; letter-spacing: 8px; padding: 16px 32px; border-radius: 16px; display: inline-block; box-shadow: 0 4px 10px rgba(25, 0, 0, 0.15); margin-bottom: 24px; font-family: monospace;">
                                {{ $code }}
                            </div>
                        </td>
                    </tr>

                    <!-- Expired Note -->
                    <tr>
                        <td style="padding: 0 40px; text-align: center;">
                            <div style="background-color: #FFF9F9; border: 1px solid #FFEBEB; border-radius: 12px; padding: 12px; margin-bottom: 30px;">
                                <p style="font-size: 13px; line-height: 1.5; color: #D32F2F; margin: 0; font-weight: 600;">
                                    ⚠️ Kode OTP ini bersifat rahasia dan hanya berlaku selama 15 menit.
                                </p>
                            </div>
                        </td>
                    </tr>

                    <!-- Footer / Info -->
                    <tr>
                        <td style="padding: 0 40px 40px 40px; text-align: center; border-top: 1px solid #F5F5F5; padding-top: 30px;">
                            <p style="font-size: 12px; line-height: 1.5; color: #999999; margin: 0 0 16px 0;">
                                Jika Anda tidak meminta pengaturan ulang kata sandi ini, abaikan email ini dengan aman.
                            </p>
                            <p style="font-size: 11px; color: #CCCCCC; margin: 0; letter-spacing: 1px; text-transform: uppercase;">
                                &copy; 2026 SAVO. ALL RIGHTS RESERVED.
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
