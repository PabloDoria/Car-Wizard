#!/bin/bash
# Script para preparar el despliegue - generar archivos necesarios para Lambda

set -e  # Salir inmediatamente si algún comando falla

echo "🔧 Preparando entorno para desplegar..."

# 1. Crear directorio para Lambda si no existe
mkdir -p terraform/tmp

# 2. Crear archivo Python de Lambda simple
echo "Creando archivo Lambda..."
cat > terraform/tmp/lambda_function.py << 'EOF'
import json

def lambda_handler(event, context):
    """
    Función Lambda simple para el proyecto Car Wizard
    """
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Car Wizard Lambda!')
    }
EOF

# 3. Crear archivo ZIP para Lambda
echo "Creando archivo ZIP..."
cd terraform/tmp
zip ../lambda_function.zip lambda_function.py
cd ../..

# 4. Limpiar archivos temporales
echo "Limpiando archivos temporales..."
rm -rf terraform/tmp

echo "✅ Entorno preparado correctamente. Ahora puedes ejecutar el deploy."
echo "Archivos generados:"
echo "- terraform/lambda_function.zip" 