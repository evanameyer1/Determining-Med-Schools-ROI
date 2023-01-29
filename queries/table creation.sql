drop table specialty_count
MAcreate table specialty_count (
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
	
-- uploading pre pandemic data 2016 --

drop table clean_physicians_2016

create table clean_physicians_2016 (
	SpecialtyId INTEGER PRIMARY KEY,
	Specialty TEXT,
	"Number of Physicans" TEXT,
	AVGSalary TEXT,
	"Medicine Satisfaction" NUMERIC,
	"Income Satisfaction" NUMERIC,
	Men TEXT,
	Woman TEXT,
	"Specialty Satisfaction" NUMERIC,
	"Total Work Hours" NUMERIC,
	"Burned Out" NUMERIC,
	"Overweight" NUMERIC,
	"Exercise" NUMERIC,
	"HappiestAtWork" NUMERIC,
	"HappiestOutside" NUMERIC
);

COPY clean_physicians_2016(SpecialtyId,Specialty,"Number of Physicans",AVGSalary,"Medicine Satisfaction","Income Satisfaction",
						   Men,Woman,"Specialty Satisfaction","Total Work Hours","Burned Out","Overweight",
						   "Exercise","HappiestAtWork","HappiestOutside")
	FROM 'C:\Users\evana\OneDrive\Desktop\github projects\Med School ROI\updated datasources\clean_physician_data_2016.csv' DELIMITER ',' CSV HEADER;


-- uploading pre pandemic data 2018 --

drop table clean_physicians_2018

create table clean_physicians_2018 (
	SpecialtyId INTEGER PRIMARY KEY,
	Specialty TEXT,
	"Number of Physicans" TEXT,
	AVGSalary TEXT,
	"Medicine Satisfaction" NUMERIC,
	"Income Satisfaction" NUMERIC,
	Men TEXT,
	Woman TEXT,
	"Specialty Satisfaction" NUMERIC,
	"Total Work Hours" NUMERIC,
	"Burned Out" NUMERIC,
	"Fewer Friends" NUMERIC,
	"Seek_Help" NUMERIC,
	"HappiestAtWork" NUMERIC,
	"DepressionAndBurnout" NUMERIC
);

COPY clean_physicians_2018(SpecialtyId,Specialty,"Number of Physicans",AVGSalary,"Medicine Satisfaction","Income Satisfaction",
						   Men,Woman,"Specialty Satisfaction","Total Work Hours","Burned Out","Fewer Friends","Seek_Help","HappiestAtWork","DepressionAndBurnout")
	FROM 'C:\Users\evana\OneDrive\Desktop\github projects\Med School ROI\updated datasources\clean_physician_data_2018.csv' DELIMITER ',' CSV HEADER;

-- uploading post pandemic data 2020 --

drop table clean_physicians_2020

create table clean_physicians_2020 (
	SpecialtyId INTEGER PRIMARY KEY,
	Specialty TEXT,
	"Number of Physicans" INTEGER,
	AVGSalary INTEGER,
	AVGBonus INTEGER,
	"Compensation Satisfaction" NUMERIC,
	Men INTEGER,
	Woman INTEGER,
	"Specialty Satisfaction" NUMERIC,
	"Total Work Hours" INTEGER,
	"Weekly Work Hours w/ Patients" NUMERIC,
	"Weekly Work Hours on Paperwork" NUMERIC,
	"Happiest Outside of Work" NUMERIC,
	"Happiest Marriages" NUMERIC,
	"Burned Out" NUMERIC	
);

COPY clean_physicians_2020(SpecialtyId,Specialty,"Number of Physicans",AVGSalary,AVGBonus,"Compensation Satisfaction",
						   Men,Woman,"Specialty Satisfaction","Total Work Hours","Weekly Work Hours w/ Patients",
						   "Weekly Work Hours on Paperwork","Happiest Outside of Work","Happiest Marriages","Burned Out")
	FROM 'C:\Users\evana\OneDrive\Desktop\github projects\Med School ROI\updated datasources\clean_physician_data_2020.csv' DELIMITER ',' CSV HEADER;


-- uploading post pandemic data 2022 --

drop table clean_physicians_2022

create table clean_physicians_2022 (
	SpecialtyId INTEGER PRIMARY KEY,
	Specialty TEXT,
	"Number of Physicans" INTEGER,
	AVGSalary INTEGER,
	AVGBonus INTEGER,
	"Compensation Satisfaction" NUMERIC,
	Men INTEGER,
	Woman INTEGER,
	"Specialty Satisfaction" NUMERIC,
	"Total Work Hours" INTEGER,
	"Weekly Work Hours w/ Patients" NUMERIC,
	"Weekly Work Hours on Paperwork" NUMERIC,
	"Happiest Marriages" NUMERIC,
	"Burned Out" NUMERIC,
	"Suicidal Thoughts" NUMERIC
);

COPY clean_physicians_2022(SpecialtyId,Specialty,"Number of Physicans",AVGSalary,AVGBonus,"Compensation Satisfaction",
						   Men,Woman,"Specialty Satisfaction","Total Work Hours","Weekly Work Hours w/ Patients",
						   "Weekly Work Hours on Paperwork","Happiest Marriages","Burned Out", "Suicidal Thoughts")
	FROM 'C:\Users\evana\OneDrive\Desktop\github projects\Med School ROI\updated datasources\clean_physician_data_2022.csv' DELIMITER ',' CSV HEADER;