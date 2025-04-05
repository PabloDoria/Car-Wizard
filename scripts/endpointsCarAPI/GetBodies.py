import os
import sys
import json
import pandas as pd

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from Client import CarAPIClient

def get_bodies_by_trim_ids(trim_ids: list) -> pd.DataFrame:
    if not trim_ids:
        return pd.DataFrame()  # Retorna vacío si la lista está vacía

    filtro = json.dumps([
        {"field": "make", "op": "in", "val": ["Honda", "Toyota", "Volkswagen", "Hyundai", "Nissan", "Kia"]},
        {"field": "make_model_trim_id", "op": "in", "val": trim_ids}
    ])

    params = {
        "json": filtro,
        "limit": 1000  
    }


    client = CarAPIClient()
    response = client.get("bodies", params=params)

    df = pd.DataFrame(response.get("data", []))
    df.drop_duplicates(subset=['id'], inplace=True)

    # Eliminar make_model_trim_id si no quieres esa columna en el resultado final
    if "make_model_trim_id" in df.columns:
        df.drop(columns=['make_model_trim_id'], inplace=True)

    # Medidas de peso imperial a metrico
    df['length'] = df['length'].astype(float) * 2.54
    df['width'] = df['width'].astype(float) * 2.54
    df['height'] = df['height'].astype(float) * 2.54
    df['wheel_base'] = df['wheel_base'].astype(float) * 2.54
    df['ground_clearance'] = df['ground_clearance'].astype(float) * 2.54

    # Medidas de volumen imperial a metrico
    df['cargo_capacity'] = df['cargo_capacity'].astype(float) * 28.3168
    df['max_cargo_capacity'] = df['max_cargo_capacity'].astype(float) * 28.3168

    # Medidas de peso imperial a metrico
    df['curb_weight'] = df['curb_weight'].astype(float) * 0.453592
    df['gross_weight'] = df['gross_weight'].astype(float) * 0.453592
    df['max_payload'] = df['max_payload'].astype(float) * 0.453592
    df['max_towing_capacity'] = df['max_towing_capacity'].astype(float) * 0.453592

    return df
