import os
import sys
import json
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pandas as pd
from Client import CarAPIClient

def get_filtered_trims_df():
    # Configurar el filtro
    filtro = json.dumps([
        {"field": "make", "op": "in", "val": ["Honda", "Toyota", "Volkswagen", "Hyundai", "Nissan", "Kia"]},
        {"field": "year", "op": "in", "val": [2015, 2016]}
    ])

    client = CarAPIClient()

    # Consultar hasta 3 páginas de 1000 resultados
    all_data = []
    for page in range(1, 3):  # Páginas 1, 2 y 3
        params = {
            "json": filtro,
            "limit": 1000,
            "page": page
        }
        response = client.get("trims", params=params)
        data = response.get("data", [])
        all_data.extend(data)

    # Crear el DataFrame
    df = pd.DataFrame(all_data)

    # Filtrar: quedarnos con la versión más cara (msrp más alto) por make_model_id y year
    df = df.sort_values("msrp", ascending=False)
    df = df.drop_duplicates(subset=["make_model_id", "year"], keep="first")
    df.drop(columns=['make_model_id', 'year', 'name', 'description', 'msrp', 'invoice', 'created', 'modified'], inplace=True)

    return df
