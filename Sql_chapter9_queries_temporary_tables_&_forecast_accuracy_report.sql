SELECT * FROM gdb0041.fact_act_est;

update fact_act_est
set sold_quantity = 0
where sold_quantity is null;

update fact_act_est
set forecast_quantity = 0
where forecast_quantity is null;

with forecast_error_table as (select 
	s.customer_code,
	sum(s.sold_quantity) as total_sold_quantity,
    sum(s.forecast_quantity) as total_forecast_quantity,
    sum((forecast_quantity - sold_quantity)) as net_error,
    sum((forecast_quantity - sold_quantity))*100 / sum(forecast_quantity) as net_error_pct,
    sum(abs(forecast_quantity - sold_quantity)) as abs_error,
    sum(abs(forecast_quantity - sold_quantity))*100 / sum(forecast_quantity) as abs_error_pct
from fact_act_est s
where s.fiscal_year = 2021
group by s.customer_code)
select 
	e.*,
    c.customer,
    c.market,
    if(abs_error_pct > 100, 0, (100 - abs_error_pct)) as forecast_accuracy
from forecast_error_table e
join dim_customer c
using(customer_code)
order by forecast_accuracy desc;
