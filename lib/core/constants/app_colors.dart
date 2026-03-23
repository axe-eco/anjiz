import 'package:flutter/material.dart';

/// نظام ألوان أنجز — Cosmic Aurora Palette
class AppColors {
  AppColors._();

  // ── Backgrounds: Deep Space ──
  static const spaceVoid  = Color(0xFF03030B);   // الخلفية الجذرية
  static const spaceDeep  = Color(0xFF07071A);   // خلفية الشاشة
  static const spaceCard  = Color(0xFF0C0C24);   // خلفية البطاقات
  static const spaceHover = Color(0xFF11112E);   // حالة التحويم/النشط
  static const spaceLift  = Color(0xFF18184A);   // العناصر المرتفعة

  // ── Primary: Ultraviolet Blaze ──
  static const uvDeep   = Color(0xFF3D33CC);   // لون أساسي داكن
  static const uvCore   = Color(0xFF5548EE);   // ★ اللون الأساسي
  static const uvBright = Color(0xFF7B70FF);   // أشرطة التقدم
  static const uvMist   = Color(0xFFA89FFF);   // نص ثانوي
  static const uvPearl  = Color(0xFFD4D0FF);   // نص الشعار

  // ── Secondary: Neon Spearmint (AI) ──
  static const mintDeep  = Color(0xFF00AA8C);  // مكتمل/نشط
  static const mintCore  = Color(0xFF00CCAA);  // ★ لون الذكاء الاصطناعي
  static const mintNeon  = Color(0xFF00EEC4);  // توهجات
  static const mintHaze  = Color(0xFF80FFE8);  // تلوينات خفيفة

  // ── Electric Amber (Streak/Reward) ──
  static const amberCore = Color(0xFFFFCC22);  // ★ سلسلة الإنجاز
  static const amberLit  = Color(0xFFFFE066);  // أولوية متوسطة

  // ── Magenta Pulse (Critical/Error) ──
  static const magCore   = Color(0xFFEE2266);  // ★ حرج
  static const magLight  = Color(0xFFFF5599);  // أولوية عالية

  // ── Sky Flare (Info) ──
  static const skyCore   = Color(0xFF33AAFF);  // روابط/معلومات

  // ── Gradients ──
  static const brandGrad = LinearGradient(
    colors: [uvDeep, mintCore],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const neonGrad = LinearGradient(
    colors: [uvCore, mintNeon],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const fireGrad = LinearGradient(
    colors: [magCore, amberCore],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// ألوان المشاريع حسب الفهرس
  static const projectColors = [
    uvCore,
    mintCore,
    magCore,
    amberCore,
    skyCore,
  ];
}
