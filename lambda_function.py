import requests
import json
import pandas as pd
import boto3
import os
import logging
import time
from datetime import datetime

# Configurar logging
logger = logging.getLogger()
log_level = os.environ.get('LOG_LEVEL', 'INFO')
logger.setLevel(log_level)

# Configuración de la API
API_BASE_URL = "https://carapi.app/api"
JWT_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJhcGkuYXBwIiwic3ViIjoiOTU1YjYwNzQtMzBhYS00YjgyLWI2NmMtNzg5ODEzMjdiZjk2IiwiYXVkIjoiOTU1YjYwNzQtMzBhYS00YjgyLWI2NmMtNzg5ODEzMjdiZjk2IiwiZXhwIjoxNzQzODE2OTI4LCJpYXQiOjE3NDMyMTIxMjgsImp0aSI6IjljMDZkZDIxLTY1ZmYtNDIzOS04MzUzLTMzMzM1YjA2ZTgyMCIsInVzZXIiOnsic3Vic2NyaXB0aW9ucyI6W10sInJhdGVfbGltaXRfdHlwZSI6ImhhcmQiLCJhZGRvbnMiOnsiYW50aXF1ZV92ZWhpY2xlcyI6ZmFsc2UsImRhdGFfZmVlZCI6ZmFsc2V9fX0.cIaXzZhINodUXWXcJ-OS_LGeVZF6CXx0pgSn8wMLw0o"

# Encabezados de autenticación
HEADERS = {
    "Authorization": f"Bearer {JWT_TOKEN}",
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# Conexión a RDS MySQL (si se desea persistir los datos)
def get_db_connection():
    try:
        import pymysql
        
        rds_endpoint = os.environ.get('RDS_ENDPOINT')
        db_name = os.environ.get('RDS_DATABASE')
        username = os.environ.get('RDS_USERNAME')
        password = os.environ.get('RDS_PASSWORD')
        
        if not all([rds_endpoint, db_name, username, password]):
            logger.warning("Faltan parámetros de conexión a la base de datos")
            return None
        
        # Extraer hostname y puerto del endpoint
        host, port_str = rds_endpoint.split(':')
        port = int(port_str)
        
        conn = pymysql.connect(
            host=host,
            port=port,
            user=username,
            passwd=password,
            db=db_name
        )
        
        return conn
    except Exception as e:
        logger.error(f"Error al conectar a la base de datos: {str(e)}")
        return None

# Función para obtener años
def obtener_anios():
    url = f"{API_BASE_URL}/years"
    # Crear el filtro para años entre 2015 y 2020
    filtro = [
        {"field": "year", "op": ">=", "val": 2015},
        {"field": "year", "op": "<=", "val": 2020}
    ]
    params = {
        "json": json.dumps(filtro)
    }
    
    logger.info("Obteniendo años de vehículos")
    response = requests.get(url, headers=HEADERS, params=params)
    
    if response.status_code == 200:
        return response.json()
    else:
        logger.error(f"Error {response.status_code} al obtener años: {response.text}")
        return []

# Función para obtener marcas
def obtener_makes():
    url = f"{API_BASE_URL}/makes"
    # Crear el filtro para años entre 2015 y 2020
    filtro = [
        {"field": "year", "op": ">=", "val": 2015},
        {"field": "year", "op": "<=", "val": 2020}
    ]
    params = {
        "json": json.dumps(filtro)
    }
    
    logger.info("Obteniendo marcas de vehículos")
    response = requests.get(url, headers=HEADERS, params=params)
    
    if response.status_code == 200:
        return response.json()
    else:
        logger.error(f"Error {response.status_code} al obtener marcas: {response.text}")
        return {}

# Función para obtener modelos por año específico
def obtener_models_por_anio(anio):
    url = f"{API_BASE_URL}/models"
    params = {
        "year": anio
    }
    
    logger.info(f"Obteniendo modelos para el año {anio}")
    response = requests.get(url, headers=HEADERS, params=params)
    
    if response.status_code == 200:
        return response.json()
    else:
        logger.error(f"Error {response.status_code} al obtener modelos para {anio}: {response.text}")
        return {}

# Función para obtener engines por año específico
def obtener_engines_por_anio(anio):
    url = f"{API_BASE_URL}/engines"
    params = {
        "year": anio
    }
    
    logger.info(f"Obteniendo motores para el año {anio}")
    response = requests.get(url, headers=HEADERS, params=params)
    
    if response.status_code == 200:
        return response.json()
    else:
        logger.error(f"Error {response.status_code} al obtener motores para {anio}: {response.text}")
        return {}

# Función para obtener trims
def obtener_trims():
    url = f"{API_BASE_URL}/trims"
    # Crear el filtro para años entre 2015 y 2020
    filtro = [
        {"field": "year", "op": ">=", "val": 2015},
        {"field": "year", "op": "<=", "val": 2020}
    ]
    params = {
        "verbose": "yes",
        "json": json.dumps(filtro)
    }
    
    logger.info("Obteniendo trims de vehículos")
    response = requests.get(url, headers=HEADERS, params=params)
    
    if response.status_code == 200:
        return response.json()
    else:
        logger.error(f"Error {response.status_code} al obtener trims: {response.text}")
        return {}

# Guardar DataFrames en S3 (alternativa a RDS)
def guardar_en_s3(df, nombre_archivo):
    try:
        s3 = boto3.client('s3')
        fecha = datetime.now().strftime('%Y%m%d')
        bucket_name = 'car-wizard-data'  # Debes crear este bucket previamente
        
        # Guardar como CSV
        csv_buffer = df.to_csv(index=False).encode()
        s3_key = f'data/{fecha}/{nombre_archivo}.csv'
        s3.put_object(Bucket=bucket_name, Key=s3_key, Body=csv_buffer)
        
        logger.info(f"Datos guardados en S3: s3://{bucket_name}/{s3_key}")
        return True
    except Exception as e:
        logger.error(f"Error al guardar en S3: {str(e)}")
        return False

# Función Lambda principal
def lambda_handler(event, context):
    start_time = time.time()
    logger.info("Iniciando el proceso de obtención de datos de vehículos")
    
    try:
        # Obtener años
        anios_vehiculos = obtener_anios()
        df_years = pd.DataFrame({"Años Vehículos": pd.Series(anios_vehiculos, dtype=object)})
        logger.info(f"Años obtenidos: {len(df_years)}")
        
        # Obtener marcas
        marcas = obtener_makes()
        marcas_data = marcas.get("data", [])
        df_makes = pd.DataFrame(marcas_data, columns=["id", "name"])
        logger.info(f"Marcas obtenidas: {len(df_makes)}")
        
        # Obtener modelos
        modelos_totales = []
        for anio in range(2015, 2021):
            modelos_anio = obtener_models_por_anio(anio)
            if modelos_anio:
                modelos_totales.extend(modelos_anio.get("data", []))
                
        # Filtrar modelos 
        modelos_filtrados = [modelo for modelo in modelos_totales if modelo.get("name") and "subscription required" not in modelo["name"]]
        df_models = pd.DataFrame(modelos_filtrados, columns=["id", "name"])
        logger.info(f"Modelos obtenidos: {len(df_models)}")
        
        # Obtener motores
        engines_totales = []
        for anio in range(2015, 2021):
            engines_anio = obtener_engines_por_anio(anio)
            if engines_anio:
                engines_totales.extend(engines_anio.get("data", []))
                
        # Crear DataFrame de motores
        columnas_engines = [
            "id", "make_model_trim_id", "engine_type", "fuel_type", 
            "cylinders", "size", "horsepower_hp", "horsepower_rpm", 
            "torque_ft_lbs", "torque_rpm", "valves", "valve_timing", 
            "cam_type", "drive_type", "transmission"
        ]
        df_engines = pd.DataFrame(engines_totales, columns=columnas_engines)
        logger.info(f"Motores obtenidos: {len(df_engines)}")
        
        # Obtener trims
        trims_data = obtener_trims()
        trims_procesados = []
        
        if "data" in trims_data:
            for trim in trims_data["data"]:
                make_name = trim.get("make_model", {}).get("make", {}).get("name", "")
                model_name = trim.get("make_model", {}).get("name", "")
                
                trim_info = {
                    "id": trim.get("id"),
                    "year": trim.get("year"),
                    "trim_name": trim.get("name"),
                    "description": trim.get("description"),
                    "msrp": trim.get("msrp"),
                    "invoice": trim.get("invoice"),
                    "make": make_name,
                    "model": model_name,
                    "make_model_id": trim.get("make_model_id")
                }
                trims_procesados.append(trim_info)
                
        df_trims = pd.DataFrame(trims_procesados)
        logger.info(f"Trims obtenidos: {len(df_trims)}")
        
        # Guardar datos en S3
        guardar_en_s3(df_makes, "marcas")
        guardar_en_s3(df_models, "modelos")
        guardar_en_s3(df_engines, "motores")
        guardar_en_s3(df_trims, "trims")
        
        # Generar estadísticas
        tiempo_total = time.time() - start_time
        stats = {
            "tiempo_ejecucion": f"{tiempo_total:.2f} segundos",
            "total_marcas": len(df_makes),
            "total_modelos": len(df_models),
            "total_motores": len(df_engines),
            "total_trims": len(df_trims),
            "fecha_ejecucion": datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        }
        
        logger.info(f"Resumen de datos obtenidos: {json.dumps(stats)}")
        
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Datos de vehículos obtenidos correctamente",
                "stats": stats
            })
        }
        
    except Exception as e:
        logger.error(f"Error en el proceso de obtención de datos: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Error en el proceso de obtención de datos",
                "error": str(e)
            })
        }