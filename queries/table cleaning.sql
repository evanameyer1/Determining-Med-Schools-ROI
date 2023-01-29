-- cleaning physician 2016 data --

drop table clean_physicians_2016
create table clean_physician_2016 as
	select
		SpecialtyId as specialty_id,
		Specialty as specialty,
		translate("Number of Physicans", ',', '')::numeric::integer as physician_count,
		translate(Men, ',', '')::numeric::integer as male_physicians,
		translate(Woman, ',', '')::numeric::integer as female_physicians,
		translate(AVGSalary, '$,', '')::numeric::integer as yearly_salary,
		"Total Work Hours" as weekly_hours,
		"Medicine Satisfaction" as field_satisfaction,
		"Specialty Satisfaction" as specialty_satisfaction,
		"Income Satisfaction" as compensation_satisfaction,
		"Burned Out" as burn_out,
		"Overweight" as overweight,
		"Exercise" as exercise,
		"HappiestAtWork" as prefer_work,
		"HappiestOutside" as prefer_outside
		from clean_physicians_2016
		
-- cleaning physician 2018 data --

drop table clean_physicians_2018
create table clean_physician_2018 as
	select
		SpecialtyId as specialty_id,
		Specialty as specialty,
		translate("Number of Physicans", ',', '')::numeric::integer as physician_count,
		translate(Men, ',', '')::numeric::integer as male_physicians,
		translate(Woman, ',', '')::numeric::integer as female_physicians,
		translate(AVGSalary, '$,', '')::numeric::integer as yearly_salary,
		"Total Work Hours" as weekly_hours,
		"Medicine Satisfaction" as field_satisfaction,
		"Specialty Satisfaction" as specialty_satisfaction,
		"Income Satisfaction" as compensation_satisfaction,
		"Burned Out" as burn_out,
		"DepressionAndBurnout" as depressive_symptoms,
		"Fewer Friends" as poor_social_life,
		"Seek_Help" as seeking_prof_help,
		"HappiestAtWork" as prefer_work		
		from clean_physicians_2018

-- cleaning physician 2020 data --

drop table clean_physicians_2020
create table clean_physician_2020 as
	select
		SpecialtyId as specialty_id,
		Specialty as specialty,
		"Number of Physicans" as physician_count,
		Men as male_physicians,
		Woman as female_physicians,
		AVGSalary as yearly_salary,
		"Total Work Hours" as weekly_hours,
		"Specialty Satisfaction" as specialty_satisfaction,
		"Compensation Satisfaction" as compensation_satisfaction,
		"Burned Out" as burn_out,
		"Happiest Marriages" as happy_marriages,
		"Happiest Outside of Work" as prefer_outside		
		from clean_physicians_2020
		
-- cleaning physician 2022 data --

drop table clean_physicians_2022
create table clean_physician_2022 as
	select
		SpecialtyId as specialty_id,
		Specialty as specialty,
		"Number of Physicans" as physician_count,
		Men as male_physicians,
		Woman as female_physicians,
		AVGSalary as yearly_salary,
		"Total Work Hours" as weekly_hours,
		"Specialty Satisfaction" as specialty_satisfaction,
		"Compensation Satisfaction" as compensation_satisfaction,
		"Burned Out" as burn_out,
		"Suicidal Thoughts" as suicidal_thoughts,
		"Happiest Marriages" as happy_marriages		
		from clean_physicians_2022