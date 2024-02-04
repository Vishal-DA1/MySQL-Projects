#================================================== Day 3 ================================================================================
#1.
select customernumber, customername, state, creditlimit from classicmodels.customers
where state is not null and creditlimit between 50000 and 100000
order by creditlimit desc;

#2.
select distinct productline from classicmodels.products
where productLine like '%cars%';

#================================================== Day 4 ================================================================================
#1.
select orderNumber, status, coalesce(comments, '-') from classicmodels.orders;

#2.
select employeenumber, firstname, jobtitle,
case 
when jobtitle = 'President' then 'P'
when jobtitle like '%Sales Manager%' then 'SM'
when jobtitle like '%Sale Manager%' then 'SM'
when jobtitle = 'Sales Rep' then 'SR'
when jobtitle like '%VP%' then 'VP'
end as jobTitle_abbr
from classicmodels.employees;

#================================================== Day 5 ================================================================================
#1.
select year(paymentdate) as 'Year' , min(amount) as 'Min Amount' from classicmodels.payments
group by year(paymentdate);

#2.
select * from orders; 

select year(orderdate) as Year , concat('Q' , quarter(orderdate)) as Quarter, count(distinct Customernumber) as 'Unique Customers', count(ordernumber) as 'Total Order' from classicmodels.orders
group by year(orderdate),Quarter;

#3. 

with cte as
(select distinct month(paymentdate) as Month , concat(round(sum(amount)/1000,0) , 'K') as Formatted_amount from payments
group by month(paymentdate))
select case
when Month = 1 Then 'Jan'
when Month = 2 Then 'Feb'
when Month = 3 Then 'Mar'
when Month = 4 Then 'April'
when Month = 5 Then 'May'
when Month = 6 Then 'Jun'
when Month = 7 Then 'July'
when Month = 8 Then 'Aug'
when Month = 9 Then 'Sept'
when Month = 10 Then 'Oct'
when Month = 11 Then 'Nov'
when Month = 12 Then 'Dec'
end as 'Month ' , Formatted_amount from cte
HAVING Formatted_amount BETWEEN '500K' AND '1000K'
order by Formatted_amount desc;

#================================================== Day 6 ================================================================================
#1. 
create table journey ( Bus_ID int not null, 
Bus_Name varchar(255) not null, 
Source_Station varchar(255) not null,
Destination varchar(255) not null,
Email varchar(255) unique);

#2.
create table vendor ( Vendor_ID int primary key , 
Name varchar(255) not null , 
Email varchar(255) unique , 
Country varchar(255) default 'N/A');

#3.
Create table movies ( Movie_ID int primary key,
Name varchar(255) not null,
Release_Year varchar(255) default '-',
Cast varchar(255) not null,
Gender varchar(255) , check (gender = 'Male' or gender = 'Female'),
No_of_shows int , check (No_of_shows > 0));

#4.

Create table Suppliers ( supplier_id int primary key, 
supplier_name varchar (255),
location varchar (255));


create table Product ( product_id int primary key,
product_name varchar(255) not null unique,
description varchar(255),
supplier_id int, foreign key(supplier_id) references suppliers(supplier_id));

Create table Stock( Stock_id int primary key,
product_id int, foreign key(product_id) references product(product_id),
balance_stock int);

#================================================== Day 7 ================================================================================
#1.
select * from customers;
select employeenumber, concat(firstname ,' ', Lastname) as 'Sales Person', count(customername) as 'Unique Customer' from employees
inner join customers
on salesrepemployeenumber = employeenumber
group by employeenumber, 'Sales Person'
order by count(customername) desc;

#2. 

with cte as
(select customers.customernumber , customername , products.productcode , products.productname , orderdetails.quantityordered as Ordered_Qty , 
products.quantityinstock as Total_Inventory from customers
inner join orders
on customers.customernumber = orders.customernumber
inner join orderdetails
on orders.ordernumber = orderdetails.ordernumber
inner join products
on orderdetails.productcode = products.productcode)
select *, Total_Inventory - Ordered_Qty as Left_Qty from cte;


#3.
 create table laptop ( Laptop_name varchar(255));
 Create table Colours ( Colour_name varchar (255));
 
 insert into laptop values ( 'HP' ), ('Dell') , ('Apple');
 insert into colours values ( 'White' ), ('Black') , ('Grey');
 
 select * from laptop
 inner join colours;
 
 #4. 
 
 Create table project(EmployeeID int primary key,
 Fullname Varchar(255),
 Gender varchar(255), check (gender = 'Male' or gender = 'Female'),
 ManagerID int);
 
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

select * from project;

select t1.fullname as 'Manager Name' , t2.fullname as 'Emp Name' from project t1
inner join project t2
on t1.employeeid = t2.managerid
order by t1.fullname;


#================================================== Day 8 ================================================================================
create table facility ( Facility_ID int , Name varchar(100) , State varchar(100), Country varchar(100));
desc facility;
alter table facility modify Facility_ID int primary key auto_increment;
alter table facility add City varchar(100) not null;


#================================================== Day 9 ================================================================================

create table university( id int,
Name varchar(255));

INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
              
With cte as
(select id, REPLACE(name, ' ','') as Name_1 from university)
select id, replace(name_1,'University',' University') as Name from cte;

#================================================== Day 10 ================================================================================

create view Product_Status as
select Year(Orders.orderdate) as Year,
concat(count(productcode), " (", concat(round((count(productcode) / (select count(productcode) from orderdetails))*100),'%)')) as Value
from orders 
inner join orderdetails
using (ordernumber)
group by Year(orders.orderdate)
order by count(productcode) desc;

select * from product_status;

#================================================== Day 11 ================================================================================
#1. 

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLevel`(Cust_number int)
BEGIN
Select *,
case when creditlimit > 100000 then 'Platinum'
when creditlimit between 25000 and 100000 then 'Gold'
else 'Silver'
end as GetCustomerLevel
 from customers
 where Cust_number = customernumber;
END $$

call GetCustomerLevel(112);
 
 #2. 
 
 CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(Y_year int, C_country varchar(20))
BEGIN
 with cte as
 (select year(paymentdate) as 'Year', customers.country as country, amount as Total_Amount from payments
 inner join customers
 on payments.customernumber = customers.customernumber)
 select year, country, Concat(round(sum(Total_Amount)/1000,0),'K') as Total_Amount from cte
 where Y_year = year and C_country = country
 group by year,country;
END $$

call Get_country_payments(2003,'France');

 #================================================== Day 12 ================================================================================
#1. 

select * from orders;

with cte1 as
(with cte as
(select year(orderdate) as Year , month(orderdate) , case
when month(orderdate) = 1 Then 'January'
when month(orderdate) = 2 Then 'February'
when month(orderdate) = 3 Then 'March'
when month(orderdate) = 4 Then 'April'
when month(orderdate) = 5 Then 'May'
when month(orderdate) = 6 Then 'June'
when month(orderdate) = 7 Then 'July'
when month(orderdate) = 8 Then 'August'
when month(orderdate) = 9 Then 'September'
when month(orderdate) = 10 Then 'October'
when month(orderdate) = 11 Then 'November'
when month(orderdate) = 12 Then 'December' end as 'Month' from orders)
select year, month, count(month) as Total_Orders,
lag (count(month)) over() as Diff
from cte
group by year, month)

select year, Month, Total_Orders, concat(round((Total_Orders - diff)/diff*100,0),'%') as '% YoY Change'  from cte1;

#2. 

CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    DOB DATE
);

INSERT INTO emp_udf(Name, DOB)
VALUES ("Piyush", "1990-03-30"),
("Aman", "1992-08-15"),
("Meena", "1998-07-28"),
("Ketan", "2000-11-21"),
("Sanjay", "1995-05-21");

DELIMITER //
CREATE FUNCTION calculate_age(dob DATE)
RETURNS VARCHAR(50)
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);

    SET years = TIMESTAMPDIFF(YEAR, dob, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, dob, CURDATE()) - years * 12;

    SET age = CONCAT(years, ' years ', months, ' months');
    
    RETURN age;
END //
DELIMITER ;


#================================================== Day 13 ================================================================================
#1.

select customernumber, customername from customers
where customernumber <> all ( select customernumber from orders);
#2.

select customers.customernumber, customername, count(orders.customernumber) as 'Total Orders' from customers #count(orders.customernumber)
left join orders
on customers.customernumber = orders.customernumber
group by customers.customernumber, customername
UNION
select customers.customernumber, customername , count(orders.customernumber) as 'Total Orders' from customers 
right join orders
on customers.customernumber = orders.customernumber
group by customers.customernumber, customername ;


#3.

with cte as(
select ordernumber, quantityordered,
dense_rank() over(partition by ordernumber order by quantityordered desc) as 'rn'
from orderdetails)
select ordernumber, quantityordered from cte
where rn = 2;

#4. 

select * from orderdetails;
with cte as
(select ordernumber , count(productcode) as Total from orderdetails
group by ordernumber)
select max(Total) , min(Total) from cte;

#5. 

select productline, count(productline) as Total from products
where buyprice > (select avg(buyprice) from products)
group by productline
order by Total desc;


#================================================== Day 14 ================================================================================
create table Emp_EH (EmpID int primary key, EmpName varchar(20), EmailAddress varchar(255));
create table Wrong_Entry (EmpID int primary key, EmpName varchar(20), EmailAddress varchar(255));

CREATE DEFINER=`root`@`localhost` PROCEDURE `Emp_EH`(EmpID int, EmpName varchar(20), EmailAddress varchar(255))
BEGIN


declare exit handler for sqlstate '23000'
begin
insert into Wrong_Entry values (EmpID , EmpName, EmailAddress);
select 'Error Occured' as message;
end;
insert into Emp_EH values (EmpID , EmpName, EmailAddress);
select 'Done' as message;

END $$;

#================================================== Day 15 ================================================================================

create table Emp_BIT (Name varchar(20), 
Occupation varchar(20), 
Working_date date, 
Working_hours int);

DELIMITER //
create trigger Bfr_insert before insert
on Emp_BIT for each row
begin
if Working_hours < 0
then 
set new.Working_hours = (Working_hours * (-1));
end if;
end//

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', -11);  

################################################## END ##########################################################