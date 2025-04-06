import boto3
import json
import pymysql
import os
from botocore.exceptions import ClientError

def get_db_credentials():
    """
    Obtiene las credenciales de la base de datos desde AWS Secrets Manager.
    """
    secret_name = os.getenv('DB_SECRET_ARN')
    if not secret_name:
        raise ValueError("No se encontró la variable de entorno DB_SECRET_ARN")

    region_name = os.getenv('AWS_REGION', 'us-east-1')
    
    try:
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=region_name
        )
        
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
        
        if 'SecretString' in get_secret_value_response:
            secret = json.loads(get_secret_value_response['SecretString'])
            return {
                'host': secret['host'],
                'port': int(secret['port']),
                'username': secret['username'],
                'password': secret['password'],
                'database': secret['dbname']
            }
    except ClientError as e:
        error_code = e.response['Error']['Code']
        if error_code == 'ResourceNotFoundException':
            raise Exception(f"El secret {secret_name} no existe en Secrets Manager")
        elif error_code == 'AccessDeniedException':
            raise Exception("No hay permisos para acceder al secret")
        else:
            raise Exception(f"Error al obtener el secret: {str(e)}")
    except Exception as e:
        raise Exception(f"Error inesperado al obtener credenciales: {str(e)}")

def get_db_connection():
    """
    Establece una conexión con la base de datos usando las credenciales obtenidas.
    """
    try:
        credentials = get_db_credentials()
        connection = pymysql.connect(
            host=credentials['host'],
            port=credentials['port'],
            user=credentials['username'],
            password=credentials['password'],
            database=credentials['database'],
            cursorclass=pymysql.cursors.DictCursor
        )
        return connection
    except Exception as e:
        raise Exception(f"Error al conectar con la base de datos: {str(e)}")

if __name__ == "__main__":
    try:
        conn = get_db_connection()
        print("✅ Conexión exitosa a la base de datos")
        conn.close()
    except Exception as e:
        print(f"❌ Error: {str(e)}") 