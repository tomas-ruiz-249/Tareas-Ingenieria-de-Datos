import pandas as pd
import sqlite3
from pathlib import Path

FILE_PATH = 'data.csv'
OUTPUT_DB = 'data.db'

TABLE_NAME = 'ventas'


def main():
    #extract
    print('Extrayendo datos')
    df = pd.read_csv(FILE_PATH, usecols=range(10))
    print(df.head())

    #transform
    print('Transformando datos')
    df.drop(columns=['route_id', 'bus_number', 'driver_name', 'delay_duration', 'weather_condition'], inplace=True)

    df['departure_time'] = pd.to_datetime(df['departure_time'], errors='coerce', format='%H:%M %p')
    df['arrival_time'] = pd.to_datetime(df['arrival_time'], errors='coerce', format='%H:%M %p')
    print(df.head())

    #load
    print('Cargando datos')

if __name__ == "__main__":
    main()