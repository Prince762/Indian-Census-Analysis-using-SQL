select * from census..data1;

select * from census..data2;

-- number of rows in the dataset

select count(*) from census..data1;

select count(*) from census..data2;

-- dataset for jharkhand and bihar

select * from census..data1 where state in ('Jharkhand' ,'Bihar');

-- Population of India

select SUM(Population) from census..data2;


-- average growth (convert into % )

select AVG(Growth)*100 avg_growth from census..data1;

-- average growth % for states

select state, AVG(Growth)*100 avg_growth from census..data1
group by state;


-- average sex ratio of states

select state, AVG(Sex_Ratio) avg_sxr from census..data1
group by state
order by avg_sxr desc;

-- average literacy rate of states

select state, round(AVG(Literacy),0) avg_lit from census..data1
group by state
order by avg_lit desc;

-- state with literacy rate > 90

select state, round(AVG(Literacy),0) avg_lit from census..data1
group by state
having round(AVG(Literacy),0) > 90
order by avg_lit desc;

-- top 3 states having highest growth %

select top 3 state, AVG(Growth)*100 avg_growth from census..data1
group by state
order by avg_growth desc;

-- top 3 states with lowest sex ratio

select top 3 state , AVG(Sex_Ratio) avg_sxr from census..data1
group by state
order by avg_sxr asc;

-- top and bottom 3 states in literacy rate
drop table if exists statelit;
create table statelit
( state  nvarchar(50),
topstates float
)

insert into statelit 
select state , round(AVG(Literacy),0) avg_lit from census..data1
group by state
order by avg_lit desc;

select top 3 * from statelit
order by topstates desc;


--------------------------------------
drop table if exists litstate;


create table litstate
( state  nvarchar(50),
bottom_states float
)

insert into litstate 
select state , round(AVG(Literacy),0) avg_lit from census..data1
group by state
order by avg_lit desc;

select top 3 * from litstate
order by bottom_states asc;


-- union of these tables


select * from (
select top 3 * from statelit
order by topstates desc ) as a

union

select * from (
select top 3 * from litstate
order by bottom_states asc) as b;


-- states starting with letter "A" and "B"
 
select distinct state from census..data1
where state like 'A%' or state like 'B%'

-- states starting with letter A and ending with letter M

select distinct state from census.. data1
where state like 'A%' and state like '%M'

alter table census..data1 alter column Sex_ratio float null


-- number of males and females in a state

-- sex ratio= females/males 

-- population=  females + males

-- population - males = females ......    

-- (population - males) = sex ratio * males

-- males = poulation/(sex ratio + 1)

-- femles = population - population(sex ratio + 1) = (population * sex_ratio)/(sex ratio + 1)

-- joining both the tables

select d.state , sum(d.males) males, sum(d.females) females from
(
select t3.district, t3.state, round(t3.population/(t3.Sex_ratio+1),0) males, round((t3.population * t3.sex_ratio)/(t3.sex_ratio+1),0) females 
from
(select t1.District, t1.State, t1.Sex_ratio/1000 sex_ratio, t2.Population from census..data1 t1 inner join census..data2  t2
on t1.district = t2.district) t3 ) d
group by d.State

-- total literacy rate

-- total literate = polulation * literacy rate

-- total illiterate = population * (1 - literacy rate)
select t5.state, sum(t5.total_literate) Literate, SUM(t5.total_illiterate) Illiterate from (
select t4.district, t4.state, round(t4.population * t4.literacy_ratio,0) total_literate , round(t4.population * (1-literacy_ratio), 0) total_illiterate from
(
select t1.District, t1.State, t1.Literacy/100 literacy_ratio, t2.Population from census..data1 t1 inner join census..data2  t2
on t1.district = t2.district) t4) t5
group by t5.State 

-- population in previous census

-- population_prev_census + growth * population_prev_census = population

-- prev census =  population/(1+ growth)

select sum(t8.Prev_census) Prev_population , SUM(t8.Current_pop) current_population from (
select t7.state, sum(t7.total_prev) Prev_census, sum(t7.population) Current_pop from
(
select t6.district, t6.state,t6.growth, round(t6.population/(1+ t6.growth),0) total_prev, t6.Population from
(
select t1.District, t1.State, t1.growth , t2.Population from census..data1 t1 inner join census..data2  t2
on t1.district = t2.district ) t6) t7
group by t7.State ) t8

-- population vs Area
alter table census..data2 alter column population float null;
select g.total_area/g.prev_population Prev_pop_vs_area, ( g.total_area/g.current_population) current_pop_vs_area from
(
select e.*,f.total_area from (

select '1' as keyy, c.* from(
select sum(t8.Prev_census) Prev_population , SUM(t8.Current_pop) current_population from (
select t7.state, sum(t7.total_prev) Prev_census, sum(t7.population) Current_pop from
(
select t6.district, t6.state,t6.growth, round(t6.population/(1+ t6.growth),0) total_prev, t6.Population from
(
select t1.District, t1.State, t1.growth , t2.Population from census..data1 t1 inner join census..data2  t2
on t1.district = t2.district ) t6) t7
group by t7.State ) t8) c) e   inner join (

select '1' as keyy2, d.* from (
select sum(area_km2) total_area from census..data2) d) f
on e.keyy = f.keyy2) g

-- window function

-- top 3 districts from each state with highest literacy rate


select a.* from (
select district, state, literacy, RANk() over(partition by state order by literacy desc)  rnk from census..data1) a
where a.rnk in (1,2,3)
order by state