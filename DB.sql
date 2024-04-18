Create database musicshop

create table creator(creatorid int constraint PK_creator_creatorid primary key,
					 firstname varchar(20) not null,
					 lastname varchar(30) not null
					);

create table album(albumid serial constraint PK_album_albumid primary key,
				   name varchar(50) not null,
				   releasedate date not null,
				   creatorid int constraint FK_album_creatorid references creator(creatorid) not null
				  );
				
create table music(musicid serial constraint PK_music_musicid primary key,
				   name varchar(30) not null,
				   price int not null,
				   format varchar(5) not null,
				   m_size int not null,
				   m_time time not null,
				   m_style varchar(30) not null,
				   creatorid int constraint FK_music_creatorid references creator(creatorid) not null,
				   albumid int constraint FK_msuic_albumid references album(albumid));

create table customer(customerid int constraint PK_customer_customerid primary key,
					  name varchar(50) not null,
					  phone varchar(13) not null,
					  birthdate date);

create table factor(factorid serial constraint PK_factor_factorid primary key,
				    orderdate date not null,
				    totalprice int ,
				    customerid int constraint FK_factor_customerid references customer(customerid));

create table factordetail(factorid int constraint FK_factordetail_factorid references factor(factorid) not null,
						  albumid int constraint Fk_factordetail_albumid references album(albumid),
						  musicid int constraint FK_factordatail_musicid references music(musicid),
						  count int not null,
						  price int not null
						 );

insert into customer values (1,'reza','09254781254'),
							(2,'amir','09375489681'),
							(3,'mina','09194512354'),
							(4,'peyman','09125468712'),
							(5,'leila','09391660266');
							
insert into creator values (1,'milad','ahmadi'),
							(2,'ahmad','tabrizi'),
							(3,'reyhane','ebrahimian'),
							(4,'poria','mahami'),
							(5,'saeed','ghalibaf');							

insert into album(name,releasedate,creatorid) values ('ultraviolet','2020-06-15',3),
							('peace of mind','2021-12-25',3),
							('finding god','2016-11-26',1),
							('paranoia','2025-01-11',4),
							('twilight','2011-11-11',5);	
							
insert into music (name, price, format, m_size, m_time, m_style, creatorid, albumid) 
					 values ('roya',13,'mp3',8,'2:30','pop',2,null),
					 		('scorned',25,'mp3',16,'3:26','rock',2,null),
							('mercy',15,'wav',20,'4:03','rock',1,3),
							('dreaming wide awake',20,'mp3',10,'3:58','rock',5,5),
							('blood',18,'wav',16,'3:50','rock',1,3),
							('dethron',10,'wav',13,'3:20','rock',1,3);	
							
insert into factor (orderdate,customerid) 
				     values ('2018-12-10',1),
							('2017-07-06',2),
							('2024-01-30',3),
							('2023-06-09',1),
							('2022-11-11',4);	

insert into factordetail values(1,null,2,5,25),
							(1,null,3,6,15),
							(2,null,4,5,20),
							(3,null,5,10,18),
							(4,null,1,13,13),
							(5,null,2,3,25)
							(5,null,5,6,18);	
select * from factordetail							
---------------------------------------------------------------------
--Queries
--1
select a.albumid,m.count,m.average_time,m.sum_price from album a 
inner join (select albumid,count(musicid) as count,avg(m_time) as average_time,sum(price) as sum_price from music group by albumid) m on m.albumid = a.albumid
order by m.sum_price asc
--2
select musicid , sum(count) from factordetail group by musicid having in (select )
--3
select CONCAT(c.firstname, ' ', c.lastname) as artist_name from music m
inner join creator c on m.creatorid = c.creatorid  
group by c.firstname , c.lastname, m.m_style
having count(distinct m.m_style) >= 1  
and m.m_style = 'rock';
--4
select c.name ,f.date  from customer c inner join (select customerid,max(orderdate) as date from factor group by customerid ) f on c.customerid = f.customerid 
--5
select a.name from album a 
inner join (select m.musicid,m.albumid from factordetail fds 
			inner join (select albumid,musicid from music ) 
			m on m.musicid = fds.musicid group by m.albumid,m.musicid having count(m.albumid) = 1 ) 
fd on fd.albumid = a.albumid  
--6
---------------------------------------------------------------------
--test






update customer set birthdate = '2001-08-06' where name = 'reza'
alter table factor alter column totalprice TYPE int 

drop table factor
drop table factordetail

select c.name from customer c
select * from album
select * from creatorid
select * from music
select * from factor 
select * from factordetail
select distinct(albumid),name from music
select m_style , count(*) from music group by albumid having m_style='rock' 
select concat(c.firstname,' ',c.lastname) as name from creator c where firstname like 'm%'
select 1 from 
do $$
declare 
	percent int ; 
begin
	select sum(count) into percent from factordetail group by musicid order by sum(count) desc limit 1;
	select musicid,sum(count) from factordetail group by musicid having sum(count) > (percent*6)/100;
end ;$$;

select * from music where count(*) >1 
select musicid,sum(count) from factordetail group by musicid having sum(count) > (percent*6)/100