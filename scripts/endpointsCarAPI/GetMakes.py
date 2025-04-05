import os
import sys
import json
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pandas as pd
from Client import CarAPIClient

def get_specific_makes_df():
    client = CarAPIClient()
    marcas = ["Honda", "Toyota", "Volkswagen", "Hyundai", "Nissan", "Kia"]

    resultados = []

    for marca in marcas:
        for year in [2015]:
            params = {"make": marca, "year": year}
            response = client.get("makes", params=params)
            resultados.extend(response["data"])

    df=  pd.DataFrame(resultados)

    df.drop_duplicates(subset=['id'], inplace=True)

    return df