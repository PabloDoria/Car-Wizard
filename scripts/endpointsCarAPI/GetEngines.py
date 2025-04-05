import os
import sys
import json
import pandas as pd

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from Client import CarAPIClient

def get_engines_by_trim_ids(trim_ids: list) -> pd.DataFrame:
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
    response = client.get("engines", params=params)

    df =pd.DataFrame(response.get("data", []))

    df.drop(columns=["make_model_trim_id"], inplace=True)

    return df
