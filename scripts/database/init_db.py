import os
import time
import pymysql
from db_connector import get_db_credentials

def wait_for_db(max_retries=30, delay=10):
    """
    Espera a que la base de datos esté disponible.
    
    Args:
        max_retries (int): Número máximo de intentos
        delay (int): Segundos de espera entre intentos
    """
    credentials = get_db_credentials()
    if not credentials:
        raise Exception("No se pudieron obtener las credenciales de la base de datos")
    
    for i in range(max_retries):
        try:
            conn = pymysql.connect(
                host=credentials['host'],
                port=credentials['port'],
                user=credentials['username'],
                password=credentials['password']
            )
            conn.close()
            print("✅ Base de datos disponible")
            return True
        except Exception as e:
            print(f"Intento {i+1}/{max_retries}: Base de datos no disponible - {str(e)}")
            time.sleep(delay)
    
    raise Exception("La base de datos no está disponible después de varios intentos")

def init_database():
    """
    Inicializa la base de datos con el esquema.
    """
    # Esperar a que la base de datos esté disponible
    wait_for_db()
    
    # Obtener credenciales
    credentials = get_db_credentials()
    
    # Leer el archivo schema.sql
    current_dir = os.path.dirname(os.path.abspath(__file__))
    schema_path = os.path.join(current_dir, 'schema.sql')
    
    with open(schema_path, 'r') as f:
        schema_sql = f.read()
    
    # Ejecutar el esquema
    try:
        conn = pymysql.connect(
            host=credentials['host'],
            port=credentials['port'],
            user=credentials['username'],
            password=credentials['password']
        )
        
        with conn.cursor() as cursor:
            # Dividir el SQL en comandos individuales
            commands = schema_sql.split(';')
            
            for command in commands:
                if command.strip():
                    cursor.execute(command)
            
            conn.commit()
            print("✅ Esquema de base de datos aplicado correctamente")
            
    except Exception as e:
        print(f"❌ Error al inicializar la base de datos: {str(e)}")
        raise
    finally:
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    init_database() 