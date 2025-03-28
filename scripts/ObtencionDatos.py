import requests
import json

# Configuración de la API
API_URL = "https://carapi.app/api/models"  # Endpoint para obtener modelos
JWT_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJhcGkuYXBwIiwic3ViIjoiOTU1YjYwNzQtMzBhYS00YjgyLWI2NmMtNzg5ODEzMjdiZjk2IiwiYXVkIjoiOTU1YjYwNzQtMzBhYS00YjgyLWI2NmMtNzg5ODEzMjdiZjk2IiwiZXhwIjoxNzQzMDMzMTk0LCJpYXQiOjE3NDI0MjgzOTQsImp0aSI6IjZlNTg4MGY5LWNkODEtNDFjYS1iOThiLTUwODNjNTYxNGY5MSIsInVzZXIiOnsic3Vic2NyaXB0aW9ucyI6W10sInJhdGVfbGltaXRfdHlwZSI6ImhhcmQiLCJhZGRvbnMiOnsiYW50aXF1ZV92ZWhpY2xlcyI6ZmFsc2UsImRhdGFfZmVlZCI6ZmFsc2V9fX0.sapy7YK303WHFz4l4B9lsN_O5xNu1hcAOeh_EX5z5eQ"  # Reemplaza con tu JWT Token válido

# Encabezados de autenticación
headers = {
    "Authorization": f"Bearer {JWT_TOKEN}",
    "Content-Type": "application/json"
}

# Parámetros de la consulta
params = {
    "make": "Honda",
    "year": 2015,  # Especifica el año si es necesario
    "verbose": "yes"  # Incluye información detallada de la marca
}

# Realizar la solicitud GET a CarAPI
response = requests.get(API_URL, headers=headers, params=params)

# Verificar el estado de la respuesta
if response.status_code == 200:
    data = response.json()
    print(json.dumps(data, indent=4))  # Imprimir la respuesta en formato JSON legible
else:
    print(f"Error {response.status_code}: {response.text}")
