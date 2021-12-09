drop table income ; 

create table income(
	County varchar(30) not null Primary Key, 
	Household_Median_Income int);

drop table PSSA; 

create table PSSA(
	AUN int, 
	School_Number int, 
	county varchar(30), 
	district_name varchar(30), 
	school_name varchar(30), 
	subject varchar(30), 
	group_ varchar(30), 
	grade varchar(30), 
	number_scored int, 
	percent_advanced FLOAT, 
	percent_proficient FLOAT, 
	percent_basic FLOAT, 
	percent_below_basic FLOAT); 