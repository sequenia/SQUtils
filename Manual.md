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

