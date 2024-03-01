----Project on E-Commerce ---------------
------Example of Data definition language (DDL)--
-----------Create Database---------------
use master
go
Drop database if exists EcommerceDB
go
Create database  EcommerceDB
on
(
	name= ' EcommerceDB_data_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\ EcommerceDB_data_1.mdf',
	Size=25mb,
	Maxsize=100mb,
	FileGrowth=5%
)
log on
(
	name=' EcommerceDB_Log_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\ EcommerceDB_Log_1.Ldf',
	Size=2mb,
	Maxsize=25mb,
	FileGrowth=1%
)
Go
----Use this Database--
use EcommerceDB
Go
------------------create Table ------------		
---------------------Customer-------------
drop table if exists Customer
create table Customer
(
CustomerID int primary key,   
CustomerName Varchar(50),
Address1 Varchar(50),
Address2 Varchar(50),
ContactNumber int)       
go
----------------- create Company table  -------------
drop table if exists Company
create table Company
(CompanyID int primary key,
CompanyName varchar(50))
go
PRINT('successfully created');
go
-------product table -----
go
drop table if exists Product
create table Product
(
ProductId int Primary key,
ProductModel varchar(50),
CompanyId int references Company(CompanyId)
)
PRINT('successfully created');
go
--------------------- create ProductDetails table  -------------
drop table if exists ProductDetails
 create table ProductDetails
(
CustomerID int references Customer(CustomerID),
ProductId int references Product(ProductId),
price money,
Quantity int,
vat numeric(5,3),
Orderdate date ,
Deleiverydate date,
primary key (CustomerID,ProductId));
PRINT('successfully created');
go
------create View-----
GO
create view Vw_Customer
as
select CustomerID,CustomerName  from Customer
go
select*from Vw_Customer
go
-----view encryption ---
go
create view Vw_encryption
with encryption as
select  CustomerID,CustomerName from Customer
where CustomerId between 2 and 5
go
select*from Vw_encryption
go
sp_helptext 'Vw_encryption'

go
------schemabinding view------
create view Vw_schemabind
with schemabinding as
select  CustomerID,CustomerName from dbo.Customer
where CustomerId=4 or CustomerId=6
go
select*from Vw_schemabind
go
----view encryption with schemabinding --
Create view vw_together 
with encryption,schemabinding 
AS
SELECT CompanyId FROM dbo.Company
GO
SELECT * FROM vw_together
go
---check option------
Go
create view Vw_withCheck 
as
select CustomerID,CustomerName from dbo.Customer
where CustomerId<>4
with check option
go
select*from Vw_withCheck
go
-----store procedure select,insert,update,delete-----
Create procedure SP_SelectInsertUpdateDeleteGLA
(	
	@CompanyId	      int,
	@CompanyName Varchar(100),    
	@StatementType 	  NVarchar(20) = '')
as
	if @StatementType = 'SELECT'
	begin
		select * from Company
	end

	if @StatementType = 'INSERT'
	begin
		insert  into Company(CompanyId, CompanyName)
		values (@CompanyId, @CompanyName)
	end

	if @StatementType = 'UPDATE'
	begin
		UPDATE Company
		set CompanyName=@CompanyName
		where CompanyId = @CompanyId
	end

	IF @StatementType = 'DELETE'
	begin
		delete Company
		where @CompanyId = @CompanyId
	end

Execute SP_SelectInsertUpdateDeleteGLA 20,'Walton','insert'
Execute SP_SelectInsertUpdateDeleteGLA 11,'Motorola','update'
Execute SP_SelectInsertUpdateDeleteGLA 8,'Walton','delete'

select * from Company
---------store Procedure -----
-- Procedure in parameter
GO
create  proc SP_Input
(@Companyid int output)
	as
	select COUNT(@Companyid) as Newcolumn
	from Company
Execute SP_Input 144
-- Procedure with return ------
go
create  proc SP_Returns
(@Companyid INT)
AS
    select Companyid,CompanyName 
	from Company
    where Companyid =@Companyid
go
declare @return_value int
Execute @return_value = SP_Returns @Companyid = 600
select  'Return Value' = @return_value;
---without parameter
GO
create procedure sp_withoutparameter
as
select 1
go
exec sp_withoutparameter
----sp throw validate ----------
Go
create proc Sp_ctes
@Companyname varchar(30)
as if @Companyname='Nokia'
print 'OK'
else throw 50001,'Fake',1;
go
exec Sp_ctes 'Nokia'
-----Try catch-------------
Go
create proc SPTry_Company
as
begin try
select CompanyID,CompanyName from Company
end try
begin catch 
select ERROR_LINE() as EL,
       ERROR_NUMBER() as EN,
	   ERROR_MESSAGE() as EM
end catch
go
-------function---------
---------------Sum two number----------------
Go
Create Function fn_Summation
(@number1 int, @number2 int)
Returns int 
Begin
Return  (@number1+@number2);
End;
Go
Select dbo.fn_Summation(100,300) as [Sum];
---------------average ----------------
Go
Create Function fn_AVG
(@number1 int, @number2 int)
Returns int 
Begin

Return  (@number1+@number2)/2;
End;
Go
Select dbo.fn_AVG(100,300) as [AVG];

---------------Multiplication  two numbers----------------
Go
Create Function fn_multiplication
(@number1 int, @number2 int)
Returns int 
Begin
Return  (@number1*@number2);
End;
Go
Select dbo.fn_multiplication(100,300) as Multiplication;

---------------Division two numbers----------------
Go
Create Function fn_div
(@number1 int, @number2 int)
Returns int 
Begin
Return  (@number1/@number2);
End;
Go
Select dbo.fn_div(100,300) as DIV ;
--------scalar function-----
Go
create function Fn_count()
returns int 
as
begin
declare @count int;
select @count=count(*) from Company;
return @count;
end;
Go
select dbo.Fn_count();
select * from Company;
----- simple/inline table value function---
Go
create function fn_tables ()
returns table 
return ( select Customer.CustomerName,company.CompanyName,
Datediff(day,Orderdate,Deleiverydate ) '[Getdate]'  from ProductDetails
join Customer on ProductDetails.CustomerID=ProductDetails.CustomerID
join Company on Company.companyID=Company.CompanyID 
join Product on ProductDetails.ProductId=Product.ProductId
where CompanyName in(select CompanyName from Company ))
Go
select*from dbo.fn_tables()

-------multitable value function--------
Go
Create Function fn_Mtble()
Returns @OutTable 
table( companyid int ,ADDcompanyid int,companyName varchar(30))
Begin 
Insert into @OutTable(companyid,ADDcompanyid,companyName)
select companyid,companyid+100,companyName from Company
Return
end;
GO
select*from dbo.fn_Mtble()
---------Trigger --------

Create Table BkCompany
(
CompanyID Int Primary key,
CompanyName varchar(30)
)
------------After trigger---------------------
GO
drop trigger TR_BkCompany
Create Trigger TR_BkCompany 
on Company
After Insert,Update
as
Insert into BkCompany
Select i.CompanyID,i.CompanyName 
From inserted i
insert into Company values(24,'sony')
select*from Company
select*from BkCompany
-----------------------------Instead of trigger----------------------------
drop table CompanyLog
Create  table  CompanyLog
(
LogID Int Identity (1,1),
CompanyID int,
CompanyName varchar(30)
)

------------------------Instead of trigger ----------------------------------------------
Create Trigger TR_instead_COMpany
on Company 
instead of delete
as
begin
set nocount on ;
declare @CompanyID INT
select @CompanyID=DELETED.CompanyID
from DELETED
IF @CompanyID=12
    begin
    raiserror('Can not delete',16,1)
    rollback
    insert  into CompanyLog values(@CompanyID,'Invalid')
    end
else
     begin
	 delete from Company
     where CompanyID=@CompanyID
     insert into CompanyLog values(@CompanyID,'DELETED')
     end
end

Delete Company
where CompanyID=12
select*from CompanyLog
select*from Company
---------------------------------------------------------End of DDL---------------------------------------------