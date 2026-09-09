with daily_weather as (
    select 
    date(time) as daily_weather,
    weather,
    temp,
    pressure,
    humidity,
    clouds
    from {{ source('demo', 'weather') }}
    limit 10
)

,
 daily_weather_agg as(

    select 
    daily_weather,
    weather,
    avg(temp) as avg_temp,
    ROUND(avg(pressure),2) as avg_pressure,
    avg(humidity) as avg_humidity,
    avg(clouds) as avg_clouds,

    count (weather) ,
    row_number() over (PARTITION by daily_weather order by (count(weather)) desc ) AS row_number
    from daily_weather
    group by daily_weather, weather

    -- you  use qualify to filter the results of a window function
    qualify  row_number() over (PARTITION by daily_weather order by (count(weather)) desc )  = 1

 )

select * from daily_weather_agg