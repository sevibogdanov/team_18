with base_table as (
select 
acd.add_id,     --уникальный id объявления
acd.add_link,   --ссылка
acd.district,   --наша версия точнее
acd.ad_date,    --время добавления объявления
acd.ad_title,   --заголовок объявления
acd.metro,      --ближайшее метро
case 
	when acd.do_metro like '%пешком%'  then 1
	else 0 end  as walk_to_metro_flg, --пешком до метро   
acd.address,      --адрес
acd.price,        --стоимость в рублях за месяц
acd.description,  --описание
acd.m_sqarea,     --м**2
acd.floor_flat,   --этаж
acd.floor_max,    --этажность
acd.rooms,        --комнаты
gt.lat latitude,  --широта
gt.lon longitude, --долгота
"name" district_name, --район
"Холодильник",
"Посудомоечная машина",
"Стиральная машина",
"Кондиционер",
"Телевизор",
"Интернет",
"Мебель на кухне",
"Мебель в комнатах",
"Оплата ЖКХ",
"Залог",
"Предоплата_месяцев",
"Срок аренды",
"С животными",
"С детьми",
"Общая площадь",
"Жилая площадь",
"Площадь кухни",
"Санузел",
"Балкон/лоджия",
"Вид из окон",
"Ремонт",
"Год постройки",
"Количество лифтов",
"Тип перекрытий",
"Парковка",
"Отопление",
"Аварийность",
floor(2*asin(sqrt((power(sin((radians(gt.lat)-radians(55.754708))/2),2)+cos(radians(55.754708))*cos(radians(gt.lat))*power(sin((radians(gt.lon)-radians(37.619694))/2),2))))*6371000/1000) dist_to_center, --удаленность от центра
floor(acd.price::float/acd.m_sqarea::float) r_per_meter, --рубль за метр
floor(acd.m_sqarea::float/acd.rooms::float) room_square --средняя площадь комнаты
from team18.ads_cards_detailed acd
left join team18.geocode_table gt using (address)
left join team18.msc_dim using(address) --отсюда берем osmid
left join team18.msc_polygons using(osmid) --тут можно взять и полигоны)
left join team18.every_page_parsed epp on epp.link = acd.add_link
)
--
select metro,walk_to_metro_flg,address,price,m_sqarea,floor_flat,floor_max,rooms,latitude,longitude,district_name,dist_to_center,r_per_meter,room_square,"Холодильник","Посудомоечная машина","Стиральная машина","Кондиционер","Телевизор","Интернет","Мебель на кухне","Мебель в комнатах","Оплата ЖКХ","Залог","Предоплата_месяцев","Срок аренды","С животными","С детьми","Общая площадь","Жилая площадь","Площадь кухни","Санузел","Балкон/лоджия","Вид из окон","Ремонт","Год постройки","Количество лифтов","Тип перекрытий","Парковка","Отопление","Аварийность",
count(case when object_type = 'schools' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) school_1000m,
count(case when object_type = 'shops' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<200 then 1 end) shops_200m,
count(case when object_type = 'theatre' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) theatre_1000m,
count(case when object_type = 'fitness' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<500 then 1 end) fitness_500m,
count(case when object_type = 'cinemas' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1500 then 1 end) cinemas_1500m,
count(case when object_type = 'foods' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) foods_1000m,
count(case when object_type = 'kindergarten' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<500 then 1 end) kindergarten_500m,
count(case when object_type = 'libraries' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) libraries_1000m,
count(case when object_type = 'parks' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<2000 then 1 end) parks_2000m,
count(case when object_type = 'post_office' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) post_office_1000m,
count(case when object_type = 'climbing' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) climbing_1000m,
count(case when object_type = 'fields' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) fields_1000m,
count(case when object_type = 'indoor_swimming_pool' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) indoor_swimming_pool_1000m,
count(case when object_type = 'malls' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<2000 then 1 end) malls_2000m,
count(case when object_type = 'outdoor_swimming_pool' 
	and floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<1000 then 1 end) outdoor_swimming_pool_1000m
	from base_table bt, team18.objects_other oo --тут заменить потом на вьюху с полными данными 
where floor(2*asin(sqrt((power(sin((radians(lat)-radians(latitude))/2),2)+cos(radians(latitude))*cos(radians(lat))*power(sin((radians(lon)-radians(longitude))/2),2))))*6371000)<2000
group by metro,walk_to_metro_flg,address,price,m_sqarea,floor_flat,floor_max,rooms,latitude,longitude,district_name,dist_to_center,r_per_meter,room_square,"Холодильник","Посудомоечная машина","Стиральная машина","Кондиционер","Телевизор","Интернет","Мебель на кухне","Мебель в комнатах","Оплата ЖКХ","Залог","Предоплата_месяцев","Срок аренды","С животными","С детьми","Общая площадь","Жилая площадь","Площадь кухни","Санузел","Балкон/лоджия","Вид из окон","Ремонт","Год постройки","Количество лифтов","Тип перекрытий","Парковка","Отопление","Аварийность"


