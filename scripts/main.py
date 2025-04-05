from endpointsCarAPI.GetTrimsId import get_filtered_trims_df
from endpointsCarAPI.GetEngines import get_engines_by_trim_ids
from endpointsCarAPI.GetBodies import get_bodies_by_trim_ids
from endpointsCarAPI.GetMileages import get_mileages_by_trim_ids
from endpointsCarAPI.GetTrims import get_trims_and_models
from DBCreator import generate_create_table
from endpointsCarAPI.GetYears import get_filtered_years_df
from endpointsCarAPI.GetMakes import get_specific_makes_df
from endpointsCarAPI.GetModels import get_specific_models_df

def main():
    # Paso 1: obtener los trims filtrados
    trims_df = get_filtered_trims_df()

    df1, df2 = get_trims_and_models(trims_df["id"].tolist())

    create_table_sql = generate_create_table(df1, "Trims", primary_key="id")
    print(create_table_sql)

    create_table_sql = generate_create_table(df2, "Make_Models", primary_key="id")
    print(create_table_sql)

if __name__ == "__main__":
    main()
