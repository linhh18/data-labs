use publications;
select au.au_id 
from authors au;

select * 
from authors;
select * 
from titles
;
select * 
from publishers p;

select t.title, p.pub_name
from titles t
left join publishers p 
on t.pub_ID = p.pub_ID;


select * 
from titleauthor ta; 

## MY SQL SELLECT
# Challange 1
select  au.au_id, au.au_lname, au.au_fname, t.title, p.pub_name
from titles t
join titleauthor ta on t.title_id = ta.title_id
join authors au on au.au_id = ta.au_id
join publishers p on p.pub_id = t.pub_id;

# Challange 2
select  au.au_id, au.au_lname, au.au_fname, p.pub_name, count(t.title) as title_count
from titles t
join titleauthor ta on t.title_id = ta.title_id
join authors au on au.au_id = ta.au_id
join publishers p on p.pub_id = t.pub_id
group by au.au_id, p.pub_name; # here we have to find the one to one match: how many titles does one have with one publisher

# Chanllange 3
select *
from sales s;

select *
from titleauthor ta;

select ta.au_id, au.au_lname, au.au_fname, s.qty
from titleauthor ta
join sales s
on ta.title_id = s.title_id
join authors au
on au.au_id = ta.au_id;

select *
from(
select ta.au_id, au.au_lname, au.au_fname, sum(s.qty) as total
from titleauthor ta
join sales s
on ta.title_id = s.title_id
join authors au
on au.au_id = ta.au_id
group by au.au_id) n
ORDER BY total DESC;

select ta.au_id, au.au_lname, au.au_fname, sum(s.qty) as total
from titleauthor ta
join sales s
on ta.title_id = s.title_id
join authors au
on au.au_id = ta.au_id
group by au.au_id
ORDER BY total DESC
limit 3;

#Challange 4
# this query still works but the tables should be join in better order
select au.au_id, au.au_lname, au.au_fname, sum(s.qty) as total
from titleauthor ta
left join sales s
on ta.title_id = s.title_id
right join authors au
on au.au_id = ta.au_id
group by au.au_id, ta.au_id
ORDER BY total DESC;

select au.au_id, au.au_lname, au.au_fname,  sum(s.qty) as total  #selecting always the core table first, when left join the left table will always have more values
from authors au
left join titleauthor ta
on au.au_id = ta.au_id
left join sales s # left join here because sales has less variables
on ta.title_id = s.title_id
group by au.au_id
ORDER BY total DESC;

## MY SQL ADVANCE
use publications;
create table store_sales_summary
select stores.stor_id as storeID, stores.stor_name as store,
count(distinct(ord_num)) as orders, count(title_id) as items, sum(qty) as Qty
from publications.sales sales
Inner join publications.stores stores on stores.stor_id = sales.stor_id
group by storeID, Store;

select *
from store_sales_summary;

update store_sales_summary
set Qty=Qty +10
where Qty<50;


select *
from store_sales_summary;

# Challange 1
select *
from sales;

select *
from titleauthor;

select *
from titles;

#sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100
#select ta.au_id, (sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty 
#from(
#select title_id, title, pub_id, price, royalty
;
create temporary table total_profit
select  au.au_id, au.au_lname, au.au_fname, t.title, t.advance, p.pub_name, t.title_id, s.qty, t.price* t.royalty* s.qty/100 * ta.royaltyper/100  as sales_royalty, (t.price* t.royalty* s.qty/100 * ta.royaltyper/100) + t.advance as total_profit
from titles t
join titleauthor ta on t.title_id = ta.title_id
join authors au on au.au_id = ta.au_id
join publishers p on p.pub_id = t.pub_id
join sales s on  s.title_id = t.title_id;

select *
from total_profit;

select  au_id, au_lname, au_fname, sum(total_profit) as total_profit
from total_profit
group by au_id, au_lname, au_fname
ORDER BY total_profit DESC
LIMIT 3;


# Challange 2
# combine 2 queries into 1
select n.au_id, n.au_lname, n.au_fname, sum(n.total_profit) as total_profit
from
(select  au.au_id, au.au_lname, au.au_fname, t.title, (t.price* t.royalty* s.qty/100 * ta.royaltyper/100) + t.advance as total_profit
from titles t
join titleauthor ta on t.title_id = ta.title_id
join authors au on au.au_id = ta.au_id
join publishers p on p.pub_id = t.pub_id
join sales s on  s.title_id = t.title_id) n 
group by n.au_id
ORDER BY total_profit DESC
LIMIT 3;

#Challange 3
create table most_profiting_authors
select n.au_id, sum(n.total_profit) as total_profit
from
(select  au.au_id, au.au_lname, au.au_fname, t.title, (t.price* t.royalty* s.qty/100 * ta.royaltyper/100) + t.advance as total_profit
from titles t
join titleauthor ta on t.title_id = ta.title_id
join authors au on au.au_id = ta.au_id
join publishers p on p.pub_id = t.pub_id
join sales s on  s.title_id = t.title_id) n 
group by n.au_id
ORDER BY total_profit DESC
LIMIT 3;

qqq