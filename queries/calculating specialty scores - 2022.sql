-- calculating each physician specialty's compensation score 2022 --

drop table compensation_score_2022
create table compensation_score_2022 as 

with t1 as (
		select
			sub.*,
			NTILE(15) OVER (ORDER BY sub."compensation/hr" ASC) as compensation_score
			from(
				select
					specialty_id,
					specialty,
					(yearly_salary / (weekly_hours * 52))::decimal::money as "compensation/hr"
					from clean_physician_2022 
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
					from clean_physician_2022
					order by 3 ASC
			) sub
			order by 3 desc
)

select
	t1.specialty_id,
	t1.specialty,
	t1."compensation/hr",
	t1.compensation_score as compensation_percentile,
	t2.satisfaction_score as satisfaction_percentile,
	t1.compensation_score + t2.satisfaction_score as total 
	from t1
	join t2
		using(specialty_id)
	order by 6 desc

-- calculating each physician specialty's satisfaction score 2022 --

drop table satisfaction_score_2022
create table satisfaction_score_2022 as 

select
	t2.specialty_id,
	t2.specialty,
	(NTILE(15) OVER (ORDER BY specialty_satisfaction ASC)) * 2 as specialty_satisfaction_score
	from clean_physician_2022 t2
	order by 3 desc
	
-- calculating each physician specialty's happiness score 2020 --

drop table happiness_score_2022
create table happiness_score_2022 as 

with t1 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.burn_out DESC) as burn_out_score
			from(
				select
					specialty_id,
					specialty,
					burn_out
					from clean_physician_2022 
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
					from clean_physician_2022
					order by 3 ASC
			) sub
			order by 3 asc
),

t3 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.suicidal_thoughts DESC) as suicidal_thoughts_score
			from(
				select
					specialty_id,
					specialty,
					suicidal_thoughts
					from clean_physician_2022
					order by 3 DESC
			) sub
			order by 3 asc
)

select
	t1.specialty_id,
	t1.specialty,
	t1.burn_out_score,
	t2.happy_marriages_score,
	t3.suicidal_thoughts_score,
	t1.burn_out_score + t2.happy_marriages_score + t3.suicidal_thoughts_score as total 
	from t1
	join t2
		using(specialty_id)
	join t3
		using(specialty_id)
	order by 6 desc
	
-- 2022 final scores -- 

drop table final_scores_2022
create table final_scores_2022 as 

select 
	comp.specialty_id,
	comp.specialty::text,
	comp.total as compensation_score,
	sat.specialty_satisfaction_score as satisfaction_score,
	hap.total as happiness_score,
	(comp.total + sat.specialty_satisfaction_score + hap.total) as total
	from clean_physician_2022 phys
	join compensation_score_2022 comp
		using(specialty_id)
	join satisfaction_score_2022 sat
		using(specialty_id)
	join happiness_score_2022 hap
		using(specialty_id)
	order by 6 desc

-- calculating post_covid_scores --

drop table post_covid_scores
create table post_covid_scores as 

select 
	t1.specialty_id,
	t1.specialty::text,
	((t1.compensation_score + t2.compensation_score) / 2)::decimal(2, 0) as compensation_score,
	((t1.satisfaction_score + t2.satisfaction_score) / 2)::decimal(2, 0) as satisfaction_score,
	((t1.happiness_score + t2.happiness_score) / 2)::decimal(2, 0) as happiness_score,
	((t1.total + t2.total) / 2)::decimal(2, 0) as total
	from final_scores_2020 t1
	join final_scores_2022 t2
		using(specialty_id)
 	order by 6 desc
