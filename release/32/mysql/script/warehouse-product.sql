create database if not exists warehouse;
use warehouse;
drop table if exists product;
create table product(
number char(60) CHARACTER SET gb2312 not null,
name char(50) CHARACTER SET gb2312,
price float,
madeTime date,
PRIMARY KEY(number)
);

insert into product values('888888','benc一二无可奈何魂牵梦萦地在hi','820020','2012-12-12');
insert into product values('999999','baoma','820020','2012-12-12');

select * from product;
