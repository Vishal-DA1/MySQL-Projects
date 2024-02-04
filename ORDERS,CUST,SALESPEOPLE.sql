Create database ORDERS_CUST_SALESPEOPLE;

use ORDERS_CUST_SALESPEOPLE;

create table Salespeople (
snum int,
sname char(50),
city char(50),
comm decimal(2,2));

insert into salespeople values(1001,'Peel','London',0.12);
insert into salespeople values(1002,'Serres','San Jose',0.13);
insert into salespeople values(1003,'Axelrod','New york',0.1);
insert into salespeople values(1004,'Motika','London',0.11);
insert into salespeople values(1007,'Rafkin','Barcelona',0.15);


create table cust (
cnum int,
cname char(50),
city char(50),
rating int,
snum int);


insert into cust values(2001,'Hoffman','London',100,1001);
insert into cust values(2002,'Giovanne','Rome',200,1003);
insert into cust values(2003,'Liu','San Jose',300,1002);
insert into cust values(2004,'Grass','Berlin',100,1002);
insert into cust values(2006,'Clemens','London',300,1007);
insert into cust values(2007,'Pereira','Rome',100,1004);
insert into cust values(2008,'James','London',200,1007);


create table orders (
onum int,
amt decimal(6,2),
odate date,
cnum int,
snum int);

insert into orders values(3001,18.69,'1994-10-03',2008,1007);
insert into orders values(3002,1900.1,'1994-10-03',2007,1004);
insert into orders values(3003,767.19,'1994-10-03',2001,1001);
insert into orders values(3005,5160.45,'1994-10-03',2003,1002);
insert into orders values(3006,1098.16,'1994-10-04',2008,1007);
insert into orders values(3007,75.75,'1994-10-05',2004,1002);
insert into orders values(3008,4723,'1994-10-05',2006,1001);
insert into orders values(3009,1713.23,'1994-10-04',2002,1003);
insert into orders values(3010,1309.95,'1994-10-06',2004,1002);
insert into orders values(3011,9891.88,'1994-10-06',2006,1001);

#=======================================================================================
#4.	Write a query to match the salespeople to the customers according to the city they are living.

select salespeople.sname, cust.cname, salespeople.city 
from salespeople
inner join cust
on salespeople.city = cust.city
order by salespeople.sname;

#5.	Write a query to select the names of customers and the salespersons who are providing service to them.

select salespeople.sname, cust.cname, salespeople.snum
from salespeople
inner join cust
on salespeople.snum = cust.snum
order by salespeople.snum;

#6.	Write a query to find out all orders by customers not located in the same cities as that of their salespeople.

select orders.*, salespeople.sname, cust.cname 
from orders, salespeople, cust
where salespeople.city <> cust.city 
and 
orders.cnum = cust.cnum
and
orders.snum = salespeople.snum;

#7.	Write a query that lists each order number followed by name of customer who made that order. 

select orders.onum, cust.cname 
from orders
inner join cust
on orders.cnum = cust.cnum;

#8.	Write a query that finds all pairs of customers having the same rating
select t1.cname,t2.cname from cust t1
inner join 
cust t2
on t1.rating = t2.rating
where t1.cname<>t2.cname;

#9.	Write a query to find out all pairs of customers served by a single salesperson
select cust.cname, salespeople.sname from cust
inner join 
salespeople
on 
salespeople.snum = cust.snum;
#&&&&&&&&&&&&&&&
select c.sname,a.cname,b.cname
from cust a,cust b,salespeople c 
where a.snum=b.snum and a.snum=c.snum;

#10. Write a query that produces all pairs of salespeople who are living in same city
select t1.sname, t2.sname from Salespeople t1, Salespeople t2
where t1.city = t2.city;

#11. Write a Query to find all orders credited to the same salesperson who services Customer 2008
select cust.cname,salespeople.sname,orders.onum 
from cust,salespeople,orders
where cust.snum=salespeople.snum and cust.cnum=orders.cnum and cust.cnum='2008';

#12. Write a Query to find out all orders that are greater than the average for Oct 4th
select odate, avg(amt) from orders
where odate!='1994-10-04' 
group by odate;
#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
select odate, avg(amt) from orders
where (select avg(amt) from orders
where odate ='1994-10-04') < (select avg(amt) from orders)
group by odate;

#13. Write a Query to find all orders attributed to salespeople in London.
select orders.onum, salespeople.sname from orders
inner join
salespeople on orders.snum = salespeople.snum
where salespeople.city = 'London';

#14. Write a query to find all the customers whose cnum is 1000 above the snum of Serres. 
select cust.cnum,cust.cname,salespeople.snum,salespeople.sname 
from cust, salespeople 
where salespeople.snum+1000=cust.cnum;

#15. Write a query to count customers with ratings above San Jose’s average rating.
select count(*) as 'Count' from cust 
where rating>(select avg(rating) from cust where city='san jose');

#16. Write a query to show each salesperson with multiple customers.
select Salespeople.sname, cust.cname from Salespeople 
inner join
cust on Salespeople.snum = cust.snum
where Salespeople.snum = cust.snum
order by Salespeople.snum;


select * from salespeople;
select * from cust;
select * from orders;

























