# Dinçer Health Control Service

Dinçer Health Control Service, belirli bir süre boyunca çeşitli API adreslerini sürekli kontrol eden ve hata aldığında bildirim gönderen otomatik API kontrol hizmetidir. Bu uygulama, Flutter, Firebase, Firebase Firestore, Hive, flutter_background_service, device_info_plus, Dio ve push_notification gibi teknolojileri kullanmaktadır.

## Kullanılan Teknolojiler

- Flutter
- Firebase
- Firebase Firestore
- Hive
- flutter_background_service
- device_info_plus
- Dio
- push_notification

## Uygulama Açıklaması

Dinçer Health Control Service, kullanıcıların belirli API adreslerini düzenli olarak kontrol edebilmelerini sağlar. Uygulama belirli bir süre boyunca API adreslerini kontrol eder ve herhangi bir hata durumunda kullanıcıya bildirim gönderir. Böylece, hatalı API adreslerini hızlı bir şekilde tespit edebilir ve müdahale edebilirsiniz.

## Kurulum

1. Bu projeyi klonlayın veya indirin.
2. Firebase hesabınızı oluşturun ve proje oluşturun.
3. Firebase projesinizin kimlik bilgilerini `google-services.json` dosyası ile projenizin `android/app` dizinine ekleyin.
4. `pubspec.yaml` dosyasında belirtilen bağımlılıkları yükleyin: `flutter pub get`.
5. Uygulamayı çalıştırın: `flutter run`.

## Ekran Görüntüleri

![Ekran Görüntüsü 1](screenshots/screenshot1.png)
![Ekran Görüntüsü 2](screenshots/screenshot2.png)

## Katkıda Bulunma

1. Bu projeyi fork edin.
2. Yeni bir dal (branch) oluşturun: `git checkout -b feature/xyz`.
3. Değişikliklerinizi yapın ve bunları işleyin (commit): `git commit -am 'Add some xyz'`.
4. Dalınıza (branch) itme yapın: `git push origin feature/xyz`.
5. Bir Pull Request açın.

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasını inceleyin.
