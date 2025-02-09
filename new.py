from selenium import webdriver
from bs4 import BeautifulSoup
import time
import pandas as pd
import re
from sqlalchemy import create_engine

df = pd.read_csv('9645_12860_Иван.csv')
df_new = df['add_link'].iloc[2100:2400]
links = df_new.values.tolist()

ad_features_dict = {}

columns = ['Холодильник', 'Посудомоечная машина', 'Стиральная машина', 'Кондиционер', 'Телевизор', 'Интернет', 'Мебель на кухне', 'Мебель в комнатах', 
           'Оплата ЖКХ' ,'Залог','Комиссии','Предоплата','Срок аренды','Условия проживания',
           'Общая площадь', 'Жилая площадь', 'Площадь кухни', 'Санузел', 'Балкон/лоджия','Вид из окон', 'Ремонт', 
           'Год постройки', 'Количество лифтов', 'Тип перекрытий', 'Парковка', 'Отопление', 'Аварийность'
           ]


for link in links:
    driver = webdriver.Chrome()
    x_values = ['a10a3f92e9--item--hwrM1', 'a10a3f92e9--item--iWTsg', 'a10a3f92e9--item--qJhdR']
    driver.get(link)
    time.sleep(3)  
    content = driver.page_source
    soup = BeautifulSoup(content, "html.parser")
    ad_feature_list = []
    
    for x in x_values:
        for i in soup.findAll('div', class_=x): 
            ad_feature_list.append(i.text)
    ad_features_dict[link] = ad_feature_list

    driver.quit()

print(ad_features_dict)

df = pd.DataFrame(columns=columns)

# Заполняем DataFrame
for index, values in ad_features_dict.items():
    row = {}
    for value in values:
        # Проверяем, содержит ли значение название столбца
        for column_name in columns:
            if column_name in value:
                # Извлекаем значение, если оно содержит название столбца
                # Убираем название столбца из строки и оставляем только значение
                extracted_value = re.sub(rf'{column_name}.*?(\d+)', r'\1', value)
                row[column_name] = extracted_value.strip()  # Убираем лишние пробелы
                break  # Выходим из цикла, если нашли соответствие
            else:
                # Если значение не содержит название столбца, просто добавляем его
                if column_name not in row:  # Проверяем, чтобы не перезаписывать
                    row[column_name] = None  # Если значение не найдено, ставим None

    df.loc[index] = row  # Добавляем строку в DataFrame

def convert_to_binary(value):
    if value is None:  
        return 0
    else: 
        return 1
    
columns_to_convert_bin = ['Холодильник', 'Посудомоечная машина', 'Стиральная машина', 'Кондиционер', 'Телевизор', 'Интернет', 'Мебель на кухне', 'Мебель в комнатах']

for column in columns_to_convert_bin:
    df[column] = df[column].apply(convert_to_binary)


def remove_column_names_from_values(df, column_names):
    """
    Удаляет из значений в указанных столбцах подстроку, совпадающую с названием этих столбцов.
    Оставляет только ту часть строки, которая не равна названию столбца.

    :param df: DataFrame, в котором нужно произвести замену
    :param column_names: Список названий столбцов, в которых будет производиться проверка
    :return: Обновленный DataFrame с измененными значениями
    """
    
    for column_name in column_names:
        if column_name not in df.columns:
            raise ValueError(f"Столбец '{column_name}' не найден в DataFrame.")


    def process_value(value, column_name):
        if pd.isna(value):  
            return value
        if column_name in value:  
            return value.replace(column_name, '')  
        return value  

    for column_name in column_names:
        df[column_name] = df[column_name].apply(lambda x: process_value(x, column_name))

    return df

columns_to_convert = ['Оплата ЖКХ' ,'Залог','Комиссии','Предоплата','Срок аренды','Условия проживания','Общая площадь', 'Жилая площадь', 'Площадь кухни', 'Санузел', 'Балкон/лоджия','Вид из окон', 'Ремонт', 'Год постройки', 'Количество лифтов', 'Тип перекрытий', 'Парковка', 'Отопление', 'Аварийность']

df = remove_column_names_from_values(df, columns_to_convert)


db_host = "51.250.99.11"
db_port = "5432"
db_name = "postgres"
db_user = "team18"
schema_name = 'team18'
db_password = "team_18"
engine = create_engine(f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}') #Соединение с БД для выгрузки

def pg1():
    from sqlalchemy.engine import create_engine
    connection = create_engine('postgresql://team18:team_18@51.250.99.11:5432/postgres')
    return connection


df.to_sql(
      name='Ivan_2100_2400',
      schema='team18',
      con=pg1(),
      if_exists='replace'
)

engine.dispose()