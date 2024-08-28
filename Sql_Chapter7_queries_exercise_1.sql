select 
	g.fiscal_year,
    round(sum(s.sold_quantity * g.gross_price), 2) as gross_price_total
from fact_sales_monthly s
join fact_gross_price g
on
	s.product_code = g.product_code and
    g.fiscal_year = get_fiscal_year(s.date)
where customer_code = 90002002
group by g.fiscal_year
order by g.fiscal_year asc;

select
	get_fiscal_year(date) as fiscal_year,
	sum(round(sold_quantity*g.gross_price,2)) as yearly_sales
from fact_sales_monthly s
join fact_gross_price g
on 
	g.fiscal_year=get_fiscal_year(s.date) and
	g.product_code=s.product_code
where
	customer_code=90002002
group by get_fiscal_year(date)
order by fiscal_year;
