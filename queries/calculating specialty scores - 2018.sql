-- calculating each physician specialty's compensation score 2018 --

drop table compensation_score_2018
(create table compensation_score_2018 as 

with t1 as (
		select
			sub.*,
			NTILE(15) OVER (ORDER BY sub."compensation/hr" ASC) as compensation_score
			from(
				select
					specialty_id,
					specialty,
					(yearly_salary / (weekly_hours * 52))::decimal::money as "compensation/hr"
					from clean_physician_2018 
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
					from clean_physician_2018 
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

-- calculating each physician specialty's satisfaction score 2018 --

drop table satisfaction_score_2018
create table satisfaction_score_2018 as 

with t1 as (
		select
			sub.*,
			NTILE(15) OVER (ORDER BY sub.field_satisfaction ASC) as field_satisfaction_score
			from(
				select
					specialty_id,
					specialty,
					field_satisfaction
					from clean_physician_2018 
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
					from clean_physician_2018 
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
	
-- calculating each physician specialty's happiness score 2018 --

drop table happiness_score_2018
create table happiness_score_2018 as 

with t1 as (
		select
			sub.*,
			NTILE(10) OVER (ORDER BY sub.burn_out DESC) as burn_out_score
			from(
				select
					specialty_id,
					specialty,
					burn_out
					from clean_physician_2018 
					order by 3 DESC
			) sub
			order by 3 asc
),

t2 as (
		select
			sub.*,
			NTILE(5) OVER (ORDER BY sub.depressive_symptoms DESC) as depressive_symptoms_score
			from(
				select
					specialty_id,
					specialty,
					depressive_symptoms
					from clean_physician_2018
					order by 3 DESC
			) sub
			order by 3 asc
),

t3 as (
		select
			sub.*,
			NTILE(5) OVER (ORDER BY sub.seeking_prof_help DESC) as seeking_prof_help_score
			from(
				select
					specialty_id,
					specialty,
					seeking_prof_help
					from clean_physician_2018 
					order by 3 DESC
			) sub
			order by 3 asc
),

t4 as (
		select
			sub.*,
			NTILE(5) OVER (ORDER BY sub.prefer_work ASC) as prefer_work_score
			from(
				select
					specialty_id,
					specialty,
					prefer_work
					from clean_physician_2018 
					order by 3 ASC
			) sub
			order by 3 desc
),

t5 as (
		select
			sub.*,
			NTILE(5) OVER (ORDER BY sub.poor_social_life DESC) as poor_social_life_score
			from(
				select
					specialty_id,
					specialty,
					poor_social_life
					from clean_physician_2018 
					order by 3 DESC
			) sub
			order by 3 asc
)

select
	t1.specialty_id,
	t1.specialty,
	'bottom '||(100 - ((avg(t1.burn_out_score)::integer - 1) * 10))||'%' as burn_out_percentile,
	'bottom '||(100 - ((avg(t2.depressive_symptoms_score)::integer - 1) * 10))||'%' as depressive_symptoms_percentile,
	'bottom '||(100 - ((avg(t3.seeking_prof_help_score)::integer - 1) * 10))||'%' as seeking_prof_help_percentile,
	'top '||(100 - ((avg(t4.prefer_work_score)::integer - 1) * 10))||'%' as prefer_work_percentile,
	'bottom '||(100 - ((avg(t5.poor_social_life_score)::integer - 1) * 10))||'%' as poor_social_life_percentile,
	(avg(t1.burn_out_score) + avg(t2.depressive_symptoms_score) + avg(t3.seeking_prof_help_score) + avg(t4.prefer_work_score) + avg(t5.poor_social_life_score))::integer as total 
	from t1
	join t2
		using(specialty_id)
	join t3
		using(specialty_id)
	join t4
		using(specialty_id)
	join t5
		using(specialty_id)
	group by 1, 2
	order by 8 desc
	
-- 2018 final scores -- 

drop table final_scores_2018
create table final_scores_2018 as 

select 
	comp.specialty_id,
	comp.specialty::text,
	comp.total as compensation_score,
	sat.total as satisfaction_score,
	hap.total as happiness_score,
	(comp.total + sat.total + hap.total) as total
	from clean_physician_2018 phys
	join compensation_score_2018 comp
		using(specialty_id)
	join satisfaction_score_2018 sat
		using(specialty_id)
	join happiness_score_2018 hap
		using(specialty_id)
	order by 6 desc
	
-- calculating pre_covid_scores --

drop table pre_covid_scores
create table pre_covid_scores as 

select 
	t1.specialty_id,
	t1.specialty::text,
	((t1.compensation_score + t2.compensation_score) / 2)::decimal(2, 0) as compensation_score,
	((t1.satisfaction_score + t2.satisfaction_score) / 2)::decimal(2, 0) as satisfaction_score,
	((t1.happiness_score + t2.happiness_score) / 2)::decimal(2, 0) as happiness_score,
	((t1.total + t2.total) / 2)::decimal(2, 0) as total
	from final_scores_2016 t1
	join final_scores_2018 t2
		using(specialty_id)
 	order by 6 desc
