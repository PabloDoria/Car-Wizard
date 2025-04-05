import os
import sys
import json
import pandas as pd

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from Client import CarAPIClient

def get_mileages_by_trim_ids(trim_ids: list) -> pd.DataFrame:
    if not trim_ids:
        return pd.DataFrame()  # si la lista está vacía, no hacemos la consulta

    filtro = json.dumps([
        {"field": "make", "op": "in", "val": ["Honda", "Toyota", "Volkswagen", "Hyundai", "Nissan", "Kia"]},
        {"field": "year", "op": "in", "val": [2015, 2016]},
        {"field": "make_model_trim_id", "op": "in", "val": trim_ids}
    ])
    
    params = {
        "json": filtro,
        "limit": 1000,
    }

    client = CarAPIClient()
    response = client.get("mileages", params=params)

    df = pd.DataFrame(response.get("data", []))

    df.drop(columns=["make_model_trim_id"], inplace=True)

    # Convertir galones a litros (fuel_tank_capacity)
    df['fuel_tank_capacity'] = df['fuel_tank_capacity'].astype(float) * 3.78541
    # Renombrar columnas de consumo de combustible

    # Convertir MPG a L/100km
    df['combined_mpg'] = 235.215 / df['combined_mpg'].astype(float)
    df['epa_city_mpg'] = 235.215 / df['epa_city_mpg'].astype(float)  
    df['epa_highway_mpg'] = 235.215 / df['epa_highway_mpg'].astype(float)

    df = df.rename(columns={
        'combined_mpg': 'combined_LitersAt100km',
        'epa_city_mpg': 'city_LitersAt100km',
        'epa_highway_mpg': 'highway_LitersAt100km'
    })

    # Convertir millas a kilómetros (rangos)
    df['range_city'] = df['range_city'].astype(float) * 1.60934
    df['range_highway'] = df['range_highway'].astype(float) * 1.60934
    
    # Convertir rango eléctrico de millas a km si existe
    if 'range_electric' in df.columns:
        df.loc[df['range_electric'].notna(), 'range_electric'] = df['range_electric'] * 1.60934

    return df
