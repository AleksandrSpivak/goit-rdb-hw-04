-- a) Назва схеми — “LibraryManagement”

CREATE SCHEMA IF NOT EXISTS LibraryManagement;

USE LibraryManagement;


/* b) Таблиця "authors":
author_id (INT, автоматично зростаючий PRIMARY KEY)
author_name (VARCHAR)
*/

CREATE TABLE IF NOT EXISTS authors
(
author_id INT auto_increment primary key,
author_name varchar(255)
);


/* c) Таблиця "genres":

genre_id (INT, автоматично зростаючий PRIMARY KEY)
genre_name (VARCHAR)
*/

create table if not exists genres
(
genre_id INT auto_increment primary key,
genre_name VARCHAR(255)
);


/*
d) Таблиця "books":

book_id (INT, автоматично зростаючий PRIMARY KEY)
title (VARCHAR)
publication_year (YEAR)
author_id (INT, FOREIGN KEY зв'язок з "Authors")
genre_id (INT, FOREIGN KEY зв'язок з "Genres")
*/

create table if not exists books
(
book_id INT auto_increment primary key,
title VARCHAR(255),
publication_year YEAR,
author_id INT,
genre_id INT,

foreign key (author_id) references authors(author_id),
foreign key (genre_id) references genres(genre_id)
);


/*
e) Таблиця "users":

user_id (INT, автоматично зростаючий PRIMARY KEY)
username (VARCHAR)
email (VARCHAR)
*/

create table if not exists users
(
user_id INT auto_increment primary key,
username VARCHAR(255),
email VARCHAR(255)
);


/*
f) Таблиця "borrowed_books":
borrow_id (INT, автоматично зростаючий PRIMARY KEY)
book_id (INT, FOREIGN KEY зв'язок з "Books")
user_id (INT, FOREIGN KEY зв'язок з "Users")
borrow_date (DATE)
return_date (DATE)
*/

create table if not exists borrowed_books
(
borrow_id INT auto_increment primary key,
book_id INT,
user_id INT,
borrow_date DATE,
return_date DATE,

foreign key (book_id) references books(book_id),
foreign key (user_id) references users(user_id)
);


-- 2. Заповніть таблиці простими видуманими тестовими даними. Достатньо одного-двох рядків у кожну таблицю

insert into authors
(author_name)
values
('Joe Abercrombie'), ('James Klavell');

select * from authors;


insert into genres
(genre_name)
values
('drama'), ('historic'), ('non fiction');

select * from genres;


insert into books
(title, publication_year, author_id, genre_id)
values
('Half world', 2020, 1, 3), 
('Shogun', 1988, 2, 2 );

select * from books;


insert into users
(username, email)
values
('Smith', 'ss@gmail.com'), ('G_Konrad', 'gk@gmail.com');

select * from users;


insert into borrowed_books
(book_id, user_id, borrow_date, return_date)
values
(1, 2, '2024-06-01', '2024-06-14'),
(2, 1, '2024-08-01', null);

select * from borrowed_books


/* 3. Перейдіть до бази даних, з якою працювали у темі 3. Напишіть запит за допомогою операторів FROM та INNER JOIN, 
що об’єднує всі таблиці даних, які ми завантажили з файлів: order_details, orders, customers, products, categories, 
employees, shippers, suppliers. Для цього ви маєте знайти спільні ключі.
Перевірте правильність виконання запиту.
*/

use hw_03;

select * from orders as o
inner join order_details as od on o.id = od.order_id
inner join customers as cs on o.customer_id = cs.id
inner join products as pr on od.product_id = pr.id
inner join categories as ca on pr.category_id = ca.id
inner join employees as em on o.employee_id = em.employee_id
inner join shippers as sh on o.shipper_id = sh.id
inner join suppliers as sp on pr.supplier_id = sp.id;


-- 4. Виконайте запити, перелічені нижче.

-- a. Визначте, скільки рядків ви отримали (за допомогою оператора COUNT).
select count(*) from orders as o
inner join order_details as od on o.id = od.order_id
inner join customers as cs on o.customer_id = cs.id
inner join products as pr on od.product_id = pr.id
inner join categories as ca on pr.category_id = ca.id
inner join employees as em on o.employee_id = em.employee_id
inner join shippers as sh on o.shipper_id = sh.id
inner join suppliers as sp on pr.supplier_id = sp.id;


-- b. Змініть декілька операторів INNER на LEFT чи RIGHT. Визначте, що відбувається з кількістю рядків. Чому? 
select count(*) from orders as o
left join order_details as od on o.id = od.order_id
right join customers as cs on o.customer_id = cs.id
left join products as pr on od.product_id = pr.id
left join categories as ca on pr.category_id = ca.id
left join employees as em on o.employee_id = em.employee_id
left join shippers as sh on o.shipper_id = sh.id
left join suppliers as sp on pr.supplier_id = sp.id;

-- При зміні inner join на left join або right join кількість строк або лишається без змін 
-- (тільки якщо в обох таблицях повне співпадіння по записах),
-- або збільшується за рахунок тих записів, які є тільки в таблиці зліва або зправа відповідно


-- c. Оберіть тільки ті рядки, де employee_id > 3 та ≤ 10.
select count(*) from orders as o
inner join order_details as od on o.id = od.order_id
inner join customers as cs on o.customer_id = cs.id
inner join products as pr on od.product_id = pr.id
inner join categories as ca on pr.category_id = ca.id
inner join employees as em on o.employee_id = em.employee_id
inner join shippers as sh on o.shipper_id = sh.id
inner join suppliers as sp on pr.supplier_id = sp.id
where o.employee_id > 3 and o.employee_id <= 10;


-- d. Згрупуйте за іменем категорії, порахуйте кількість рядків у групі, середню кількість товару 
-- (кількість товару знаходиться в order_details.quantity)

select ca.name, count(*), avg(od.quantity) 
from orders as o
inner join order_details as od on o.id = od.order_id
inner join customers as cs on o.customer_id = cs.id
inner join products as pr on od.product_id = pr.id
inner join categories as ca on pr.category_id = ca.id
inner join employees as em on o.employee_id = em.employee_id
inner join shippers as sh on o.shipper_id = sh.id
inner join suppliers as sp on pr.supplier_id = sp.id
where o.employee_id > 3 and o.employee_id <= 10
group by ca.name;


-- e Відфільтруйте рядки, де середня кількість товару більша за 21.

select ca.name, count(*), avg(od.quantity) 
from orders as o
inner join order_details as od on o.id = od.order_id
inner join customers as cs on o.customer_id = cs.id
inner join products as pr on od.product_id = pr.id
inner join categories as ca on pr.category_id = ca.id
inner join employees as em on o.employee_id = em.employee_id
inner join shippers as sh on o.shipper_id = sh.id
inner join suppliers as sp on pr.supplier_id = sp.id
where o.employee_id > 3 and o.employee_id <= 10
group by ca.name
having AVG(od.quantity) > 21;


-- f Відсортуйте рядки за спаданням кількості рядків.
-- Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком.

select ca.name, count(*), avg(od.quantity) 
from orders as o
inner join order_details as od on o.id = od.order_id
inner join customers as cs on o.customer_id = cs.id
inner join products as pr on od.product_id = pr.id
inner join categories as ca on pr.category_id = ca.id
inner join employees as em on o.employee_id = em.employee_id
inner join shippers as sh on o.shipper_id = sh.id
inner join suppliers as sp on pr.supplier_id = sp.id
where o.employee_id > 3 and o.employee_id <= 10
group by ca.name
having AVG(od.quantity) > 21
order by count(*) desc
limit 4
offset 1;








