--Postgreesql
/*--БД
create table Группа
(
       КодГруппы integer primary key
       ,Группа   varchar(255) not null unique
)
;
create table Товар
(
       КодТовара  integer primary key
       ,КодГруппы integer not null references Группа (КодГруппы)
       ,Товар     varchar(255) not null unique
)
;
create table Закупка
(
       КодЗакупки  integer  primary key
       ,Дата       date  not null
       ,КодТовара  integer   not null references Товар (КодТовара)
       ,Цена       money not null
       ,Количество integer   not null

       ,constraint UQ_НеБольшеОднойЗакупкиКонкретногоТовараВДень unique
       (
             Дата
             ,КодТовара
       )
)
;
create table Продажа
(
       КодПродажи  integer primary key
       ,КодТовара  integer   not null references Товар (КодТовара)
       ,Дата         date  not null
       ,КодЗакупки integer   not null references Закупка (КодЗакупки)
       ,Цена         money not null
       ,Количество integer   not null
  )
;
*/

/*Задание: Написать запросы select на языке sql для решения поставленных задач 
(ниже – текст задач, er-диаграмма базы данных и ddl-скрипт для генерации модели 
базы данных (Microsoft SQL Server)).
Желательно использовать либо чистый sql (из стандарта), либо один из следующих 
диалектов: SQL Server t-sql, Postgree pl/pg sql, Oracle pl sql (укажите, что 
вы выбрали в итоге).
*/

/*Задание 1. Найти текущие товарные остатки на складе в закупочных ценах в разрезе товарных групп.
*/
select 
	КодГруппы,
	a.КодТовара,
	Цена,
	Количество
from (
	select -- определяем количество товаров с одинаковой ценой в разные закупуки
		КодТовара,
		Цена,
		sum(Количество) as Количество
	from (
		select 
			КодТовара,
			Цена,
			Количество - (
				select  --определяем остаток товара в разные закупуки
					Количество
				from Продажа
				where 1=1
					and Закупка.КодЗакупки = Продажа.КодЗакупки
					and Закупка.КодТовара = Продажа.КодТовара
				) as Количество
		from Закупка
		) as b
	group by КодТовара, Цена
	) as a
Left join Товар
	on a.КодТовара = Товар.КодТовара
order by КодГруппы, a.КодТовара, Цена


/*Задание 2. Найти top 3 товарные группы с наибольшим средневзвешенным по сумме продаж 
процентом наценки. 

При расчёте учитывать только товары с продажами (и относящимися к ним закупками) 
за указанный период (параметры запроса – ДатаС, ДатаПо). 
Средневзвешенный по продажам процент наценки считается так:

СрВзПоПродажеПроцентНаценки = (ПроцентНаценкиПродажи + СуммаПродажи) / СуммаПродажи

,где

СуммаПродажи = КоличествоПродаж * ЦенаПродажи

ПроцентНаценкиПродажи = (ЦенаПродажи - ЦенаЗакупки ) / ЦенаЗакупки
*/
select
	КодГруппы,
	sum(СрВзПоПродажеПроцентНаценки) as ГрпвСрВзПоПродажеПроцентНаценки
from (
	select 
		Продажа.Дата,
		--Продажа.КодТовара,
		Товар.КодГруппы,
		--Продажа.Цена as ЦенаПродажи,
		--Закупка.Цена as ЦенаЗакупки,
		--Продажа.Количество
		--(Продажа.Количество * CAST(Продажа.Цена as numeric)) as СуммаПродажи,
		--CAST((Продажа.Цена - Закупка.Цена) / Закупка.Цена as numeric) as ПроцентНаценкиПродажи
		(CAST((Продажа.Цена - Закупка.Цена) / Закупка.Цена as numeric) 
			+ (Продажа.Количество * CAST(Продажа.Цена as numeric))) 
				/ (Продажа.Количество * CAST(Продажа.Цена as numeric)) as СрВзПоПродажеПроцентНаценки
	from Продажа
	left join Закупка
		on Закупка.КодЗакупки = Продажа.КодЗакупки and Закупка.КодТовара = Продажа.КодТовара
	left join Товар
		on Продажа.КодТовара = Товар.КодТовара
	) as a
where Дата
WHERE 1=1 
    and Дата >= '2024-02-01'
	and Дата <  '2024-03-01'
group by КодГруппы
ORDER BY sum(СрВзПоПродажеПроцентНаценки) DESC --порядок ТОПа
LIMIT 3;
	
/*Задание 3. Вывести все товары (по одной записи на товар), у которых цена последней 
закупки отличается больше, чем на 50% от цены предыдущей закупки.
*/
