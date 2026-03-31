use customer_behavior;
show tables;
describe customer;
select * from customer limit 20
-- what is the total revenue male vs female

Select gender,sum(purchase_amount) as revenue
from customer
Group by gender ;

-- which customer used more discount
select customer_id,purchase_amount
from customer
where discount_applied='Yes' and purchase_amount >= (select avg(purchase_amount) from customer);

-- top 5 products highest avg rating
select item_purchased , avg(review_rating) as "Average Product Rating"
from customer
group by item_purchased
order by avg (review_rating) desc
limit 5;

-- compare avg purchase amount bw Standard &expresss shipping
select shipping_type,
Round(Avg(purchase_amount),2)
from customer 
where shipping_type in ('standard','Express')
group by shipping_type;

-- Compare avg spend and total revenue bw sub and non-sub
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue,avg_spend desc;

-- 5 products highest percentage discount applied?
select item_purchased,
round(100 * sum(case when discount_applied ='Yes' then 1 else 0 end) /count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

-- Segment customer into new and loyal and previous purchasing count of each segment
with customer_type as(
select customer_id,previous_purchases,
case
	when previous_purchases =1 then 'New'
    when previous_purchases between 2 and 10 then 'Returning'
    else 'loyal'
    end as customer_segment
from customer
)
select customer_segment,count(*) as 'Number of Customer'
from customer_type 
group by customer_segment

-- what are top 3 products with in category
with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id)desc) as item_rank
from customer
group by category, item_purchased
)
select item_rank, category, item_purchased,total_orders
from item_counts
where item_rank <=3;

-- customers repeat buyers more 5 pre purchase
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases >5
group by subscription_status

-- revenue each age group
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;
