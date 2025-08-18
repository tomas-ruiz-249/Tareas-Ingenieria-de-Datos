import pandas as pd
import sqlite3
from pathlib import Path

FILE_PATH = 'data.csv'
OUTPUT_DB = 'data.db'
TABLE_NAME = 'viajes'

#pd.set_option('display.max_rows', None)
#pd.set_option('display.max_columns', None)

def main():
    #extract
    print('Extrayendo datos')
    df = pd.read_csv(FILE_PATH, usecols=range(10))
    print(df.head())

    #transform
    print('Transformando datos')
    df.drop(columns=['route_id', 'bus_number', 'driver_name', 'delay_duration', 'weather_condition', 'fare_amount'], inplace=True)

    df['departure_time'] = pd.to_datetime(df['departure_time'], errors='coerce', format='%I:%M %p')
    df['arrival_time'] = pd.to_datetime(df['arrival_time'], errors='coerce', format='%I:%M %p')

    time_boundary = pd.to_datetime("12:00 PM", errors='coerce', format='%I:%M %p')

    df.drop(df[df.departure_time >= time_boundary].index, inplace=True)
    df.drop(df[df.departure_time >= df.arrival_time].index, inplace=True)

    print(df.head())

    #load
    print('Cargando datos')
    connection = sqlite3.connect(OUTPUT_DB)
    df.to_sql(TABLE_NAME, connection, if_exists='replace', index=False)
    connection.close()

    conn = sqlite3.connect(OUTPUT_DB)
    preview = pd.read_sql(f"SELECT * FROM {TABLE_NAME} LIMIT 10", conn)
    print(preview)
    conn.close()
    print("=== ETL: fin ===")



if __name__ == "__main__":
    main()
