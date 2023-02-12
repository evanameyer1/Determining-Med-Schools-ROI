-- calculating each physician specialty's compensation score 2020 --

drop table compensation_score_2020
create table compensation_score_2020 as 

with t1 as (
		select
			sub.*,
			NTILE(15) OVER (ORDER BY sub."compensation/hr" ASC) as compensation_score
			from(
				select
					specialty_id,
					specialty,
					(yearly_salary / (weekly_hours * 52))::decimal::money as "compensation/hr"
					from clean_physician_2020 
					order by 3 ASC
			) sub
			order by 3 desc
),

t2 as (
		select
			sub.*,
			NTILE(15) OVER (ORDER BY sub.satisfaction ASC) as satisfaction_score
			from(
				select
					specialty_id,
					specialty,
					compensation_satisfaction as satisfaction
					from clean_physician_2020
					order by 3 ASC
			) sub
			order by 3 desc
)

select
	t1.specialty_id,
	t1.specialty,
	t1."compensation/hr",
	'top '||(100 - ((avg(t1.compensation_score)::integer - 1) * 10))||'%' as compensation_percentile,
	'top '||(100 - ((avg(t2.satisfaction_score)::integer - 1) * 10))||'%' as satisfaction_percentile,
	(avg(t1.compensation_score) + avg(t2.satisfaction_score))::integer as total 
	from t1
	join t2
		using(specialty_id)
	group by 1, 2, 3
	order by 6 desc

-- calculating each physician specialty's satisfaction score 2020 --

drop table satisfaction_score_2020
create table satisfaction_score_2020 as 

select
	t2.specialty_id,
	t2.specialty,
	(NTILE(15) OVER (ORDER BY specialty_satisfaction ASC)) * 2 as specialty_satisfaction_score
	from clean_physician_2020 t2
	order by 3 desc
	
-- calculating each physician specialty's happiness score 2020 --

drop table happiness_score_2020
create table happiness_score_2020 as 

with t1 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.burn_out DESC) as burn_out_score
			from(
				select
					specialty_id,
					specialty,
					burn_out
					from clean_physician_2020 
					order by 3 DESC
			) sub
			order by 3 asc
),

t2 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.happy_marriages ASC) as happy_marriages_score
			from(
				select
					specialty_id,
					specialty,
					happy_marriages
					from clean_physician_2020
					order by 3 ASC
			) sub
			order by 3 asc
),

t3 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.prefer_outside DESC) as prefer_outside_score
			from(
				select
					specialty_id,
					specialty,
					prefer_outside
					from clean_physician_2020
					order by 3 DESC
			) sub
			order by 3 asc
)

select
	t1.specialty_id,
	t1.specialty,
	'bottom '||(100 - ((avg(t1.burn_out_score)::integer - 1) * 10))||'%' as burn_out_percentile,
	'bottom '||(100 - ((avg(t2.happy_marriages_score)::integer - 1) * 10))||'%' as happy_marriages_percentile,
	'bottom '||(100 - ((avg(t3.prefer_outside_score)::integer - 1) * 10))||'%' as prefer_outside_percentile,
	(avg(t1.burn_out_score) + avg(t2.happy_marriages_score) + avg(t3.prefer_outside_score))::integer as total 
	from t1
	join t2
		using(specialty_id)
	join t3
		using(specialty_id)
	group by 1, 2
	order by 6 desc
	
-- 2020 final scores -- 

drop table final_scores_2020
create table final_scores_2020 as 

select 
	comp.specialty_id,
	comp.specialty::text,
	comp.total as compensation_score,
	sat.specialty_satisfaction_score as satisfaction_score,
	hap.total as happiness_score,
	(comp.total + sat.specialty_satisfaction_score + hap.total) as total
	from clean_physician_2020 phys
	join compensation_score_2020 comp
		using(specialty_id)
	join satisfaction_score_2020 sat
		using(specialty_id)
	join happiness_score_2020 hap
		using(specialty_id)
	order by 6 desc
