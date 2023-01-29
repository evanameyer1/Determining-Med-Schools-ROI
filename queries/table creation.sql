drop table specialty_count
create table specialty_count (
	specialty TEXT,
	total_active_physicians TEXT,
	patient_care TEXT,
	teaching TEXT,
	research TEXT,
	other TEXT
);

COPY specialty_count(specialty,total_active_physicians,patient_care,teaching,research,other) 
	from 'C:\Users\evana\OneDrive\Desktop\github projects\Med-School ROI\original datasources\leading specializations.csv' DELIMITER ',' CSV HEADER;
	
select *
from specialty_count

create table clean_specialty_count as
select 
	specialty,
	translate(total_active_physicians, ',', '')::numeric as total_active_physicians,
	translate(patient_care, ',', '')::numeric as patient_care,
	translate(teaching, ',', '')::numeric as teaching,
	translate(research, ',', '')::numeric as research,
	translate(other, ',', '')::numeric as other
	from specialty_count
	where specialty != 'All Specialties'
	order by 2 desc


with t1 as (
select 
	specialty,
	translate(total_active_physicians, ',', '')::numeric as total_active_physicians,
	translate(patient_care, ',', '')::numeric as patient_care,
	translate(teaching, ',', '')::numeric as teaching,
	translate(research, ',', '')::numeric as research,
	translate(other, ',', '')::numeric as other
	from specialty_count
	where specialty != 'All Specialties'
	order by 2 desc
	limit 10
),

with t1 as (
select * 
	from clean_specialty_count
	limit 10
),

t2 as (
select *
	from clean_specialty_count
)

	select 
		((sub.total1) / (sub.total2)) as percent_of_total
		from (
		select 
			sum(t1.total_active_physicians) as total1,
			sum(t2.total_active_physicians) as total2
			from t1, t2
		) sub
	
	