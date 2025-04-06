from endpointsCarAPI.GetTrimsId import get_filtered_trims_df
from endpointsCarAPI.GetEngines import get_engines_by_trim_ids
from endpointsCarAPI.GetBodies import get_bodies_by_trim_ids
from endpointsCarAPI.GetMileages import get_mileages_by_trim_ids
from endpointsCarAPI.GetTrims import get_trims_and_models
from endpointsCarAPI.GetYears import get_filtered_years_df
from endpointsCarAPI.GetMakes import get_specific_makes_df
from endpointsCarAPI.GetModels import get_specific_models_df
import os
import json
from datetime import datetime
from database.db_connector import get_db_credentials, get_db_connection

def check_schema_exists():
    """
    Verifica si el schema existe y las tablas están creadas.
    """
    try:
        conn = get_db_connection()
        with conn.cursor() as cursor:
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            required_tables = {'years', 'makes', 'models', 'engines', 'bodies', 'mileages', 'make_models', 'trims'}
            existing_tables = {table['Tables_in_carwizarddb'] for table in tables}
            
            if not required_tables.issubset(existing_tables):
                missing_tables = required_tables - existing_tables
                raise Exception(f"Faltan las siguientes tablas: {missing_tables}")
                
            return True
    except Exception as e:
        print(f"Error al verificar el schema: {str(e)}")
        return False
    finally:
        if 'conn' in locals():
            conn.close()

def lambda_handler(event, context):
    """
    Manejador principal de la función Lambda para cargar datos en la base de datos.
    """
    try:
        # Verificar que el schema existe
        if not check_schema_exists():
            raise Exception("El schema no está inicializado. Por favor, ejecute primero el generador de schema.")
            
        # Obtener credenciales de la base de datos
        credentials = get_db_credentials()
        if not credentials:
            raise Exception("No se pudieron obtener las credenciales de la base de datos")
            
        # Obtener datos de la API
        print("Obteniendo datos de la API...")
        trims_df = get_filtered_trims_df()
        trims, make_models = get_trims_and_models(trims_df["id"].tolist())
        
        # Obtener datos adicionales
        years_df = get_filtered_years_df()
        makes_df = get_specific_makes_df()
        models_df = get_specific_models_df()
        engines_df = get_engines_by_trim_ids(trims_df["id"].tolist())
        bodies_df = get_bodies_by_trim_ids(trims_df["id"].tolist())
        mileages_df = get_mileages_by_trim_ids(trims_df["id"].tolist())
        
        # Conectar a la base de datos
        conn = get_db_connection()
        cursor = conn.cursor()
        
        try:
            # Insertar datos en las tablas
            print("Insertando datos en la base de datos...")
            
            # Insertar años
            for _, row in years_df.iterrows():
                cursor.execute("INSERT IGNORE INTO years (year) VALUES (%s)", (row['year'],))
            
            # Insertar marcas
            for _, row in makes_df.iterrows():
                cursor.execute("INSERT IGNORE INTO makes (id, name) VALUES (%s, %s)", 
                             (row['id'], row['name']))
            
            # Insertar modelos
            for _, row in models_df.iterrows():
                cursor.execute("INSERT IGNORE INTO models (name) VALUES (%s)", (row['name'],))
            
            # Insertar motores
            for _, row in engines_df.iterrows():
                cursor.execute("""
                    INSERT IGNORE INTO engines 
                    (id, make_model_trim_id, engine_type, fuel_type, cylinders, size, 
                     horsepower_hp, horsepower_rpm, torque_ft_lbs, torque_rpm, valves, 
                     valve_timing, cam_type, drive_type, transmission)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (
                    row['id'], row['make_model_trim_id'], row['engine_type'], 
                    row['fuel_type'], row['cylinders'], row['size'],
                    row['horsepower_hp'], row['horsepower_rpm'], row['torque_ft_lbs'],
                    row['torque_rpm'], row['valves'], row['valve_timing'],
                    row['cam_type'], row['drive_type'], row['transmission']
                ))
            
            # Insertar carrocerías
            for _, row in bodies_df.iterrows():
                cursor.execute("INSERT IGNORE INTO bodies (id, name) VALUES (%s, %s)", 
                             (row['id'], row['name']))
            
            # Insertar kilometrajes
            for _, row in mileages_df.iterrows():
                cursor.execute("INSERT IGNORE INTO mileages (id, name) VALUES (%s, %s)", 
                             (row['id'], row['name']))
            
            # Insertar make_models
            for _, row in make_models.iterrows():
                cursor.execute("""
                    INSERT IGNORE INTO make_models 
                    (id, make_id, name) VALUES (%s, %s, %s)
                """, (row['id'], row['make_id'], row['name']))
            
            # Insertar trims
            for _, row in trims.iterrows():
                cursor.execute("""
                    INSERT IGNORE INTO trims 
                    (id, year_id, engine_id, body_id, make_model_id, mileage_id, 
                     name, description, msrp, invoice)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (
                    row['id'], row['year_id'], row['engine_id'], row['body_id'],
                    row['make_model_id'], row['mileage_id'], row['name'],
                    row['description'], row['msrp'], row['invoice']
                ))
            
            # Confirmar transacciones
            conn.commit()
            print("✅ Datos insertados correctamente")
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Datos procesados y almacenados correctamente',
                    'timestamp': datetime.now().isoformat()
                })
            }
            
        except Exception as e:
            conn.rollback()
            raise Exception(f"Error al insertar datos: {str(e)}")
            
        finally:
            cursor.close()
            conn.close()
            
    except Exception as e:
        print(f"Error en la ejecución: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            })
        }

if __name__ == "__main__":
    lambda_handler(None, None)
