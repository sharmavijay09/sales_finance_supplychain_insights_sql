-- top 5 market
SELECT 
	market, round(sum(net_sales)/1000000, 2) as net_sales_mln
FROM gdb0041.net_sales
where fiscal_year = 2021
group by market
order by net_sales_mln desc
limit 5;

-- store procedures
call gdb0041.get_top_n_markets_by_net_sales(2022, 3);

-- top 5 customers
SELECT 
	c.customer,
    round(sum(net_sales)/1000000, 2) as net_sales_mln
FROM gdb0041.net_sales n
join dim_customer c
on
	n.customer_code = c.customer_code
where fiscal_year = 2021
group by c.customer
order by net_sales_mln desc
limit 5;

-- store procedure
call gdb0041.get_top_n_customers_by_net_sales('india', 2021, 3);

-- top products
SELECT 
	n.product,
    round(sum(net_sales)/1000000, 2) as net_sales_mln
FROM gdb0041.net_sales n
where fiscal_year = 2021
group by n.product
order by net_sales_mln desc
limit 5;

-- store procedure
call gdb0041.get_top_n_product_by_net_sales(2021, 3);
