select 
t.id_client,
count(*) as total_ops,
sum(t.sum_payment) as total_sum,
round(sum(t.sum_payment)/count(*), 2) as avg_check,
round(sum(t.sum_payment)/ 12, 2) as monthly_sum_avg
from(
select 
id_client,
date_format(date_new, '%Y-%m') as month,
sum_payment,
id_check
from transactions_info 
where date_new between '2015-06-01' and '2016-06-01'
) t
where t.id_client in(
select id_client
from(
select id_client, count(distinct date_format(date_new, '%Y-%m')) as month_actives
from transactions_info
where date_new between '2015-06-01' and '2016-06-01'
group by id_client
having month_actives=11 #никто не активен 12мес. поэтому написала 11
) as c
)
group by t.id_client
order by total_sum desc;



select
date_format(date_new, '%Y-%m') as month,
round(avg(sum_payment), 2) as avg_check
from transactions_info
where date_new between '2015-06-01' and '2016-06-01'
group by month
order by month;

select
date_format(date_new, '%Y-%m') as month,
count(id_check) as operations,
count(distinct id_client) as active_clients,
round(count(id_check) / count(distinct id_client), 2) as avg_ops
from transactions_info
where date_new between '2015-06-01' and '2016-06-01'
group by month
order by month;



select 
m.month,
count(*) as ops,
round(count(*)/ (select count(*)
from transactions_info
where date_new between '2015-06-01' and '2016-06-01'), 4) as ops_share,
sum(m.sum_payment) as total_sum,
round(sum(m.sum_payment)/(select sum(sum_payment)
from transactions_info
where date_new between '2015-06-01' and '2016-06-01'), 4) as sum_share
from(
select
date_format(date_new, '%Y-%m') as month,
sum_payment
from transactions_info
where date_new between '2015-06-01' and '2016-06-01'
) m
group by month
order by month;



select 
case
when c.age is null then 'NA'
when c.age >= 90 then '90+'
else concat(floor(c.age/10)*10,'-', floor (c.age/10)*10+9)
End as age_bucket,
count(t.id_check) as operations,
sum(t.sum_payment) as total_sum
from transactions_info as t
left join customer_info c using(id_client)
where t.date_new between '2015-06-01' and '2016-06-01'
group by age_bucket
order by age_bucket;


select concat('Q', quarter(t.date_new)) as quarter,
case
when c.age is null then 'NA'
when c.age >= 90 then '90+'
else concat(floor(c.age/10)*10,'-', floor (c.age/10)*10+9)
End as age_bucket,
count(t.id_check) as operations,
sum(t.sum_payment) as total_sum,
round(avg(t.sum_payment), 2) as avg_check,
count(distinct t.id_client) as active_clients
from transactions_info t
left join customer_info c using(id_client)
where t.date_new>= '2015-06-01' 
and t.date_new< '2016-06-01' 
group by quarter, age_bucket
order by quarter, age_bucket;