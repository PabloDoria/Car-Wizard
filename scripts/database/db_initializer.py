import os
import json
import time
from datetime import datetime
from db_connector import get_db_connection

def wait_for_rds(max_retries=30, delay=10):
    """
    Espera a que RDS esté disponible.
    """
    print("Esperando a que RDS esté disponible...")
    for attempt in range(max_retries):
        try:
            conn = get_db_connection()
            conn.close()
            print("✅ RDS está disponible")
            return True
        except Exception as e:
            if attempt < max_retries - 1:
                print(f"Intento {attempt + 1}/{max_retries}: RDS no está disponible. Esperando {delay} segundos...")
                time.sleep(delay)
            else:
                print(f"❌ Error: RDS no está disponible después de {max_retries} intentos")
                raise Exception(f"No se pudo conectar a RDS: {str(e)}")

def initialize_database():
    """
    Inicializa la base de datos usando el schema.sql generado.
    """
    schema_path = os.path.join(os.path.dirname(__file__), 'schema.sql')
    
    if not os.path.exists(schema_path):
        raise Exception("No se encontró el archivo schema.sql. Por favor, ejecute primero el generador de schema.")
    
    print("Inicializando la base de datos...")
    conn = get_db_connection()
    
    try:
        with conn.cursor() as cursor:
            # Leer y ejecutar el schema.sql
            with open(schema_path, 'r') as f:
                schema_sql = f.read()
                
            # Dividir el schema en comandos individuales
            commands = schema_sql.split(';')
            
            # Ejecutar cada comando
            for command in commands:
                if command.strip():
                    cursor.execute(command)
            
            conn.commit()
            print("✅ Base de datos inicializada correctamente")
            
    except Exception as e:
        conn.rollback()
        raise Exception(f"Error al inicializar la base de datos: {str(e)}")
        
    finally:
        conn.close()

def lambda_handler(event, context):
    """
    Manejador de la función Lambda para inicializar la base de datos.
    """
    try:
        # Esperar a que RDS esté disponible
        wait_for_rds()
        
        # Inicializar la base de datos
        initialize_database()
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Base de datos inicializada correctamente',
                'timestamp': datetime.now().isoformat()
            })
        }
        
    except Exception as e:
        print(f"Error en la inicialización de la base de datos: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            })
        }

if __name__ == "__main__":
    lambda_handler(None, None) 