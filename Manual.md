# SQUtils

Описание классов и категорий, инструкция по эксплуатации

##Categories

###NSArray+SQExtended

Набор расширений для работы с массивами
Методы:

* ```objective-c
//Обертка над objectAtIndex:. Возвращает nil, если индекс находится за пределами массива
- (id)sq_objectAtIndexOrNil:(NSInteger)index
```

* ```objective-c
- (NSArray*)sq_map: (id(^)(id obj)) block
//Изменяет все объекты массива согласно block и формирует из них новый массив. Пример: обработать массив собак и вернуть новый, в котором все их имена написаны с большой буквы
NSArray *newArray = [oldArray sq_map:^(Dog *dog){
  		return [dog.name capitalizedString];
  	}];
```