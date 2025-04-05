import os
import sys
import json
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pandas as pd
from Client import CarAPIClient

def get_specific_models_df():
    client = CarAPIClient()
    marcas = ["Honda", "Toyota", "Volkswagen", "Hyundai", "Nissan", "Kia"]

    resultados = []

    for marca in marcas:
        for year in [2015,2016]:
            params = {"make": marca, "year": year}
            response = client.get("models", params=params)
            resultados.extend(response["data"])

    df = pd.DataFrame(resultados).drop(['id', 'make_id'], axis=1)

    df.drop_duplicates(subset=['name'], inplace=True)

    return df