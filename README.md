# 📱 Easy Chat App & Social Marketplace

![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Supported-FFCA28?logo=firebase)
![Architecture](https://img.shields.io/badge/Architecture-Clean--Architecture%20%2B%20Cubit-purple)
![License](https://img.shields.io/badge/License-MIT-green)

تطبيق متكامل يجمع بين **منصة تواصل اجتماعي (Social Media Platform)**، **تطبيق دردشة فورية (Real-Time Chat)**، و**متجر إلكتروني (E-Commerce Marketplace)** مع دعم خدمات الدفع الإلكتروني بـ Paymob والإشعارات اللحظية بـ Firebase Cloud Messaging.

---

## 📽️ فيديو الشرح والتجربة الحية (Demo Video)

يمكنك مشاهدة الاستعراض الشامل والتفصيلي لتصميم التطبيق وجميع الميزات والتفاعلات من خلال الرابط التالي:

🎥 **[شاهد فيديو استعراض التطبيق كاملاً](https://github.com/user-attachments/assets/20e530fe-4689-458b-ba60-dc215c28ebab)**

---

## ✨ المميزات الرئيسية (Features)

### 1. 🔐 تسجيل الدخول والمصادقة (Auth & Onboarding)
* تسجيل الدخول وإنشاء حساب بـ Email & Password عبر **Firebase Auth**.
* تسجيل الدخول السريع بنقرة واحدة عبر **Google Sign-In**.
* حفظ بيانات واعتمدات الجلسة محلياً باستخدام `CacheHelper` و `SharedPreferences`.

### 2. 💬 المحادثات والدردشة المباشرة (Real-Time Chat)
* محادثات فردية (One-to-One Chat) بالوقت الفعلي بستريم محلي من **Cloud Firestore**.
* إرسال واستقبال الرسائل مع إظهار حالة القراءة (Read Status) والوقت الزمني.
* شاشة إشعارات لحظية تفتح المحادثة مباشرة بمجرد النقر عليها.

### 3. 📰 التغذية الإخبارية والمنشورات (Home Feed & Social Posts)
* إنشاء منشورات نصية وإرفاق صور يتم رفعها على سيرفرات **ImgBB**.
* التفاعل بالإعجاب (Like) والتعليق (Comments) التفاعلي بستريم مباشر.
* إمكانية فتح الصورة بجودة كاملة والتفاعل معها داخل شاشة منفصلة (مثل الفيسبوك).
* إمكانية حذف المنشور الخاص بكاتبه فقط عبر قائمة التخيير.

### 4. 📸 الحالات والستوري (Stories & Status)
* إضافة ستوري نصية بخلفيات ملونة أو صور مخصصة.
* حذف الستوري بالضغط المطول.

### 5. 🎬 مشاهدة المقاطع القصيرة (Watch / Reels)
* عرض فيديوهات رأسيّة بجودة عالية ومعالجة الـ Continuous Play.
* رفع مقاطع الفيديو وتخزينها عبر **Cloudinary API**.
* التفاعل بالإعجاب وحذف الفيديو الخاص بالمستخدم.

### 6. 🛒 المتجر الإلكتروني (Marketplace & Payments)
* استعراض المنتجات والبحث السريع المباشر بدعم من **AliExpress RapidAPI**.
* عرض تفاصيل المنتج الكاملة، السعر، والضمان.
* بوابة دفع إلكتروني متكاملة عبر **Paymob API** مدمجة في شاشة `WebView`.

### 7. 👤 البروفايل المخصص والثيم (Profile & Customization)
* تغيير صورة البروفايل عبر الكاميرا أو المعرض بـ `ImagePicker`.
* التبديل بين الثيم المظلم (Dark Mode) والثيم الفاتح (Light Mode) عبر **ThemeCubit**.
* تصفح بروفايلات المستخدمين الآخرين ومشاهدة منشوراتهم الخاصة فقط.

---

## 🛠️ تقنيات وتطبيقات البناء (Tech Stack)

* **UI & Core:** Flutter Framework (Dart)
* **State Management:** Flutter BLoC / Cubit Architecture
* **Database & Auth:** Firebase Auth, Cloud Firestore
* **Notifications:** Firebase Cloud Messaging (FCM) & `flutter_local_notifications`
* **Network & API:** Dio, Http, Pretty Dio Logger
* **Media Storage:** ImgBB API, Cloudinary
* **Payment Gateways:** Paymob Accept SDK (WebView)
* **Local Storage:** SharedPreferences

---

## ⚠️ تنبيهات أمنية وإعدادات البيئة (Security & Config)

> **ملاحظة مهمة:** تم سحب وإخفاء جميع مفاتيح API والحسابات الحساسة لحماية المشروع قبل الرفع على GitHub.

### 1. ملف المتغيرات البيئية (`.env`)
يجب عليك إنشاء ملف باسم `.env` في جذر المشروع (Root Directory) يحتوي على المتغيرات التالية:

```env
GOOGLE_WEB_CLIENT_ID=your_google_web_client_id
IMGBB_API_KEY=your_imgbb_api_key
PAYMOB_API_KEY=your_paymob_api_key
PAYMOB_INTEGRATION_ID=your_paymob_integration_id
PAYMOB_IFRAME_ID=your_paymob_iframe_id
RAPIDAPI_KEY=your_rapidapi_key
RAPIDAPI_HOST=aliexpress-business-api.p.rapidapi.com
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_UPLOAD_PRESET=your_cloudinary_upload_preset
