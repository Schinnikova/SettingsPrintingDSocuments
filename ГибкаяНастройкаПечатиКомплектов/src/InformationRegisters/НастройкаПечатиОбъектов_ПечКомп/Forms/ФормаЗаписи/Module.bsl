
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	ТаблицаОбъектовДляПечатиКомплектно = РегистрыСведений.НастройкиПечатиОбъектов.ТаблицаОбъектовДляПечатиКомплектно();
	Для Каждого ТекСтрока Из ТаблицаОбъектовДляПечатиКомплектно Цикл
		Элементы.ТипОбъекта.СписокВыбора.Добавить(ТекСтрока.ТипОбъекта, ТекСтрока.Представление);
	КонецЦикла;
	
	ПриИзмененииТипаОбъектаСервер();
	
	Если Не ПраваПользователяПовтИсп.ДобавлениеИзменениеНастройкиПечатиОбъектов() Тогда
		
		ТолькоПросмотр = Истина;
		
		Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
			Запись.Партнер = Неопределено;
		ИначеЕсли ЗначениеЗаполнено(Запись.Партнер) Тогда
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаУдалить", "Видимость", Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПраваПользователяПовтИсп.СохранениеНастроекПечатиОбъектовПоУмолчанию() Тогда
		
		Элементы.Организация.ТолькоПросмотр = Истина;
		
		Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
			Запись.Организация = Неопределено;
		ИначеЕсли ЗначениеЗаполнено(Запись.Организация) Тогда
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаУдалить", "Видимость", Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФормЗадан(КомплектПечатныхФорм, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ПраваПользователяПовтИсп.ДобавлениеИзменениеНастройкиПечатиОбъектов()
	 И ЗначениеЗаполнено(ТекущийОбъект.Партнер) Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет прав на запись настройки печати по партнеру'"));
		
	КонецЕсли;
	
	Если Не ПраваПользователяПовтИсп.СохранениеНастроекПечатиОбъектовПоУмолчанию()
	 И ЗначениеЗаполнено(ТекущийОбъект.Организация) Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет прав на запись настройки печати по организации'"));
		
	КонецЕсли;
	
	Если КомплектПечатныхФорм.НайтиСтроки(Новый Структура("Печатать", Истина)).Количество() = 0 Тогда
		
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Выберите хотя бы одну печатную форму.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КомплектПечатныхФорм");
		
	КонецЕсли;

	ТекущийОбъект.Настройки = Новый ХранилищеЗначения(КомплектПечатныхФорм.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_НастройкиПечатиОбъектов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	ПриИзмененииТипаОбъектаСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого ТекСтрока Из КомплектПечатныхФорм Цикл
		ТекСтрока.Печатать = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого ТекСтрока Из КомплектПечатныхФорм Цикл
		ТекСтрока.Печатать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	УстановитьСтандартныеНастройкиСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КомплектПечатныхФормЭкземпляров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомплектПечатныхФорм.Печатать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КомплектПечатныхФормПредставление.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КомплектПечатныхФормЭкземпляров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомплектПечатныхФорм.Печатать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

&НаСервере
Процедура УстановитьСтандартныеНастройкиСервер()
	
	Если Не ЗначениеЗаполнено(Запись.ТипОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	КомплектПечатныхФорм.Очистить();
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Запись.ТипОбъекта);
	КоллекцияПечатныхФорм = МенеджерОбъекта.КомплектПечатныхФорм();
	РегистрыСведений.НастройкиПечатиОбъектов.ДополнитьКомплектВнешнимиПечатнымиФормами(Запись.ТипОбъекта, КоллекцияПечатныхФорм);
	
	Для Каждого ТекСтрока Из КоллекцияПечатныхФорм Цикл
		
		НоваяСтрока = КомплектПечатныхФорм.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииТипаОбъектаСервер()
	
	ПараметрыОбъекта = РегистрыСведений.НастройкиПечатиОбъектов.ПараметрыОбъектаДляПечатиКомплектно(Запись.ТипОбъекта);
	
	Элементы.Организация.Доступность = ПараметрыОбъекта.ЕстьОрганизация;
	Элементы.Партнер.Доступность = ПараметрыОбъекта.ЕстьПартнер;
	Элементы.КомплектПечатныхФорм.Доступность = ПараметрыОбъекта.ДоступнаПечатьКомплекта;
	
	Если Не ПараметрыОбъекта.ЕстьОрганизация Тогда
		Запись.Организация = Неопределено;
	КонецЕсли;
	
	Если Не ПараметрыОбъекта.ЕстьПартнер Тогда
		Запись.Партнер = Неопределено;
	КонецЕсли;
	
	Если ПараметрыОбъекта.ДоступнаПечатьКомплекта Тогда
		
		ЗаписьОбъект = РеквизитФормыВЗначение("Запись");
		ЗаписьОбъект.Прочитать();
		СохраненноеЗначение = ЗаписьОбъект.Настройки.Получить();
		
		// Настройки по умолчанию
		Если СохраненноеЗначение = Неопределено Тогда
			УстановитьСтандартныеНастройкиСервер();
		Иначе
			КомплектПечатныхФорм.Загрузить(СохраненноеЗначение);
		КонецЕсли;
		
	Иначе
		
		КомплектПечатныхФорм.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
