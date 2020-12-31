# Bus42App

Неофициальное мобильное приложение портала [bus42.info](https://bus42.info/navi/index.html). Расписание общественного транспорта для жителей Кемеровской области.


## Особенности

- Расписание транспорта на любой остановке
- Закладки
- Нет рекламы
- Material дизайн
- Малый размер и высокая скорость работы

## Скачать
Пользователь Android могут скачать `.apk` файл со [страницы релизов](https://github.com/raitonoberu/bus42app/releases/latest).


## Скриншоты

### Выбор типа транспорта и маршрута:
<details>
    <summary>Скриншот</summary>
    <img src="screenshots/timetable.png?raw=true" width="300"/>
</details>

### Выбор направления и остановки:
<details>
    <summary>Скриншот</summary>
    <img src="screenshots/selector.png?raw=true" width="300"/>
</details>

### Демонстрация расписания:
<details>
    <summary>Скриншот</summary>
Одно из двух представлений на выбор.
<p float="left">
    <img src="screenshots/grid.png?raw=true" width="300"/>
    <img src="screenshots/list.png?raw=true" width="300"/>
</p>
</details>

### Боковое меню:
<details>
    <summary>Скриншот</summary>
    <img src="screenshots/drawer.png?raw=true" width="300"/>

[Background vector created by rawpixel.com - www.freepik.com](https://www.freepik.com/vectors/background)
</details>

### Закладки:
<details>
    <summary>Скриншот</summary>
    <img src="screenshots/bookmarks.png?raw=true" width="300"/>
</details>


## Сборка

Это приложение написано на языке программирование Dart с использованием Flutter.

Предположим, что Вы уже установили [Flutter SDK](https://flutter.dev/). Запустите приложение следующим образом:

```bash
git clone https://github.com/raitonoberu/bus42app.git
cd bus42app
flutter run
```
Это запустит приложение в режиме отладки. Используйте параметр `--release`, чтобы получить оптимальную производительность.

Чтобы собрать `.apk` файл, напишите в терминал:
```bash
flutter build apk
```

## Лицензия

The Unlicense, подробнее в файле [LICENSE](LICENSE) и на [unlicense.org](https://unlicense.org/).