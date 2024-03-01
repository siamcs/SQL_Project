-------Project On E-Commerce using 3NF in SQL-----
-------Data manupulation Language(DML)---
-------Use this Database--------
use EcommerceDB
Go
 ------------------INSERT into tables -------------------
  
    ----------- Customer  -----------
insert into Customer(Customerid,CustomerName,Address1,Address2,contactNumber) 
values(1,'Mr. Shakib Ahmed','Rampura','Dhaka',01552625),
      (2,'M Rakib Hassen ','Dhanmondi','Dhaka',01738338),
	  (3,'Md AkibMulla','Sodor', 'Bhola',0192344),
	  (4,'TM Tanvir','Motijheel','Dhaka',018345),
	  (5,'AR Akash','Sodor','Barishal',0171000),
	  (6,'SM Sifat','Panthopath','Dhaka',01632233),
	  (7,'MD.Rifat','Motijheel','Dhaka',0183455),
	  (8,'M Hasib','Dhanmondi','Dhaka',01738346);
	  select*from Customer
	                -- - ------Company-------
insert into Company(CompanyId,CompanyName)values(1,'Samsung'),(2,'Nokia'),(3,'Symphony')
           select*from Company
		   ------Product----
insert into Product(ProductId,ProductModel,CompanyId) 
values(1,'Samsung GalaxyA52',1),
(2,'Nokia-1200',2),
(3,'Samsung galaxy J7',1),
(4,'Nokia7 plus ',2),
(5,'D43',3),
(6,'Nokia8 ',2),
(7,'D8',3),
(8,'D46',3);
  select*from Product

         
                   -----Productdetails----
insert into ProductDetails(CustomerID,ProductId,price,Quantity,vat,Orderdate,Deleiverydate)values
                        (1,1,12000,1,0.05,'10-02-2023','10-04-2023'),
						(2,2,1500,2,0.05,'10-02-2020','11-04-2020'),
(3,3,15000,1,0.05,'10-01-2022','10-03-2022'),
(4,4,12000,3,0.05,'10-01-2022','10-03-2022'),
(5,5,10000,4,0.05,'12-10-2021','12-11-2021'),
(6,6,15000,2,0.05,'10-02-2020','10-04-2021'),
(7,7,1200,1,0.05,'12-10-2021','12-11-2022'),
(8,8,1500,1,0.05,'12-10-2021','10-04-2022')
			select*from ProductDetails

                        ------View Tables ---
						select*from Customer
						select*from Product
						select*from Company
						select*from ProductDetails
----join with sub query and sum, where group,having,order by ----
select Customer.CustomerName,Company.CompanyName,ProductModel ,price,quantity,vat,quantity*price TotalSum,
sum((quantity*price*vat)+quantity*price) as TotalsumVat from ProductDetails
join Customer on Customer.CustomerID=ProductDetails.CustomerID
join Product on Product.ProductId=ProductDetails.ProductId join Company
on Company.CompanyID=Product.CompanyId
where CompanyName in (select CompanyName from Company where CompanyName='Nokia')
group by Customer.CustomerName,Company.CompanyName,ProductModel ,price,quantity,vat
having sum(quantity*price*vat)>150
order by Customer.CustomerName
---------using wilcards----------
select CustomerID,CustomerName  from Customer
where CustomerName like 'M%'
select CustomerID,CustomerName  from Customer
where CustomerName like 'M[A-Z]%'
select CustomerID,CustomerName  from Customer
where CustomerName not like '%M%'
select CustomerID,CustomerName  from Customer
where CustomerName like 'M[^A-M]'
select CustomerID,CustomerName,ContactNumber  from Customer
where ContactNumber like '[1-9]%'
-----------------------Delete-------------------------
--------Delete a single Row-----
delete from ProductDetails where Quantity=2
--------Delete All Records-----
delete from ProductDetails 
--------use of aggregate function---
----COUNT All Row--
select CompanyName , count(*) as  "Number Of Company" from  Company
group by CompanyName;
-------COUNT only one cloumn Row------------
select count(CompanyId) AS "Number Of Company" From Company;
  ----AVERAGE ProductDetails price ---
select avg(Price ) as "Average AVG price" from ProductDetails;
   ---Summation of  ProductDetails price -
Select sum(Price) AS "Total Price" From ProductDetails;
 ----Maximum ProductDetails price ---
Select MAX(Price) as "Max Price" From ProductDetails;
-----Minimum  ProductDetails price -----
Select MIN(Price) as "min Price" From ProductDetails;
------------ROLLUP----------
Select CompanyName,count(CompanyID) as [ID]  from company
Group by Rollup (CompanyID,CompanyName);
-----------CUBE--------
select  CompanyID,CompanyName  from Company group by cube(CompanyID,CompanyName) order by CompanyName;
--------Grouping sets---------
select CompanyID,CompanyName from Company group BY grouping sets (CompanyID,CompanyName);
-------Over ------
select CompanyID,CompanyName ,COUNT(*) OVER() as NoOfCount
 FROM  Company 
 --case function---
select CompanyID,CompanyName,
case
when CompanyName='Nokia' then 'Good'
when CompanyName='Symphony' then 'Better'
else 'Best'
end as NewColumn from Company
--iif ,choose function
select CompanyID,CompanyName,iif(CompanyName='Nokia','Good','Best') as NewColumn from Company
select CompanyID,CompanyName,Choose(CompanyID,'Nokia','Good','Best') as NewColumn from Company
----insert for Is null and coalesce 
insert into Company(CompanyId,CompanyName)values(9,null),(10,null),
(11,null),(12,'walton'),(13,'Nokia')
--isnull,coalesce ---
select CompanyID,CompanyName,isnull(CompanyName,'Good') as NewColumn from Company
select CompanyID,CompanyName,coalesce(CompanyName,'Good') as NewColumn from Company
--grouping
select CompanyID,CompanyName,grouping(CompanyName) from Company
group by CompanyID,CompanyName
 --ranking functions --
select CustomerID,row_number() over (partition by price order by CustomerID ) as NewColumn from ProductDetails
select CustomerID,rank() over (partition by price order by CustomerID ) as NewColumn from ProductDetails
select CustomerID,dense_rank() over (partition by price order by CustomerID) as NewColumn from ProductDetails
select CustomerID,ntile(4)over (partition by price order by CustomerID) as NewColumn from ProductDetails
-- analytic functions
select CustomerID,first_value(CustomerID) over (partition by price order by CustomerID) as NewColumn from ProductDetails
select CustomerID,last_value(CustomerID) over (partition by price order by CustomerID) as NewColumn from ProductDetails
select CustomerID,lag(CustomerID) over (partition by price order by CustomerID) as NewColumn from ProductDetails
select CustomerID,lead(CustomerID) over (partition by price order by CustomerID) as NewColumn from ProductDetails
select CustomerID,percent_rank()over (partition by price order by CustomerID) as NewColumn from ProductDetails
select CustomerID,cume_dist()over (partition by price order by CustomerID) as NewColumn from ProductDetails
select CustomerID,percentile_cont(0.5) within group (order by CustomerID) over (partition by price ) as NewColumn from ProductDetails
select CustomerID,percentile_DISC(0.5) within group (order by CustomerID) over (partition by price ) as NewColumn from ProductDetails
 --------------- EXISTS-----------
Select Customername,   concat(Address1, ', ',Address2) As Address,ProductModel ,Companyname 
from  Customer join ProductDetails on ProductDetails.CustomerID=Customer.CustomerID join Product
on ProductDetails.ProductId=Product.ProductId join Company on Company.CompanyID=Product.CompanyId
WHERE Exists
(select Companyname from ProductDetails where Companyname='nokia');
--------------------- NOT EXISTS-------------------
Select Customername,   concat(Address1, ', ',Address2) As Address,ProductModel ,Companyname 
from  Customer join ProductDetails on ProductDetails.CustomerID=Customer.CustomerID join Product
on ProductDetails.ProductId=Product.ProductId join Company on Company.CompanyID=Product.CompanyId
WHERE not  Exists
(select Companyname from ProductDetails where Companyname='nokia');
--------------------- ANY-------------------
Select Customername,   concat(Address1, ', ',Address2) As Address,ProductModel ,Companyname 
from  Customer join ProductDetails on ProductDetails.CustomerID=Customer.CustomerID join Product
on ProductDetails.ProductId=Product.ProductId join Company on Company.CompanyID=Product.CompanyId
WHERE Companyname =any
(select Companyname from ProductDetails where Companyname='nokia');

 ----------- ALL---------
Select Customername,   concat(Address1, ', ',Address2) As [Address],ProductModel ,Companyname 
from  Customer join ProductDetails on ProductDetails.CustomerID=Customer.CustomerID join Product
on ProductDetails.ProductId=Product.ProductId join Company on Company.CompanyID=Product.CompanyId
WHERE Companyname >all
(select Companyname from ProductDetails where Companyname='nokia');
-----some --
Select Customername,   concat(Address1, ', ',Address2) As Address,ProductModel ,Companyname 
from  Customer join ProductDetails on ProductDetails.CustomerID=Customer.CustomerID join Product
on ProductDetails.ProductId=Product.ProductId join Company on Company.CompanyID=Product.CompanyId
WHERE Companyname =some
(select Companyname from ProductDetails where Companyname='nokia');
  ------------ CAST -------
select customerid ,   cast('01-june-2021' as date) from ProductDetails
---------- CNVERT --------
select datetime =convert(datetime, '01-june-2021 10:00:00')
-----offset ,fetch-----
select Customer.CustomerName,Company.CompanyName,ProductModel ,price,quantity,vat,quantity*price TotalSum,
sum((quantity*price*vat)+quantity*price) as TotalsumVat from ProductDetails
join Customer on Customer.CustomerID=ProductDetails.CustomerID
join Product on Product.ProductId=ProductDetails.ProductId join Company
on Company.CompanyID=Product.CompanyId
where CompanyName in (select CompanyName from Company where CompanyName='Nokia')
group by Customer.CustomerName,Company.CompanyName,ProductModel ,price,quantity,vat
having sum(quantity*price*vat)>150
order by Customer.CustomerName
offset 0 rows
fetch first 2 rows only 
------Merge ----
-----------Merge table -----
Create table productts
(
productId int identity(1,1) primary key,
productname varchar(50)
)
create table producttMerge
(
productId int identity(1,1) primary key,
productname varchar(50)
);
PRINT('successfully created');
merge into dbo.producttMerge as m
using dbo.productts as p
on m.productId=p.productId 
when matched then
update set  m.productname=p.productname 
when not matched then insert  (productName)values (p.productname);
insert into productts values ('C# Step by step ')
select*from productts
select*from producttMerge  
go
----CTE-----
 with CTE_test as (
select CompanyID,CompanyName from Company)
select*from CTE_test
--------recursive CTE-------
go
WITH cte_numbers(n, weekday)
AS (SELECT 0, DATENAME(DW, 0)
 UNION ALL SELECT  
 n + 1, DATENAME(DW, n + 1)
FROM cte_numbers WHERE n < 6)
SELECT weekday FROM cte_numbers;
-------End DML------