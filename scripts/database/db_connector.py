import boto3
import json
import pymysql
import os

def get_db_credentials():
    """
    Obtiene las credenciales de la base de datos desde AWS Secrets Manager.
    
    Returns:
        dict: Diccionario con las credenciales de la base de datos
    """
    session = boto3.session.Session()
    client = session.client('secretsmanager')
    
    try:
        secret = client.get_secret_value(SecretId='car-wizard/db-credentials')
        credentials = json.loads(secret['SecretString'])
        return credentials
    except Exception as e:
        print(f"Error obteniendo credenciales: {e}")
        return None

def get_db_connection():
    """
    Establece una conexión a la base de datos usando las credenciales de AWS Secrets Manager.
    
    Returns:
        pymysql.Connection: Objeto de conexión a la base de datos
    """
    credentials = get_db_credentials()
    
    if not credentials:
        raise Exception("No se pudieron obtener las credenciales de la base de datos")
    
    try:
        conn = pymysql.connect(
            host=credentials['host'],
            port=credentials['port'],
            user=credentials['username'],
            password=credentials['password'],
            database=credentials['database']
        )
        return conn
    except Exception as e:
        print(f"Error conectando a la base de datos: {e}")
        return None

# Ejemplo de uso
if __name__ == "__main__":
    conn = get_db_connection()
    if conn:
        print("✅ Conexión a la base de datos establecida correctamente")
        conn.close()
    else:
        print("❌ No se pudo establecer la conexión a la base de datos") 