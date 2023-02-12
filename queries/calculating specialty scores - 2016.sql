-- calculating each physician specialty's compensation score 2016 --

drop table compensation_score_2016
create table compensation_score_2016 as 

with t1 as (
		select
			sub.*,
			NTILE(15) OVER (ORDER BY sub."compensation/hr" ASC) as compensation_score
			from(
				select
					specialty_id,
					specialty,
					(yearly_salary / (weekly_hours * 52))::decimal::money as "compensation/hr"
					from clean_physician_2016 
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
					from clean_physician_2016 
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

-- calculating each physician specialty's satisfaction score 2016 --

drop table satisfaction_score_2016
create table satisfaction_score_2016 as 

with t1 as (
		select
			sub.*,
			NTILE(15) OVER (ORDER BY sub.field_satisfaction ASC) as field_satisfaction_score
			from(
				select
					specialty_id,
					specialty,
					field_satisfaction
					from clean_physician_2016 
					order by 3 ASC
			) sub
			order by 3 desc
),

t2 as (
		select
			sub.*,
			NTILE(15) OVER (ORDER BY sub.specialty_satisfaction ASC) as specialty_satisfaction_score
			from(
				select
					specialty_id,
					specialty,
					specialty_satisfaction
					from clean_physician_2016 
					order by 3 ASC
			) sub
			order by 3 desc
)

select
	t1.specialty_id,
	t1.specialty,
	'top '||(100 - ((avg(t1.field_satisfaction_score)::integer - 1) * 10))||'%' as field_satisfaction_percentile,
	'top '||(100 - ((avg(t2.specialty_satisfaction_score)::integer - 1) * 10))||'%' as specialty_satisfaction_percentile,
	(avg(t1.field_satisfaction_score) + avg(t2.specialty_satisfaction_score))::integer as total 
	from t1
	join t2
		using(specialty_id)
	group by 1, 2
	order by 5 desc
	
-- comparing compensation and satisfaction scores across specialties --

select 
	comp.specialty_id,
	comp.specialty,
	comp.total as compensation_score,
	sat.total as satisfaction_score,
	comp.total + sat.total as total
	from compensation_score_2016 comp
	join satisfaction_score_2016 sat
	using(specialty_id)
	order by 5 desc
	
-- calculating each physician specialty's happiness score 2016 --

drop table happiness_score_2016
create table happiness_score_2016 as 

with t1 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.burn_out DESC) as burn_out_score
			from(
				select
					specialty_id,
					specialty,
					burn_out
					from clean_physician_2016 
					order by 3 DESC
			) sub
			order by 3 asc
),

t2 as (
		select
			sub.*,
			NTILE(5) OVER (ORDER BY sub.overweight DESC) as overweight_score
			from(
				select
					specialty_id,
					specialty,
					overweight
					from clean_physician_2016 
					order by 3 DESC
			) sub
			order by 3 asc
),

t3 as (
		select
			sub.*,
			NTILE(5) OVER (ORDER BY sub.exercise ASC) as exercise_score
			from(
				select
					specialty_id,
					specialty,
					exercise
					from clean_physician_2016 
					order by 3 ASC
			) sub
			order by 3 desc
),

t4 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.prefer_work ASC) as prefer_work_score
			from(
				select
					specialty_id,
					specialty,
					prefer_work
					from clean_physician_2016 
					order by 3 ASC
			) sub
			order by 3 desc
)

select
	t1.specialty_id,
	t1.specialty,
	'bottom '||(100 - ((avg(t1.burn_out_score)::integer - 1) * 10))||'%' as burn_out_percentile,
	'bottom '||(100 - ((avg(t2.overweight_score)::integer - 1) * 10))||'%' as overweight_percentile,
	'top '||(100 - ((avg(t3.exercise_score)::integer - 1) * 10))||'%' as exercise_percentile,
	'top '||(100 - ((avg(t4.prefer_work_score)::integer - 1) * 10))||'%' as prefer_work_percentile,
	(avg(t1.burn_out_score) + avg(t2.overweight_score) + avg(t3.exercise_score) + avg(t4.prefer_work_score))::integer as total 
	from t1
	join t2
		using(specialty_id)
	join t3
		using(specialty_id)
	join t4
		using(specialty_id)
	group by 1, 2
	order by 7 desc

-- comparing compensation, satisfaction and happiness scores across specialties --

select 
	comp.specialty_id,
	comp.specialty,
	comp.total as compensation_score,
	sat.total as satisfaction_score,
	hap.total as happiness_score,
	comp.total + sat.total + hap.total as total
	from compensation_score_2016 comp
	join satisfaction_score_2016 sat
		using(specialty_id)
	join happiness_score_2016 hap
		using(specialty_id)
	order by 6 desc
	
-- adding in workplace priorities --

drop table workplace_priority_2016
create table workplace_priority_2016 as 

with t1 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.prefer_work ASC) as prefer_work_score
			from(
				select
					specialty_id,
					specialty,
					prefer_work
					from clean_physician_2016 
					order by 3 ASC
			) sub
			order by 3 desc
),

t2 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.prefer_outside ASC) as prefer_outside_score
			from(
				select
					specialty_id,
					specialty,
					prefer_outside
					from clean_physician_2016 
					order by 3 ASC
			) sub
			order by 3 desc
)

select
	t1.specialty_id,
	t1.specialty,
	t1.prefer_work_score as prefer_work_score,
	t2.prefer_outside_score as prefer_outside_score
	from t1
	join t2
		using(specialty_id)
	
-- final 2016 score by specialty and blocked by workplace priority --

	---- workplace priority: prefer work ----

select 
	'Total Averages' as specialty_id,
	'For those who: PREFER WORK' as specialty,
	'$'||avg((phys.yearly_salary / (phys.weekly_hours * 52)))::decimal(5,2)||'/hr' as yearly_salary,
	avg(comp.total)::decimal(4,2) as compensation_score,
	((avg(((phys.field_satisfaction) + (phys.specialty_satisfaction)) / 2)::decimal(4,2)) * 100)||'% Satisfied' as satisfaction,
	avg(sat.total)::decimal(4,2) as satisfaction_score,
	((avg(phys.burn_out::decimal))::decimal(4,2) * 100)||'% Burned Out' as happiness,
	avg(hap.total)::decimal(4,2) as happiness_score,
	avg(comp.total + sat.total + hap.total + work.prefer_work_score)::decimal(4,2)||'/100' as total
	from clean_physician_2016 phys
	join compensation_score_2016 comp
		using(specialty_id)
	join satisfaction_score_2016 sat
		using(specialty_id)
	join happiness_score_2016 hap
		using(specialty_id)
	join workplace_priority_2016 work
		using(specialty_id)
	group by 1, 2
	
union all

select 
	sub.*
	from (
	select 
		comp.specialty_id::text,
		comp.specialty::text,
		'$'||(phys.yearly_salary / (phys.weekly_hours * 52))::decimal(5,2)||'/hr' as yearly_salary,
		comp.total as compensation_score,
		(((((phys.field_satisfaction) + (phys.specialty_satisfaction)) / 2)::decimal(4,2)) * 100)::integer||'%' as satisfaction_rate,
		sat.total as satisfaction_score,
		((phys.burn_out::decimal)::decimal(4,2) * 100)::integer||'%' as burn_out_rate,
		hap.total as happiness_score,
		(comp.total + sat.total + hap.total + work.prefer_work_score)::text as total
		from clean_physician_2016 phys
		join compensation_score_2016 comp
			using(specialty_id)
		join satisfaction_score_2016 sat
			using(specialty_id)
		join happiness_score_2016 hap
			using(specialty_id)
		join workplace_priority_2016 work
			using(specialty_id)
		order by 9 desc
	) sub

	---- workplace priority: prefer outside of work ----

select 
	'Total Averages' as specialty_id,
	'For those who: PREFER OUTSIDE' as specialty,
	'$'||avg((phys.yearly_salary / (phys.weekly_hours * 52)))::decimal(5,2)||'/hr' as yearly_salary,
	avg(comp.total)::decimal(4,2) as compensation_score,
	((avg(((phys.field_satisfaction) + (phys.specialty_satisfaction)) / 2)::decimal(4,2)) * 100)||'% Satisfied' as satisfaction,
	avg(sat.total)::decimal(4,2) as satisfaction_score,
	((avg(phys.burn_out::decimal))::decimal(4,2) * 100)||'% Burned Out' as happiness,
	avg(hap.total)::decimal(4,2) as happiness_score,
	avg(comp.total + sat.total + hap.total + work.prefer_outside_score)::decimal(4,2)||'/100' as total
	from clean_physician_2016 phys
	join compensation_score_2016 comp
		using(specialty_id)
	join satisfaction_score_2016 sat
		using(specialty_id)
	join happiness_score_2016 hap
		using(specialty_id)
	join workplace_priority_2016 work
		using(specialty_id)
	group by 1, 2
	
union all

select 
	sub.*
	from (
	select 
		comp.specialty_id::text,
		comp.specialty::text,
		'$'||(phys.yearly_salary / (phys.weekly_hours * 52))::decimal(5,2)||'/hr' as yearly_salary,
		comp.total as compensation_score,
		(((((phys.field_satisfaction) + (phys.specialty_satisfaction)) / 2)::decimal(4,2)) * 100)::integer||'%' as satisfaction_rate,
		sat.total as satisfaction_score,
		((phys.burn_out::decimal)::decimal(4,2) * 100)::integer||'%' as burn_out_rate,
		hap.total as happiness_score,
		(comp.total + sat.total + hap.total + work.prefer_outside_score)::text as total
		from clean_physician_2016 phys
		join compensation_score_2016 comp
			using(specialty_id)
		join satisfaction_score_2016 sat
			using(specialty_id)
		join happiness_score_2016 hap
			using(specialty_id)
		join workplace_priority_2016 work
			using(specialty_id)
		order by 9 desc
	) sub
	
-- 2016 final scores -- 

drop table final_scores_2016
create table final_scores_2016 as 

select 
	comp.specialty_id,
	comp.specialty::text,
	comp.total as compensation_score,
	sat.total as satisfaction_score,
	hap.total as happiness_score,
	(comp.total + sat.total + hap.total) as total
	from clean_physician_2016 phys
	join compensation_score_2016 comp
		using(specialty_id)
	join satisfaction_score_2016 sat
		using(specialty_id)
	join happiness_score_2016 hap
		using(specialty_id)
	join workplace_priority_2016 work
		using(specialty_id)
	order by 6 desc