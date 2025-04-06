from endpointsCarAPI.GetTrimsId import get_filtered_trims_df
from endpointsCarAPI.GetEngines import get_engines_by_trim_ids
from endpointsCarAPI.GetBodies import get_bodies_by_trim_ids
from endpointsCarAPI.GetMileages import get_mileages_by_trim_ids
from endpointsCarAPI.GetTrims import get_trims_and_models
from endpointsCarAPI.GetYears import get_filtered_years_df
from endpointsCarAPI.GetMakes import get_specific_makes_df
from endpointsCarAPI.GetModels import get_specific_models_df
from database.table_create import generate_create_table
import os

def generate_schema_file():
    """
    Genera el archivo schema.sql con la estructura de la base de datos.
    """
    print("Generando schema.sql...")
    
    # Obtener datos necesarios para generar las tablas
    trims_df = get_filtered_trims_df()
    trims, make_models = get_trims_and_models(trims_df["id"].tolist())
    
    # Generar definiciones de tablas
    years = generate_create_table(get_filtered_years_df(), "years", primary_key="year")
    makes = generate_create_table(get_specific_makes_df(), "makes", primary_key="id")
    models = generate_create_table(get_specific_models_df(), "models", primary_key="name")
    engines = generate_create_table(get_engines_by_trim_ids(trims_df["id"].tolist()), "engines", primary_key="id")
    bodies = generate_create_table(get_bodies_by_trim_ids(trims_df["id"].tolist()), "bodies", primary_key="id")
    mileages = generate_create_table(get_mileages_by_trim_ids(trims_df["id"].tolist()), "mileages", primary_key="id")
    make_models = generate_create_table(make_models, "make_models", primary_key="id", 
                                      foreign_keys={"make_id": ("makes", "id"), 
                                                  "name": ("models", "name")})
    trims = generate_create_table(trims, "trims", primary_key="id", 
                                foreign_keys={"year_id": ("years", "year"), 
                                            "engine_id": ("engines", "id"),
                                            "body_id": ("bodies", "id"), 
                                            "make_model_id": ("make_models", "id"), 
                                            "mileage_id": ("mileages", "id")})
    
    # Generar el archivo schema.sql
    schema_path = os.path.join(os.path.dirname(__file__), 'schema.sql')
    with open(schema_path, 'w') as f:
        f.write("\n\n".join([years, makes, models, engines, bodies, mileages, make_models, trims]))
    
    print(f"✅ Schema generado correctamente en {schema_path}")

if __name__ == "__main__":
    generate_schema_file() 