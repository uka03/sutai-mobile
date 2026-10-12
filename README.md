# Сутай зах

Сутай зах нь бараа хайх, ангилал болон шошгоор шүүх, сагсанд бараа нэмэх,
захиалга удирдах боломжтой Flutter апп юм.

## Шаардлага

- Flutter SDK (Dart SDK `3.11.5` буюу түүнээс дээш хувилбартай)
- Android Studio эсвэл Xcode — ажиллуулах төхөөрөмжөөс хамаарна
- `flutter doctor`-оор Flutter болон платформын хэрэгслүүдээ шалгана

## Суулгах

Төслийн эх кодыг авсны дараа төслийн үндсэн хавтас руу орж dependency-үүдийг
татна:

```bash
cd sutai
flutter pub get
```

Тусгай `.env` файл шаардлагагүй. API үндсэн хаяг `lib/core/constants.dart` файлд
тохируулагдсан:

```text
https://job.sutainbuyant.com/api/v1
```

## Ажиллуулах

Холбогдсон төхөөрөмж эсвэл emulator-аа сонгоод:

```bash
flutter devices
flutter run
```

Тодорхой төхөөрөмж дээр ажиллуулах бол төхөөрөмжийн ID-г ашиглана:

```bash
flutter run -d <device-id>
```

## Build хийх

```bash
flutter build apk
flutter build appbundle
flutter build ios
```

iOS build хийхэд macOS болон Xcode шаардлагатай.

## Ашигласан технологиуд

- **Flutter, Dart** — Android болон iOS аппын UI, бизнес логик
- **Riverpod (`flutter_riverpod`)** — төлөв болон өгөгдлийн урсгалын удирдлага
- **Dio** — REST API хүсэлт, interceptor болон алдааны боловсруулалт
- **GoRouter** — хуудас хоорондын навигаци
- **`infinite_scroll_pagination`** — бүтээгдэхүүний хайлтын хуудасны хязгааргүй
  гүйлгэлт
- **`shared_preferences`** — хүслийн жагсаалтыг төхөөрөмж дээр хадгалах
- **`flutter_secure_storage`** — нэвтрэлтийн token болон хэрэглэгчийн мэдээллийг
  хамгаалалттай хадгалах
- **`cached_network_image`, `flutter_cache_manager`** — зургийг cache-лах
- **`json_serializable`, `json_annotation`, `build_runner`** — API өгөгдлийг
  typed model болгон хөрвүүлэх
- **`fluttertoast`** — амжилт болон алдааны мэдэгдэл харуулах

## JSON model үүсгэх

`json_serializable` model өөрчилсөн эсвэл шинээр нэмсэн үед generated файлуудыг
шинэчилнэ:

```bash
dart run build_runner build --delete-conflicting-outputs
```
# sutai-mobile
