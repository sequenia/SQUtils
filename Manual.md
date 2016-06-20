# SQUtils

Описание классов и категорий, инструкция по эксплуатации

##Categories

Категории-надстройки над основными классами UIKit и Foundation. Большинство функций имеют "говорящие" названия, но к некоторым будут указаны поясниения

###Foundation
* `<NSArray+SQExtended.h>`
	- `- (id)sq_objectAtIndexOrNil:(NSInteger)index`
	- `- (NSArray *)sq_map:(id(^)(id obj))block`
	- `- (NSArray *)sq_filter:(BOOL(^)(id obj))block`
* `<NSData+SQExtended.h>`
	- `- (NSString *)sq_md5Hash`
* `<NSDate+SQExtended.h>`
	- `+ (NSDate *)sq_GMTDate`
	- `+ (NSDateFormatter *)sq_dateFormatterDateOnly`
	- `+ (NSDateFormatter *)sq_dateFormatterTimeOnly`
	- `+ (NSDateFormatter *)sq_dateFormatter`
* `<NSDictionary+SQExtended.h>`
	- `- (NSString *)sq_urlEncodedString`
	- `- (NSArray*)sq_valuesForKeys:(NSArray *)keys`
* `<NSError+SQExtended.h>`
	- `+ (instancetype) applicationErrorWithDescription: (NSString*) description`
	- `+ (instancetype) applicationErrorWithCode: (NSInteger) errorCode andDescription: (NSString*) description`
* `<NSMutableArray+SQExtended.h>`
	- `- (void)sq_enqueue: (id) object`
	- `- (id)sq_dequeue`
	- `- (id)sq_peek`
* `<NSString+SQExtended.h>`
	- `- (BOOL)sq_containsString:(NSString *)str`
	- `+ (NSString *)sq_decodeNetworkError:(NSError *)error`
	- `+ (NSString*)sq_stringForCount:(NSInteger)count withWords:(NSArray*)words`
	- `+ (NSString *)sq_encodeStringForURL:(NSString *)string`
	- `+ (NSString *)sq_constructStringFromArray:(NSArray *)array withSpliter:(NSString *)splitter`
	- `- (BOOL)sq_isEmpty`
	- `- (BOOL)sq_isEmail`
	- `- (NSString*)sq_uppercaseFirstLetterString`
	- `- (NSString *)sq_md5`
	- `- (NSString *)sq_sha1`
###Примеры и пояснения

####NSArray+SQExtended----
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

`sq_stringForCount` - возвращает окончание для множественного числа слова на основании числа (1, 4, 5, 0) и массива окончаний ['яблоко', 'яблока', 'яблок', 'нет яблок']

