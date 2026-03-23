import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة Gemini AI — تحليل المشاريع وتوليد المهام
class GeminiService {
  static const _model = 'gemini-1.5-flash';
  static const _apiKeyPref = 'gemini_api_key';

  /// System prompt لتحليل المشاريع
  static const _systemPrompt = '''
أنت مساعد ذكاء اصطناعي متخصص في تحليل المشاريع.
عند استقبال وصف مشروع، أرجع JSON فقط بهذه البنية بدون إضافة أي نص آخر:
{
  "tasks": [
    {
      "title": "string",
      "priority": "critical|high|medium|low",
      "priorityReason": "string",
      "estimatedMinutes": number,
      "subtasks": [
        {"title": "string", "estimatedMinutes": number}
      ]
    }
  ],
  "suggestions": ["string", "string", "string"]
}
القواعد: عربي في العناوين الوصفية، ٤-٨ tasks، ٣-٦ subtasks لكل task،
رتّب المهام حسب الأولوية (critical أولاً).
''';

  final Dio _dio;

  GeminiService() : _dio = Dio();

  /// حفظ مفتاح API
  Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPref, key);
  }

  /// جلب مفتاح API
  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_apiKeyPref);
    // المفتاح الافتراضي المقدم من المستخدم كاحتياطي
    if (key == null || key.isEmpty) {
      return 'AIzaSyDuTuTKlKS8PnbpqFUrDwGsOXTIzd3K5oU';
    }
    return key;
  }

  /// توليد المهام من وصف المشروع
  Future<Map<String, dynamic>> generateTasks(String description) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('مفتاح API غير موجود. يرجى إدخاله في الإعدادات.');
    }

    try {
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent',
        queryParameters: {'key': apiKey},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          'systemInstruction': {
            'parts': [
              {'text': _systemPrompt}
            ]
          },
          'contents': [
            {
              'parts': [
                {'text': 'حلل هذا المشروع وأنشئ خطة مهام:\n\n$description'}
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'temperature': 0.2
          }
        },
      );

      // استخراج النص من الاستجابة
      final text = response.data['candidates'][0]['content']['parts'][0]['text'] as String;

      // محاولة تحليل JSON
      final jsonStr = _extractJson(text);
      return json.decode(jsonStr) as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('الطلب غير صالح أو يوجد مشكلة في المفتاح');
      }
      if (e.response?.statusCode == 429) {
        throw Exception('تم تجاوز حد الطلبات. حاول لاحقاً.');
      }
      throw Exception('خطأ في الاتصال: ${e.message}');
    }
  }

  /// استخراج JSON من النص (في حالة وجود نص إضافي)
  String _extractJson(String text) {
    final trimmed = text.trim();
    if (trimmed.startsWith('{')) {
      return trimmed;
    }
    final codeBlockRegex = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
    final match = codeBlockRegex.firstMatch(trimmed);
    if (match != null) {
      return match.group(1)!.trim();
    }
    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return trimmed.substring(start, end + 1);
    }
    throw Exception('تعذر تحليل استجابة AI');
  }
}
