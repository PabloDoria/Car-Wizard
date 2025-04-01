import json
import os
import sys
import logging
import boto3
import importlib.util
import shutil
from datetime import datetime

# Configurar logging
logger = logging.getLogger()
log_level = os.environ.get('LOG_LEVEL', 'INFO')
logger.setLevel(log_level)

def lambda_handler(event, context):
    start_time = datetime.now()
    logger.info("Iniciando ejecución de ObtencionDatos.py")
    
    try:
        # Preparar directorio temporal para la ejecución
        temp_dir = '/tmp/scripts'
        os.makedirs(temp_dir, exist_ok=True)
        
        # Copiar el script original al directorio temporal
        s3 = boto3.client('s3')
        bucket_name = os.environ.get('S3_CODE_BUCKET', 'car-wizard-code')
        script_key = 'scripts/ObtencionDatos.py'
        
        local_script_path = os.path.join(temp_dir, 'ObtencionDatos.py')
        
        try:
            # Intentar descargar el script desde S3
            logger.info(f"Descargando script desde s3://{bucket_name}/{script_key}")
            s3.download_file(bucket_name, script_key, local_script_path)
            logger.info(f"Script descargado correctamente en {local_script_path}")
        except Exception as e:
            # Si falla la descarga desde S3, buscar el script en el paquete de Lambda
            logger.warning(f"No se pudo descargar desde S3: {str(e)}")
            logger.info("Buscando script en el paquete Lambda...")
            
            try:
                # Intentar usar el script incluido en el paquete Lambda
                embedded_script = '/var/task/scripts/ObtencionDatos.py'
                if os.path.exists(embedded_script):
                    shutil.copy(embedded_script, local_script_path)
                    logger.info(f"Script copiado desde el paquete Lambda a {local_script_path}")
                else:
                    raise FileNotFoundError(f"Script no encontrado en {embedded_script}")
            except Exception as embedded_error:
                logger.error(f"Error al copiar script desde el paquete: {str(embedded_error)}")
                raise
        
        # Cargar el módulo usando importlib
        logger.info("Importando script ObtencionDatos.py")
        spec = importlib.util.spec_from_file_location("ObtencionDatos", local_script_path)
        obtencion_datos = importlib.util.module_from_spec(spec)
        
        # Añadir el directorio temporal al path para importaciones
        sys.path.append(temp_dir)
        
        # Ejecutar el script (esto ejecutará el código en el nivel global)
        logger.info("Ejecutando script ObtencionDatos.py")
        spec.loader.exec_module(obtencion_datos)
        
        # Capturar la salida del DataFrame
        df_summary = {}
        if hasattr(obtencion_datos, 'df_makes'):
            df_summary['marcas'] = len(obtencion_datos.df_makes)
        if hasattr(obtencion_datos, 'df_models'):
            df_summary['modelos'] = len(obtencion_datos.df_models)
        if hasattr(obtencion_datos, 'df_engines'):
            df_summary['motores'] = len(obtencion_datos.df_engines)
        if hasattr(obtencion_datos, 'df_trims'):
            df_summary['trims'] = len(obtencion_datos.df_trims)
        if hasattr(obtencion_datos, 'df_make_models'):
            df_summary['make_models'] = len(obtencion_datos.df_make_models)
        
        # Opcional: guardar los DataFrames en S3
        s3_data_bucket = os.environ.get('S3_DATA_BUCKET', 'car-wizard-data')
        fecha = datetime.now().strftime('%Y%m%d')
        
        try:
            # Guardar dataframes en S3 si existen
            if hasattr(obtencion_datos, 'df_makes'):
                csv_buffer = obtencion_datos.df_makes.to_csv(index=False).encode()
                s3_key = f'data/{fecha}/marcas.csv'
                s3.put_object(Bucket=s3_data_bucket, Key=s3_key, Body=csv_buffer)
                logger.info(f"Datos de marcas guardados en s3://{s3_data_bucket}/{s3_key}")
            
            if hasattr(obtencion_datos, 'df_trims'):
                csv_buffer = obtencion_datos.df_trims.to_csv(index=False).encode()
                s3_key = f'data/{fecha}/trims.csv'
                s3.put_object(Bucket=s3_data_bucket, Key=s3_key, Body=csv_buffer)
                logger.info(f"Datos de trims guardados en s3://{s3_data_bucket}/{s3_key}")
            
            # Puedes añadir más dataframes aquí
        except Exception as s3_error:
            logger.warning(f"Error al guardar DataFrames en S3: {str(s3_error)}")
        
        # Calcular tiempo de ejecución
        end_time = datetime.now()
        execution_time = (end_time - start_time).total_seconds()
        
        # Resultado exitoso
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Script ObtencionDatos.py ejecutado correctamente',
                'execution_time_seconds': execution_time,
                'dataframes_summary': df_summary,
                'timestamp': end_time.strftime('%Y-%m-%d %H:%M:%S')
            })
        }
        
    except Exception as e:
        logger.error(f"Error al ejecutar ObtencionDatos.py: {str(e)}")
        import traceback
        logger.error(traceback.format_exc())
        
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error al ejecutar ObtencionDatos.py',
                'error': str(e),
                'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            })
        }