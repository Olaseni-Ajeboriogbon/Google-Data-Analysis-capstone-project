---Combining all tables of the months into a single table----------------------------------------------------

select * into Appended_data 
from dbo.january_trip
union all
select * from dbo.feb_trip
union all
select * from dbo.march_trip
union all
select * from dbo.April
union all
select * from dbo.may_trip
union all
select * from dbo.june
union all
select * from dbo.july_trip
union all
select * from dbo.August_trip
union all
select * from dbo.september_trip
union all
select * from dbo.october
union all
select * from dbo.nov_trip

select * from Appended_data

--- Removing Null from the newly created table-------------------------------------------------------------------------------------------

select * into cleaned_table from appended_data 
where 
ride_id is not null 
and start_station_name IS NOT NULL		
AND end_station_name IS NOT NULL
and start_station_id IS NOT NULL
and end_station_id IS NOT NULL
and start_lat is not null
and start_lng IS NOT NULL
and end_lat IS NOT NULL
and end_lng IS NOT NULL

select * from cleaned_table

select start_station_name,end_station_name,
start_station_id,end_station_id,start_lat,end_lat,start_lng ,end_lng from cleaned_table

select distinct start_station_name,end_station_name,
start_station_id,end_station_id from cleaned_table
order by 1,2

--- creating a calculated column of ride_length-----------------------------------------------------------------------------------------------

select ride_id, rideable_type,member_casual,
DATEDIFF(minute,started_at,ended_at) As Ride_length 
from cleaned_table
order by 1


----Extracting day of the month and month from the start_at which contains date and time -----------------------------------------------------

select ride_id,rideable_type,started_at,ended_at,DATEDIFF(minute,started_at,ended_at) As Ride_length,
MONTH(started_at) As Months,DATENAME (MONTH, DATEADD(MONTH, MONTH(started_at) - 1, '1900-01-01')) Monthname,DATENAME(w, started_at) AS Dayname,
Day(started_at) as day_of_month,
start_station_name,Start_station_id,End_station_name,
End_station_id,start_lat,start_lng,end_lat,end_lng,member_casual
into final_data from cleaned_table


select * from final_data 

---- Number of rides taken so far ---------------------------------------------------------------------

SELECT COUNT(distinct ride_id) as Total_rides from final_data

---Number of rides per month and day------------

select months,monthname,COUNT(distinct ride_id) as RidePerMonth from final_data
group by months,monthname
order by months

select dayname,COUNT(distinct ride_id) as RidePerday,
CASE
	when dayname = 'Sunday' then 1
	when dayname = 'Monday' then 2
	when dayname = 'Tuesday' then 3
	when dayname = 'Wednesday' then 4
	when dayname = 'Thursday' then 5
	when dayname = 'Friday' then 6
ELSE 7
END as day_no
from final_data
group by Dayname
order by day_no

----- Number of rideable_type of bike by member_casual

select member_casual,rideable_type,COUNT(distinct ride_id) as no_of_rideable_type from final_data
group by rideable_type,member_casual

-----Number of rides by stations----------------------------------------------------------------------------------------------------------------
select distinct start_station_name,count(distinct ride_id) as no_of_rides from final_data 
group by start_station_name
order by count(distinct ride_id) desc

select distinct End_station_name,count(distinct ride_id) as no_of_rides from final_data 
group by End_station_name
order by count(distinct ride_id) desc

---- avg Length of rides by member-------------------------------------------------------------------------------------------------------

select member_casual,Avg(Ride_length) as Avg_ride_length 
from final_data
group by member_casual

-----no of rides by time of day ------------------------------------------------------------------------------------------------------------------

Select  months,monthname,dayname,member_casual, COUNT(distinct ride_id) as no_of_rides,
	case when cast(started_at as time) >='06:00' and cast(started_at as time) <'12:00' then 'Morning'
		 when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
		 when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
	else 'Night'
		End as Time_of_day
		from final_data
		group by months,Monthname,Dayname,member_casual,
		case when cast(started_at as time) >='06:00' and cast( started_at as time) <'12:00' then 'Morning'
		when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
		when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
		else 'Night'
		end
		order by Months

------no of ride by day only-------------------------------------------------------------------------------------------------------------

Select dayname,member_casual, COUNT(distinct ride_id) as no_of_rides,
	case when cast(started_at as time) >='06:00' and cast(started_at as time) <'12:00' then 'Morning'
		 when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
		 when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
	else 'Night'
		End as Time_of_day
		from final_data
		group by Dayname,member_casual,
		case when cast(started_at as time) >='06:00' and cast( started_at as time) <'12:00' then 'Morning'
		when cast(started_at as time) >='12:00' and cast( started_at as time) <'17:00' then 'Afteroon'
		when cast(started_at as time) >='17:00' and cast( started_at as time) <'20:00' then 'Evening'
		else 'Night'
		end
		order by dayname
----rides by season of the year----------------------------------------------------------------------------------------------------------

SELECT  Months,Monthname,member_casual,count(distinct ride_id) as no_of_riders,
case when Monthname in ('January', 'February') then 'Winter'
	 when Monthname in ('March', 'April', 'May') then 'Spring'
	 when Monthname in ('June', 'July', 'August') then 'Summer'
	 when Monthname in ('September' , 'October' , 'November') then 'Autumn'
else 'Unknown'
	 end as Season_of_the_year
	 from final_data
	 group by months,Monthname,member_casual
	 order by Months

