import os
import sys
import json
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pandas as pd
from Client import CarAPIClient

def get_filtered_years_df():
    # Filtro de marcas y años
    filtro = json.dumps([
        {"field": "make", "op": "in", "val": ["Honda", "Toyota", "Volkswagen", "Hyundai", "Nissan", "Kia"]},
        {"field": "year", "op": "in", "val": [2015, 2016]}
    ])
    params = {"json": filtro}
    
    client = CarAPIClient()
    data = client.get("years", params=params)
    return pd.DataFrame(data, columns=["year"])