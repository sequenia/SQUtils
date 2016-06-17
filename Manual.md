# SQUtils

Описание классов и категорий, инструкция по эксплуатации

##Categories

###NSArray+SQExtended

Набор расширений для работы с массивами
Методы:

* ```objective-c - (id)sq_objectAtIndexOrNil:(NSInteger)index```
Обертка над ```objective-c objectAtIndex:```, возвращает ``nil``, если индекс находится за пределами массива
* ```objective-c - (NSArray*)sq_map: (id(^)(id obj)) block```
Изменяет все объекты массива согласно ``block`` и формирует из них новый массив. Пример:
```
//Возвращает массив имен собак, написанных с большой буквы
NSArray *newArray = [oldArray sq_map:^(Dog *dog){
  		return [dog.name capitalizedString];
    }];
```