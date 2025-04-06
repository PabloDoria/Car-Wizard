import os

def generate_schema(tables):
    """
    Genera un archivo SQL con la creación de la base de datos y las tablas.
    
    Args:
        tables (list): Lista de cadenas con los CREATE TABLE
    """
    # Obtener la ruta absoluta del directorio actual
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Crear el directorio database si no existe
    os.makedirs(current_dir, exist_ok=True)
    
    # Contenido del archivo SQL
    sql_content = """-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS CarWizardDB;

-- Usar la base de datos
USE CarWizardDB;

"""
    
    # Agregar cada CREATE TABLE
    for table in tables:
        sql_content += f"\n{table}\n"
    
    # Ruta completa del archivo schema.sql
    schema_path = os.path.join(current_dir, 'schema.sql')
    
    # Escribir el archivo
    with open(schema_path, 'w') as f:
        f.write(sql_content)
    
    print(f"✅ Archivo schema.sql generado exitosamente en: {schema_path}")

# Ejemplo de uso
if __name__ == "__main__":
    # Ejemplo de tablas (reemplazar con tus tablas reales)
    tables = [
        """CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)""",
        """CREATE TABLE IF NOT EXISTS cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)"""
    ]
    
    generate_schema(tables)