//
//  NSString+SQExtended.h
//  VseMayki
//
//  Created by Sequenia on 17/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const SQNoConnectionDesc =   @"Отсутствует подключение к Интернету";
static NSString * const SQSlowConnectionDesc = @"Медленное соединение";
static NSString * const SQServerErrorDesc =    @"Ошибка на сервере";
static NSString * const SQParseErrorDesc =     @"Неопознанный ответ сервера";

@interface NSString (SQExtended)

- (BOOL)sq_containsString:(NSString *)str;

- (BOOL)sq_containsString:(NSString *)str options:(NSStringCompareOptions)options;

/**
 * Возвращает описание сетевой ошибки по NSError
 */
+ (NSString *)sq_decodeNetworkError:(NSError *)error;

/**
 * Метод возвращает окончание для множественного числа слова на основании числа и массива окончаний
 * count NSInteger Число на основе которого нужно сформировать окончание
 * words NSArray Массив слов или окончаний для чисел (1, 4, 5, 0),
 *       например ['яблоко', 'яблока', 'яблок', 'нет яблок']
 */
+ (NSString*)sq_stringForCount:(NSInteger)count
                   withWords:(NSArray*)words;

/**
 * Кодирует строку в подходящий для URL формат
 */
+ (NSString *)sq_encodeStringForURL:(NSString *)string;

/**
 * Собирает строку из массива
 * arrray NSArray - массив, который нужно конвертировать в строку
 * splitter NSString - разделитель между словами в строке
 */
+ (NSString *)sq_constructStringFromArray:(NSArray *)array
                            withSpliter:(NSString *)splitter;

- (BOOL)sq_isEmpty;

- (BOOL)sq_isEmail;

- (NSString*)sq_uppercaseFirstLetterString;

- (NSString *)sq_md5;

- (NSString *)sq_sha1;

@end
