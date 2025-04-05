import os
import sys
import json
import pandas as pd

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from Client import CarAPIClient

def get_trims_and_models(trim_ids: list) -> tuple[pd.DataFrame, pd.DataFrame]:
    client = CarAPIClient()

    all_trims = []
    make_model_entries = []

    for trim_id in trim_ids:
        try:
            response = client.get(f"trims/{trim_id}")
        except Exception as e:
            print(f"Error al consultar trim_id {trim_id}: {e}")
            continue

        # Eliminar campos de colores que no nos interesan
        response.pop("make_model_trim_interior_colors", None)
        response.pop("make_model_trim_exterior_colors", None)

        # Extraer y guardar los IDs internos
        engine = response.get("make_model_trim_engine", {})
        body = response.get("make_model_trim_body", {})
        mileage = response.get("make_model_trim_mileage", {})

        response["engine_id"] = engine.get("id")
        response["body_id"] = body.get("id")
        response["mileage_id"] = mileage.get("id")

        # Extraer y guardar make_model como entrada separada
        make_model = response.get("make_model", {})
        if make_model:
            make_model_entries.append(make_model)

        # Guardar el resto del trim (sin make_model para evitar nesting)
        response.pop("make_model", None)
        response.pop("make_model_trim_engine", None)
        response.pop("make_model_trim_body", None)
        response.pop("make_model_trim_mileage", None)

        all_trims.append(response)

    df_trims = pd.DataFrame(all_trims)
    df_trims.drop(columns=['invoice', 'created', 'modified'], inplace=True)
    df_make_models = pd.DataFrame(make_model_entries).drop_duplicates(subset=["id"])
    df_make_models.drop(columns=['make'], inplace=True)

    return df_trims, df_make_models
