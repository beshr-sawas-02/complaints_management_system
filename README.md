# 📱 نظام إدارة الشكاوى - لوحة التحكم
## Complaints Management System - Admin Panel

<p align="center">
  <img src="assets/icon/app_icon.png" width="150" alt="App Icon">
</p>

<p align="center">
  <strong>تطبيق Flutter احترافي لإدارة شكاوى المواطنين</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.7+-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/GetX-State%20Management-purple" alt="GetX">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

---

## 📋 نظرة عامة

نظام متكامل لإدارة شكاوى المواطنين يتيح للمسؤولين متابعة ومعالجة الشكاوى بكفاءة عالية. يتميز التطبيق بواجهة مستخدم عصرية مستوحاة من iOS 26 مع دعم كامل للغة العربية.

---

## ✨ المميزات

### 🎯 إدارة الشكاوى
- عرض جميع الشكاوى مع فلترة متقدمة
- تغيير حالة الشكوى (جديدة، قيد المعالجة، محلولة، مرفوضة)
- عرض تفاصيل الشكوى مع الصور المرفقة
- سجل كامل لتحديثات كل شكوى
- البحث في الشكاوى

### 👥 إدارة المستخدمين
- عرض وإدارة جميع المستخدمين
- إضافة مستخدمين جدد (مواطن / مسؤول)
- تعديل بيانات المستخدمين
- تفعيل / تعطيل الحسابات
- رفع صور الملف الشخصي

### 📂 إدارة التصنيفات
- إنشاء تصنيفات للشكاوى
- تعديل وحذف التصنيفات
- ربط الشكاوى بالتصنيفات المناسبة

### ⭐ إدارة التقييمات
- عرض تقييمات المواطنين للخدمة
- إحصائيات التقييمات

### 📊 لوحة التحكم (Dashboard)
- إحصائيات شاملة في الوقت الفعلي
- رسوم بيانية تفاعلية
- نظرة سريعة على آخر الشكاوى

### 👤 الملف الشخصي
- عرض وتعديل بيانات المسؤول
- تغيير الصورة الشخصية
- تغيير كلمة المرور

---

## 🛠️ التقنيات المستخدمة

| التقنية | الاستخدام |
|---------|-----------|
| **Flutter 3.7+** | إطار العمل الأساسي |
| **Dart 3.0+** | لغة البرمجة |
| **GetX** | إدارة الحالة والتنقل |
| **Dio** | طلبات HTTP |
| **Get Storage** | التخزين المحلي |
| **FL Chart** | الرسوم البيانية |
| **Image Picker** | اختيار الصور |
| **Cached Network Image** | تخزين الصور مؤقتاً |

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                    # نقطة البداية
├── bindings/                    # حقن التبعيات
│   ├── app_binding.dart
│   ├── auth_binding.dart
│   ├── main_binding.dart
│   ├── dashboard_binding.dart
│   ├── users_binding.dart
│   ├── complaints_binding.dart
│   ├── categories_binding.dart
│   └── ratings_binding.dart
├── controllers/                 # المتحكمات (GetX)
│   ├── auth_controller.dart
│   ├── main_controller.dart
│   ├── dashboard_controller.dart
│   ├── users_controller.dart
│   ├── complaints_controller.dart
│   ├── categories_controller.dart
│   └── ratings_controller.dart
├── data/
│   ├── models/                  # نماذج البيانات
│   │   ├── user_model.dart
│   │   ├── complaint_model.dart
│   │   ├── category_model.dart
│   │   ├── rating_model.dart
│   │   └── auth_model.dart
│   ├── providers/               # مزودي البيانات (API)
│   │   ├── api_client.dart
│   │   ├── auth_provider.dart
│   │   ├── user_provider.dart
│   │   ├── complaint_provider.dart
│   │   ├── category_provider.dart
│   │   └── rating_provider.dart
│   └── repositories/            # المستودعات
│       ├── auth_repository.dart
│       ├── user_repository.dart
│       ├── complaint_repository.dart
│       ├── category_repository.dart
│       └── rating_repository.dart
├── routes/                      # التنقل
│   └── app_routes.dart
├── utils/                       # الأدوات المساعدة
│   ├── constants.dart
│   ├── helpers.dart
│   ├── app_colors.dart
│   ├── app_theme.dart
│   ├── storage_service.dart
│   └── image_service.dart
├── views/                       # واجهات المستخدم
│   ├── auth/
│   │   ├── login_view.dart
│   │   └── register_view.dart
│   ├── splash/
│   │   └── splash_view.dart
│   ├── main/
│   │   └── main_view.dart
│   ├── dashboard/
│   │   └── dashboard_view.dart
│   ├── users/
│   │   ├── users_view.dart
│   │   ├── user_details_view.dart
│   │   └── user_form_view.dart
│   ├── complaints/
│   │   ├── complaints_view.dart
│   │   └── complaint_details_view.dart
│   ├── categories/
│   │   ├── categories_view.dart
│   │   └── category_form_view.dart
│   ├── ratings/
│   │   └── ratings_view.dart
│   ├── profile/
│   │   ├── profile_view.dart
│   │   └── edit_profile_view.dart
│   └── settings/
│       └── settings_view.dart
└── widgets/                     # الويدجتس المشتركة
    ├── custom_button.dart
    ├── custom_text_field.dart
    ├── loading_widget.dart
    ├── empty_widget.dart
    ├── user_avatar.dart
    ├── status_badge.dart
    └── stat_card.dart
```

---


## 🎨 تغيير أيقونة التطبيق

1. ضع صورة الأيقونة في `assets/icon/app_icon.png` (1024x1024)

2. شغّل الأمر:
```bash
dart run flutter_launcher_icons
```

---

## 🎯 حالات الشكوى

| الحالة | اللون | الوصف |
|--------|-------|-------|
| 🟡 **pending** | أصفر | شكوى جديدة بانتظار المراجعة |
| 🔵 **in_progress** | أزرق | جاري العمل على الشكوى |
| 🟢 **resolved** | أخضر | تم حل الشكوى |
| 🔴 **rejected** | أحمر | تم رفض الشكوى |

---

## 🔐 صلاحيات المستخدمين

| النوع | الصلاحيات |
|-------|-----------|
| **admin** | كامل الصلاحيات - إدارة المستخدمين والشكاوى والتصنيفات |
| **citizen** | تقديم شكاوى ومتابعتها فقط |

---

## 🌙 الثيم

التطبيق يستخدم ثيم داكن (Dark Theme) مستوحى من iOS 26 مع:
- ألوان متدرجة أنيقة
- زوايا مستديرة حديثة
- تأثيرات glassmorphism
- رسوم متحركة سلسة

---

## 📦 التبعيات الرئيسية

```yaml
dependencies:
  get: ^4.6.6              # إدارة الحالة
  dio: ^5.4.3+1            # HTTP Client
  get_storage: ^2.1.1      # تخزين محلي
  fl_chart: ^0.68.0        # رسوم بيانية
  image_picker: ^1.0.8     # اختيار صور
  iconsax: ^0.0.8          # أيقونات
  animate_do: ^3.3.4       # رسوم متحركة
  intl: ^0.19.0            # تنسيق التاريخ
  cached_network_image: ^3.3.1  # تخزين الصور
```


---

## 👨‍💻 المطور

**نظام إدارة الشكاوى**

تم تطويره بـ ❤️ باستخدام Flutter


---

<p align="center">
  <strong>⭐ إذا أعجبك المشروع، لا تنسَ إعطاءه نجمة!</strong>
</p>