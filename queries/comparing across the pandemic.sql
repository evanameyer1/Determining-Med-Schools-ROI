-- comparing pre/post covid --

select 
	t1.specialty_id,
	t1.specialty,
	t1.total as pre_covid_total,
	t2.total as post_covid_total, 
	(((t2.total::decimal - t1.total::decimal) / 90) * 100)::decimal(6, 2) as percent_difference,
	((t1.total + t2.total) / 2)::decimal(2) as total_average
	from pre_covid_scores t1
	join post_covid_scores t2
		using(specialty_id)
	order by 6 desc