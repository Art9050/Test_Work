create table Users(
    userId serial not null primary key, 
    age varchar(10)
    );
	
create table Items (
  itemId int generated always as identity (start 1000) primary key,
  price numeric(18,2) not null
);	
	
create table Purchases(
	purchaseId int generated always as identity (start 10000) primary key, 
	userId int REFERENCES Users, 
	itemId int REFERENCES Items, 
	dtd date
	);

insert into Users(age) values
('08.02.2006');
('10.04.2005'),
('15.09.2004'),
('03.12.1999'),
('07.12.1998'),
('13.11.1997'),
('19.12.1996'),
('20.01.1989'),
('10.05.1988'),
('14.08.1987'),
('30.11.1986'),
('26.01.1985'),
('24.01.1984'),
('28.02.1983'),
('02.03.1982');	

insert into Items(price) values
(110.1),
(11.2),
(12.3),
(13.4),
(134.5),
(15.6),
(86.7),
(17.81),
(168.9),
(20);
	
insert into Purchases(userId, itemId, dtd) values
('1', '1000', '2022.01.12'),
('2', '1001', '2022.02.12'),
('3', '1002', '2022.03.12'),
('4', '1003', '2022.04.12'),
('5', '1004', '2022.05.12'),
('6', '1005', '2022.06.12'),
('7', '1006', '2022.07.12'),
('8', '1007', '2022.08.12'),
('9', '1008', '2022.09.12'),
('10', '1009', '2022.10.12'),
('11', '1009', '2022.11.12'),
('12', '1000', '2022.12.12'),
('13', '1001', '2022.01.12'),
('14', '1002', '2022.02.12'),
('15', '1003', '2022.03.12');
