import os
import boto3
import json
import pymysql
from tabulate import tabulate

def get_db_credentials():
    """
    Obtiene las credenciales de la base de datos desde AWS Secrets Manager.
    """
    try:
        session = boto3.session.Session()
        client = session.client('secretsmanager')
        
        # Obtener el secreto
        response = client.get_secret_value(
            SecretId='car-wizard-db-credentials'
        )
        
        if 'SecretString' in response:
            secret = json.loads(response['SecretString'])
            return {
                'host': secret['host'],
                'username': secret['username'],
                'password': secret['password'],
                'database': secret['database']
            }
    except Exception as e:
        print(f"❌ Error al obtener credenciales: {str(e)}")
        return None

def show_tables():
    """
    Muestra las tablas y su contenido.
    """
    credentials = get_db_credentials()
    if not credentials:
        print("❌ No se pudieron obtener las credenciales")
        return

    try:
        # Conectar a la base de datos
        conn = pymysql.connect(
            host=credentials['host'],
            user=credentials['username'],
            password=credentials['password'],
            database=credentials['database']
        )
        
        with conn.cursor() as cursor:
            # Obtener lista de tablas
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            
            if not tables:
                print("⚠️ No se encontraron tablas en la base de datos")
                return
            
            print("\n📊 Tablas encontradas:")
            for table in tables:
                table_name = table[0]
                print(f"\n📋 Tabla: {table_name}")
                
                # Obtener estructura de la tabla
                cursor.execute(f"DESCRIBE {table_name}")
                structure = cursor.fetchall()
                print("\nEstructura:")
                headers = ["Campo", "Tipo", "Nulo", "Llave", "Default", "Extra"]
                print(tabulate(structure, headers=headers, tablefmt="grid"))
                
                # Obtener contenido de la tabla
                cursor.execute(f"SELECT * FROM {table_name} LIMIT 5")
                content = cursor.fetchall()
                if content:
                    print("\nContenido (primeros 5 registros):")
                    cursor.execute(f"SHOW COLUMNS FROM {table_name}")
                    columns = [column[0] for column in cursor.fetchall()]
                    print(tabulate(content, headers=columns, tablefmt="grid"))
                else:
                    print("\nLa tabla está vacía")
                
                print("\n" + "="*50)
                
    except Exception as e:
        print(f"❌ Error al conectar o consultar la base de datos: {str(e)}")
    finally:
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    show_tables() 