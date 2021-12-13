drop table income ; 

create table income(
	County varchar(30) not null Primary Key, 
	Household_Median_Income int);
	
select * from income; 
select * from pssa; 

create table merge1 as(
SELECT income.county, income.household_median_income, pssa.district_name, pssa.school_name, pssa.subject, pssa.group_, pssa.grade, pssa.number_scored, pssa.percent_advanced, pssa.percent_proficient, pssa.percent_basic, pssa.percent_below_basic
FROM income
JOIN pssa
ON income.county = pssa.county);

select * from merge1; 

drop view math_scores

create view math_scores as ( 
select county, school_name, subject, group_, grade, percent_advanced, percent_proficient, percent_basic, percent_below_basic
from merge1 
where subject = 'Math' 
and group_= 'All Students'
and grade = 'Total');
	
select * from math_scores

create view advanced_math_score_avg as (
select avg(percent_advanced), county
-- avg(percent_proficient), avg(percent_basic), avg(percent_below_basic)
from math_scores
group by county);

alter table advanced_math_score_avg 
rename avg to Math_Advanced_Average;

drop view advanced_math_score_avg; 

select * from advanced_math_score_avg

create view proficient_math_score_avg as (
select avg(percent_proficient), county
-- avg(percent_proficient), avg(percent_basic), avg(percent_below_basic)
from math_scores
group by county);

alter table proficient_math_score_avg
rename avg to Math_proficient_Average;

drop view proficient_math_score_avg; 

select * from proficient_math_score_avg

create view basic_math_score_avg as (
select avg(percent_basic), county
-- avg(percent_proficient), avg(percent_basic), avg(percent_below_basic)
from math_scores
group by county);

alter table basic_math_score_avg
rename avg to Math_basic_Average;

drop view basic_math_score_avg; 

select * from basic_math_score_avg

create view below_basic_math_score_avg as (
select avg(percent_below_basic), county
-- avg(percent_proficient), avg(percent_basic), avg(percent_below_basic)
from math_scores
group by county);

alter table below_basic_math_score_avg
rename avg to Math_below_basic_Average;

drop view below_basic_math_score_avg; 

select * from below_basic_math_score_avg

create view math_adv_pro as (
select advanced_math_score_avg.county, advanced_math_score_avg.math_advanced_average, proficient_math_score_avg.Math_proficient_Average
from advanced_math_score_avg
join proficient_math_score_avg
on advanced_math_score_avg.county = proficient_math_score_avg.county
)

select * from math_adv_pro

create view math_adv_pro_basic as (
select math_adv_pro.county, math_adv_pro.math_advanced_average, math_adv_pro.Math_proficient_Average, basic_math_score_avg.Math_basic_Average
from math_adv_pro
join basic_math_score_avg
on math_adv_pro.county = basic_math_score_avg.county
)

select * from math_adv_pro_basic

create view math_county_avgs as (
select math_adv_pro_basic.county, math_adv_pro_basic.math_advanced_average, math_adv_pro_basic.Math_proficient_Average, math_adv_pro_basic.Math_basic_Average, below_basic_math_score_avg.Math_below_basic_Average
from math_adv_pro_basic
join below_basic_math_score_avg
on math_adv_pro_basic.county = below_basic_math_score_avg.county
)

select * from math_county_avgs


create view income_maths as(
select math_county_avgs.county, income.Household_Median_Income, math_county_avgs.math_advanced_average, math_county_avgs.Math_proficient_Average, math_county_avgs.Math_basic_Average, math_county_avgs.Math_below_basic_Average
from math_county_avgs
join income
on math_county_avgs.county = income.county);

select * from income_maths

create view income_math_scores as (
select county, Household_Median_Income, cast(income_maths.math_advanced_average as decimal(10,2)),
cast(income_maths.math_proficient_average as decimal(10,2)),
cast(income_maths.math_basic_average as decimal(10,2)),
cast(income_maths.math_below_basic_average as decimal(10,2))
from income_maths);

select * from income_math_scores

drop view income_math_scores; 

select * 
from income_math_scores
where county = 'Bucks' or county = 'Montgomery' or county = 'Union' 
Order By household_median_income


