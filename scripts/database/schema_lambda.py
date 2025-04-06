import os
import json
import time
from datetime import datetime
import generate_schema
from db_connector import get_db_connection

def wait_for_rds(max_retries=30, delay=10):
    """
    Espera a que RDS esté disponible.
    
    Args:
        max_retries (int): Número máximo de intentos
        delay (int): Segundos de espera entre intentos
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

def check_schema_exists():
    """
    Verifica si el schema.sql ya existe y si la base de datos ya está inicializada.
    """
    schema_path = os.path.join(os.path.dirname(__file__), 'schema.sql')
    
    # Verificar si el archivo existe
    if not os.path.exists(schema_path):
        return False
        
    # Verificar si la base de datos ya está inicializada
    try:
        conn = get_db_connection()
        with conn.cursor() as cursor:
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            return len(tables) > 0
    except Exception as e:
        print(f"Error al verificar la base de datos: {str(e)}")
        return False
    finally:
        if 'conn' in locals():
            conn.close()

def lambda_handler(event, context):
    """
    Manejador de la función Lambda para generar el schema de la base de datos.
    """
    try:
        # Esperar a que RDS esté disponible
        wait_for_rds()
        
        if check_schema_exists():
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'El schema ya existe y la base de datos está inicializada',
                    'timestamp': datetime.now().isoformat()
                })
            }
            
        print("Generando schema.sql...")
        generate_schema()
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Schema generado correctamente',
                'timestamp': datetime.now().isoformat()
            })
        }
        
    except Exception as e:
        print(f"Error en la generación del schema: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            })
        }

if __name__ == "__main__":
    lambda_handler(None, None) 