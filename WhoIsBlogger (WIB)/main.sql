/*
А) какую сумму в среднем в месяц тратит:
пользователи в возрастном диапазоне от 18 до 25 лет включительно
пользователи в возрастном диапазоне от 26 до 35 лет включительно 

Б) в каком месяце года выручка от пользователей в возрастном 
диапазоне 35+ самая большая

В) какой товар обеспечивает дает наибольший вклад в выручку за последний год 

Г) топ-3 товаров по выручке и их доля в общей выручке за любой год
*/

select * from 

select 
	avg(price) 
From (
  select 
      purchaseId,
      purchases.userId,
      purchases.itemId,
      dtd,
      age,
      price
  from purchases
  left JOIN users
  	on purchases.userId = users.userId
  left JOIN items
  	on purchases.itemId = items.itemId
	)
