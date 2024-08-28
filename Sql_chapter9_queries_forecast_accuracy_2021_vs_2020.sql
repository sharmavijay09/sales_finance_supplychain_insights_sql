-- forecast accuracy for fiscal year 2021
create temporary table forecast_accuracy_2021
with forecast_error_table as (select 
	s.customer_code as customer_code,
    c.customer as customer_name,
    c.market as market,
	sum(s.sold_quantity) as total_sold_quantity,
    sum(s.forecast_quantity) as total_forecast_quantity,
    sum((forecast_quantity - sold_quantity)) as net_error,
    sum((forecast_quantity - sold_quantity))*100 / sum(forecast_quantity) as net_error_pct,
    sum(abs(forecast_quantity - sold_quantity)) as abs_error,
    sum(abs(forecast_quantity - sold_quantity))*100 / sum(forecast_quantity) as abs_error_pct
from fact_act_est s
join dim_customer c
using (customer_code)
where s.fiscal_year = 2021
group by s.customer_code)
select 
	*,
    if(abs_error_pct > 100, 0, (100 - abs_error_pct)) as forecast_accuracy
from forecast_error_table
order by forecast_accuracy desc;

-- forecast accuracy for fiscal year 2020
create temporary table forecast_accuracy_2020
with forecast_error_table as (select 
	s.customer_code as customer_code,
    c.customer as customer_name,
    c.market as market,
	sum(s.sold_quantity) as total_sold_quantity,
    sum(s.forecast_quantity) as total_forecast_quantity,
    sum((forecast_quantity - sold_quantity)) as net_error,
    sum((forecast_quantity - sold_quantity))*100 / sum(forecast_quantity) as net_error_pct,
    sum(abs(forecast_quantity - sold_quantity)) as abs_error,
    sum(abs(forecast_quantity - sold_quantity))*100 / sum(forecast_quantity) as abs_error_pct
from fact_act_est s
join dim_customer c
using (customer_code)
where s.fiscal_year = 2020
group by s.customer_code)
select 
	*,
    if(abs_error_pct > 100, 0, (100 - abs_error_pct)) as forecast_accuracy
from forecast_error_table
order by forecast_accuracy desc;

select
	f_2020.customer_code,
    f_2020.customer_name,
    f_2020.market,
    f_2020.forecast_accuracy as forecast_acc_2020,
    f_2021.forecast_accuracy as forecast_acc_2021
from forecast_accuracy_2020 f_2020
join forecast_accuracy_2021 f_2021
using(customer_code)
where f_2021.forecast_accuracy < f_2020.forecast_accuracy
order by f_2020.forecast_accuracy desc;
