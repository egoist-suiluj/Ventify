// File: lib/constants/api_config.dart

class ApiConfig {
  // ⚠️ PALITAN ITO ng URL galing sa Railway Settings > Domains
  // Halimbawa: 'https://ventify-backend-production.up.railway.app'
  static const String baseUrl = 'https://web-production-cfe76.up.railway.app';

  static const String chatEndpoint = '/chat';
  static const String healthEndpoint = '/health';

  // Timeout settings (para hindi mag-hang ang app kapag mabagal ang net)
  static const Duration connectionTimeout = Duration(seconds: 30);
}