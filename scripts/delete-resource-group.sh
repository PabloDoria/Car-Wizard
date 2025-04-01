#!/bin/bash
# Script para eliminar manualmente el Resource Group car-wizard-resources
# Ejecutar con: bash delete-resource-group.sh

set -e  # Salir inmediatamente si un comando falla

RESOURCE_GROUP_NAME="car-wizard-resources"
echo "🧹 Eliminando Resource Group '$RESOURCE_GROUP_NAME'..."

# 1. Encontrar el ARN del Resource Group
echo "Buscando Resource Group por nombre..."
RESOURCE_GROUP_ARN=$(aws resource-groups list-groups --query "GroupIdentifiers[?Name=='$RESOURCE_GROUP_NAME'].GroupArn" --output text)

if [ -z "$RESOURCE_GROUP_ARN" ] || [ "$RESOURCE_GROUP_ARN" == "None" ]; then
  echo "✅ Resource Group '$RESOURCE_GROUP_NAME' no encontrado o ya eliminado."
  exit 0
fi

echo "Resource Group encontrado: $RESOURCE_GROUP_ARN"

# 2. Intentar eliminar el Resource Group con --force
echo "Método 1: Intentando eliminar Resource Group con --force..."
aws resource-groups delete-group --group-name "$RESOURCE_GROUP_NAME" --force || true

# 3. Verificar si se eliminó
echo "Verificando si el Resource Group fue eliminado..."
sleep 5
RESOURCE_GROUP_STILL_EXISTS=$(aws resource-groups list-groups --query "GroupIdentifiers[?Name=='$RESOURCE_GROUP_NAME'].GroupArn" --output text)

if [ -z "$RESOURCE_GROUP_STILL_EXISTS" ] || [ "$RESOURCE_GROUP_STILL_EXISTS" == "None" ]; then
  echo "✅ Resource Group eliminado exitosamente con el método 1."
  exit 0
fi

# 4. Método alternativo: eliminar etiquetas y luego el grupo
echo "Método 2: Intentando eliminar etiquetas del grupo..."
aws resource-groups-tagging api untag-resources --resource-arn-list "$RESOURCE_GROUP_ARN" --tag-keys "Application" "Project" "Environment" "ManagedBy" || true

echo "Intentando eliminar el grupo nuevamente..."
aws resource-groups delete-group --group-name "$RESOURCE_GROUP_NAME" --force || true

# 5. Último método: usar AWS CLI directo con formato diferente
echo "Método 3: Intentando método alternativo con AWS CLI..."
aws resource-groups delete-group --group="$RESOURCE_GROUP_NAME" --force || true

# 6. Verificación final
for i in {1..3}; do
  echo "Verificación $i de 3: Comprobando si el Resource Group aún existe..."
  FINAL_CHECK=$(aws resource-groups list-groups --query "GroupIdentifiers[?Name=='$RESOURCE_GROUP_NAME'].GroupArn" --output text)
  
  if [ -z "$FINAL_CHECK" ] || [ "$FINAL_CHECK" == "None" ]; then
    echo "✅ Resource Group eliminado con éxito"
    exit 0
  else
    echo "⚠️ El Resource Group aún existe, reintentando eliminación (intento $i)..."
    aws resource-groups delete-group --group-name "$RESOURCE_GROUP_NAME" --force || true
    echo "Esperando 10 segundos..."
    sleep 10
  fi
done

# 7. Si llegamos aquí, no se pudo eliminar
echo "❌ No se pudo eliminar el Resource Group '$RESOURCE_GROUP_NAME' automáticamente."
echo "Por favor, intenta eliminarlo manualmente desde la consola AWS:"
echo "1. Ve a https://console.aws.amazon.com/resource-groups/"
echo "2. Selecciona '$RESOURCE_GROUP_NAME'"
echo "3. Haz clic en 'Actions > Delete'" 