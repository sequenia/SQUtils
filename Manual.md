# SQUtils

Описание классов и категорий, инструкция по эксплуатации

##Categories

Категории-надстройки над основными классами UIKit и Foundation. Большинство функций имеют "говорящие" названия, но к некоторым будут указаны поясниения

###Примеры и пояснения

####NSArray+SQExtended
`sq_map` - совершает действия, описанные в `block`, и возвращает новый массив. Пример: вернуть массив имен собак, написанных большими буквами
```objective-c
NSArray *newArray = [oldArray sq_map:^(Dog *dog){
  		return [dog.name capitalizedString];
  	}];
```
`sq_filter` - фильтрует массив согласно условиям, описанным в `block`. Пример: вернуть собак, младше двух лет:
```objective-c
NSArray *filteredArray = [fullArray sq_filter:^(Dog *dog){
  		return dog.age < 2;
  	}];
```

####NSMutableArray+SQExtended
`sq_enqueue`, `sq_dequeue`, `sq_peek` - эмуляция работы очереди на основе `NSMutableArray`

####NSString+SQExtended
`sq_decodeNetworkError` - переводит сообщения CFNetworkError на "человеческий" язык. Настроена обработка 5 кодов ошибок: 
* `kCFURLErrorCannotFindHost, kCFURLErrorCannotConnectToHost, kCFURLErrorNetworkConnectionLost, kCFURLErrorNotConnectedToInternet` - "Отсутствует подключение к Интернету" (`SQNoConnectionDesc`)
* `kCFURLErrorTimedOut` - "Медленное соединение" (`SQSlowConnectionDesc`)
* остальные случаи - "Ошибка на сервере" (`SQServerErrorDesc`)
При необходимости набор обработанных ошибок можно расширить на основе материалов [документации](https://developer.apple.com/library/mac/documentation/Networking/Reference/CFNetworkErrors/index.html#//apple_ref/c/tdef/CFNetworkErrors)

`sq_stringForCount` - возвращает окончание для множественного числа слова на основании числа и массива окончаний. 
	`NSInteger count` -  число на основе которого нужно сформировать окончание
	`NSArray* words`- массив слов или окончаний для чисел (1, 4, 5, 0). Например ['яблоко', 'яблока', 'яблок', 'нет яблок']

####UIColor+SQExtended
`sq_colorWithRGBString:` - возвращает цвет из RGBA-строки
`sq_encodeToRGBString:` - кодирует цвет в RGBA-строку

##Classes
Набор полезных классов для ускорения работы с теми или иными операциями

###Примеры и руководства по эксплуатации

####SQPhotoPicker
Позволяет загружать фотографии из галереи телефона или из камеры телефона. Сделан по образу iMessage и Telegram. Чтобы использовать класс необходимо:
* Импортировать `<SQPhotoPicker.h>`
* Настроить максимально возможное для выбора количество фотографий
* Вызвать picker с помощью метода `presentInViewController:`

```objective-c
    SQPhotoPickerSheet *picker = [[SQPhotoPickerSheet alloc] init];
	picker.maxImagesCount = 15;
    [picker presentInViewController:self withCompletionAction:^(SQPhotoPickerSheet *picker, NSArray *returnedImages) {
        for(SQPhoto *photo in returnedImages){
        	//Обработайте полученный массив SQPhoto с помошью асинхронного...
            [photo getPhotoOriginalAsync:^(UIImage *originalPhoto) {
            }];
			//...либо синхронного метода
			UIImage *image = [photo getPhotoOriginalSync];
        }
    }];
```

####SQEdgedCollectionViewController
Позволяет отрисовать горизонтальный слайдер с видимыми частями соседних ячеек. Для использования класса необходимо:
* Отнаследуйте свой контроллер от класса `SQEdgedCollectionViewController`
* Задайте ширину метрики ячейкам (ширина, высота, расстояния между ячейками и отступы от краев экрана)
* С помощью методов `setPageControllBottomSpacing:` или `setCollectionViewTopSpacing:(CGFloat) height:(CGFloat) controllSpacing:(CGFloat)` задайте положение индикатора страниц
* При необходимости измените цвет индикатору страниц
* Зарегистрируйте xib-ы ячеек, которые хотите отображать в коллекции
* С помощью метода `setContent:` задайте содержимое галереи
* Перегрузите методы `cellForItemAtIndexPath:` и `didSelectItemAtIndexPath:` чтобы настроить содержимое ячеек и обработать клики по ним 
* ?????
* PROFIT! Галерея готова к работе

####SQEndlessCollectionView
Позволяет отрисовать бесконечный горизонтальный слайдер с возможностью автоматического листания элементов. Для использования класса необходимо:
* Отнаследуйте свой контроллер от класса `SQEndlessCollectionView`
* Включите (или выключите) возможность автоматического листания (`timerEnabled`) и интервал переключения элементов (`timerLength`)
* С помощью метода `setPageControllBottomSpacing:` задайте положение индикатора страниц
* При необходимости измените цвет индикатору страниц
* Зарегистрируйте xib-ы ячеек, которые хотите отображать в коллекции
* С помощью метода `setContent:` задайте содержимое галереи
* Перегрузите методы `cellForItemAtIndexPath:` и `didSelectItemAtIndexPath:` чтобы настроить содержимое ячеек и обработать клики по ним 
* ?????
* PROFIT! Галерея готова к работе

