import requests
import json
import pandas as pd

# Configuración de la API
API_BASE_URL = "https://carapi.app/api"
JWT_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJhcGkuYXBwIiwic3ViIjoiOTU1YjYwNzQtMzBhYS00YjgyLWI2NmMtNzg5ODEzMjdiZjk2IiwiYXVkIjoiOTU1YjYwNzQtMzBhYS00YjgyLWI2NmMtNzg5ODEzMjdiZjk2IiwiZXhwIjoxNzQzODE2OTI4LCJpYXQiOjE3NDMyMTIxMjgsImp0aSI6IjljMDZkZDIxLTY1ZmYtNDIzOS04MzUzLTMzMzM1YjA2ZTgyMCIsInVzZXIiOnsic3Vic2NyaXB0aW9ucyI6W10sInJhdGVfbGltaXRfdHlwZSI6ImhhcmQiLCJhZGRvbnMiOnsiYW50aXF1ZV92ZWhpY2xlcyI6ZmFsc2UsImRhdGFfZmVlZCI6ZmFsc2V9fX0.cIaXzZhINodUXWXcJ-OS_LGeVZF6CXx0pgSn8wMLw0o"  # Reemplaza con tu JWT Token válido

# Encabezados de autenticación
headersInsanos = {
    "Authorization": f"Bearer {JWT_TOKEN}",
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# Función para realizar la solicitud GET
def obtener_anios(tipo):
    url = f"{API_BASE_URL}{tipo}"
    # Crear el filtro para años entre 2015 y 2020
    filtro = [
        {"field": "year", "op": ">=", "val": 2015},
        {"field": "year", "op": "<=", "val": 2020}
    ]
    params = {
        "json": json.dumps(filtro)
    }
    response = requests.get(url, headers=headersInsanos, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error {response.status_code}: {response.text}")
        return []

# Obtener años de vehículos ligeros y motocicletas
anios_vehiculos_ligeros = obtener_anios("/years")

# Crear DataFrame con los resultados
df = pd.DataFrame({
    "Años Vehículos Ligeros": pd.Series(anios_vehiculos_ligeros, dtype=object),
})

# Mostrar el DataFrame
print(df.head())

#---------------------------------------------------------------------------------------------------------------#

# Función para obtener marcas (makes)
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
    response = requests.get(url, headers=headersInsanos, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error {response.status_code}: {response.text}")
        return []

# Obtener marcas de vehículos
marcas = obtener_makes()

# Verificar la estructura de la respuesta para ver cómo se organizan los datos
# Mostramos los primeros elementos de la clave 'data' para verificar la estructura
if "data" in marcas:
    marcas_data = marcas["data"]  # Extrae las marcas de la clave 'data'
else:
    marcas_data = []

# Crear DataFrame con las marcas
df_makes = pd.DataFrame(marcas_data, columns=["id", "name"])

# Mostrar el DataFrame
print(df_makes.head())

#---------------------------------------------------------------------------------------------------------------#

# Función para obtener modelos por año específico
def obtener_models_por_anio(anio):
    url = f"{API_BASE_URL}/models"
    params = {
        "year": anio  # Filtrar por un solo año
    }
    response = requests.get(url, headers=headersInsanos, params=params)
    if response.status_code == 200:
        return response.json()  # Devuelve los datos como un diccionario
    else:
        print(f"Error {response.status_code}: {response.text}")
        return {}

# Obtener modelos de vehículos entre 2015 y 2020
modelos_totales = []
for anio in range(2015, 2021):  # Del 2015 al 2020
    modelos_anio = obtener_models_por_anio(anio)
    if modelos_anio:
        modelos_totales.extend(modelos_anio.get("data", []))  # Agregar los modelos de ese año

# Filtrar modelos que no tienen la restricción de suscripción
modelos_filtrados = [modelo for modelo in modelos_totales if "subscription required" not in modelo["name"]]

# Crear DataFrame con los modelos disponibles
df_models = pd.DataFrame(modelos_filtrados, columns=["id", "name"])

# Mostrar el DataFrame
print(df_models.head())

#---------------------------------------------------------------------------------------------------------------#

# Función para obtener los motores por año específico
def obtener_engines_por_anio(anio):
    url = f"{API_BASE_URL}/engines"
    params = {
        "year": anio  # Filtrar por un solo año
    }
    print(f"Obteniendo datos para el año {anio}...")
    response = requests.get(url, headers=headersInsanos, params=params)

    # Imprimir la respuesta para ver si se están obteniendo datos
    print(f"Status code: {response.status_code}")
    print(f"Response text: {response.text[:200]}")  # Solo los primeros 200 caracteres

    if response.status_code == 200:
        return response.json()  # Devuelve los datos como un diccionario
    else:
        print(f"Error {response.status_code}: {response.text}")
        return {}

# Obtener motores de vehículos entre 2015 y 2020
engines_totales = []
for anio in range(2015, 2021):  # Del 2015 al 2020
    engines_anio = obtener_engines_por_anio(anio)
    if engines_anio:
        engines_totales.extend(engines_anio.get("data", []))  # Agregar los motores de ese año

# Si no se obtuvieron motores, imprime el error
if not engines_totales:
    print("No se obtuvieron motores en el rango de años especificado.")

# Crear DataFrame con los motores disponibles
df_engines = pd.DataFrame(engines_totales, columns=["id", "make_model_trim_id", "engine_type", "fuel_type", "cylinders", "size", "horsepower_hp", "horsepower_rpm", "torque_ft_lbs", "torque_rpm", "valves", "valve_timing", "cam_type", "drive_type", "transmission"])

# Mostrar el DataFrame
print(df_engines.head())

#---------------------------------------------------------------------------------------------------------------#

# Función para obtener el millaje por año específico
def obtener_millas_por_anio(anio):
    url = f"{API_BASE_URL}/mileages"
    params = {
        "year": anio  # Filtrar por un solo año
    }
    print(f"Obteniendo datos para el año {anio}...")
    response = requests.get(url, headers=headersInsanos, params=params)

    # Imprimir la respuesta para ver si se están obteniendo datos
    print(f"Status code: {response.status_code}")
    print(f"Response text: {response.text[:200]}")  # Solo los primeros 200 caracteres

    if response.status_code == 200:
        return response.json()  # Devuelve los datos como un diccionario
    else:
        print(f"Error {response.status_code}: {response.text}")
        return {}

# Obtener motores de vehículos entre 2015 y 2020
millaje_totales = []
for anio in range(2015, 2021):  # Del 2015 al 2020
    millaje_anio = obtener_millas_por_anio(anio)
    if engines_anio:
        millaje_totales.extend(millaje_anio.get("data", []))  # Agregar los motores de ese año

# Si no se obtuvieron motores, imprime el error
if not millaje_totales:
    print("No se obtuvieron motores en el rango de años especificado.")

# Crear DataFrame con los motores disponibles
df_millaje = pd.DataFrame(millaje_totales, columns=["id", "make_model_trim_id", "fuel_tank_capacity", "combined_mpg", "epa_city_mpg", "epa_highway_mpg", "range_city", "range_highway", "battery_capacity_electric", "epa_time_to_charge_hr_240v_electric", "epa_kwh_100_mi_electric", "range_electric", "epa_highway_mpg_electric", "epa_city_mpg_electric", "epa_combined_mpg_electric"])

# Mostrar el DataFrame
print(df_millaje.head())

#---------------------------------------------------------------------------------------------------------------#


def obtener_vehicles_attributes_por_anio(anio):
    atributos = [
        "bodies.type", "engines.cam_type", "engines.cylinders",
        "engines.drive_type", "engines.engine_type", "engines.fuel_type",
        "engines.transmission", "engines.valve_timing", "engines.valves"
    ]

    resultados = {}

    for atributo in atributos:
        url = f"{API_BASE_URL}/vehicle-attributes"
        params = {"attribute": atributo}

        response = requests.get(url, headers=headersInsanos, params=params)

        print(f"Consultando {atributo} para el año {anio} - Status: {response.status_code}")

        if response.status_code == 200:
            resultados[atributo] = response.json()  # Guarda los resultados por atributo
        else:
            print(f"Error en {atributo}: {response.text}")

    return resultados

# Obtener atributos de vehículos entre 2015 y 2020
vehicles_attributes_totales = []
for anio in range(2015, 2021):  # Del 2015 al 2020
    vehicles_attributes_anio = obtener_vehicles_attributes_por_anio(anio)
    if vehicles_attributes_anio:
        vehicles_attributes_totales.append({"year": anio, "attributes": vehicles_attributes_anio})

# Si no se obtuvieron datos, imprime el error
if not vehicles_attributes_totales:
    print("No se obtuvieron atributos de vehículos en el rango de años especificado.")

# Convertir datos en un DataFrame estructurado
vehicles_attributes_list = []
for entry in vehicles_attributes_totales:
    year = entry["year"]
    attributes = entry["attributes"]
    for attr, values in attributes.items():
        for value in values:
            vehicles_attributes_list.append({"year": year, "attribute": attr, "value": value})

# Crear DataFrame
columns = ["year", "attribute", "value"]
df_vehicles_attributes = pd.DataFrame(vehicles_attributes_list, columns=columns)

# Mostrar el DataFrame
print(df_vehicles_attributes.head())

#---------------------------------------------------------------------------------------------------------------#

# Función para obtener los trims con información detallada
def obtener_trims():
    url = f"{API_BASE_URL}/trims"
    # Crear el filtro para años entre 2015 y 2020
    filtro = [
        {"field": "year", "op": ">=", "val": 2015},
        {"field": "year", "op": "<=", "val": 2020}
    ]
    params = {
        "verbose": "yes",  # Para obtener información detallada
        "json": json.dumps(filtro)
    }
    print("Obteniendo datos de trims...")
    response = requests.get(url, headers=headersInsanos, params=params)
    
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error {response.status_code}: {response.text}")
        return []

# Obtener los trims
trims_data = obtener_trims()

# Procesar los datos para el DataFrame
trims_procesados = []
if "data" in trims_data:
    for trim in trims_data["data"]:
        # Extraer información del make_model si existe
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

# Crear DataFrame con los trims
df_trims = pd.DataFrame(trims_procesados)

# Mostrar el DataFrame
print("\nMuestra de los trims obtenidos:")
print(df_trims.head())

# Mostrar estadísticas básicas
print("\nEstadísticas de precios MSRP:")
print(df_trims["msrp"].describe())

# Función para obtener los make_model únicos a partir de los trims
def obtener_make_models():
    url = f"{API_BASE_URL}/trims"
    make_models_unicos = {}  # Usamos un diccionario para mantener los modelos únicos
    make_models_data = []
    page = 1
    
    while True:
        # Crear el filtro para años entre 2015 y 2020
        filtro = [
            {"field": "year", "op": ">=", "val": 2015},
            {"field": "year", "op": "<=", "val": 2020}
        ]
        params = {
            "verbose": "yes",  # Para obtener información detallada
            "json": json.dumps(filtro),
            "page": page,
            "per_page": 100  # Máximo permitido por la API
        }
        print(f"Obteniendo página {page} de trims...")
        response = requests.get(url, headers=headersInsanos, params=params)
        
        if response.status_code != 200:
            print(f"Error {response.status_code}: {response.text}")
            break

        data = response.json()
        if "data" not in data or not data["data"]:
            break

        for trim in data["data"]:
            if "make_model" in trim:
                make_model = trim["make_model"]
                model_name = make_model["name"]
                
                # Si el modelo no está en nuestro diccionario, lo agregamos
                if model_name not in make_models_unicos:
                    make_models_unicos[model_name] = {
                        "make_model_id": make_model["id"],
                        "make_id": make_model["make_id"],
                        "model_name": model_name,
                        "make_name": make_model["make"]["name"] if "make" in make_model else None
                    }

        # Verificar si hay más páginas
        if "meta" in data and page >= data["meta"]["last_page"]:
            break
            
        page += 1

    # Convertir el diccionario de modelos únicos a lista
    make_models_data = list(make_models_unicos.values())

    # Crear DataFrame con los make_models únicos
    df_make_models = pd.DataFrame(make_models_data)
    
    # Ordenar por make_name y model_name para mejor visualización
    df_make_models = df_make_models.sort_values(["make_name", "model_name"])
    
    print("\nMuestra de los make_models únicos obtenidos:")
    print(df_make_models.head())
    
    print("\nEstadísticas:")
    print(f"Total de make_models únicos: {len(df_make_models)}")
    print("\nCantidad de modelos por marca:")
    print(df_make_models.groupby("make_name").size().sort_values(ascending=False).head(10))
    
    return df_make_models

# Obtener los make_models únicos
df_make_models = obtener_make_models()