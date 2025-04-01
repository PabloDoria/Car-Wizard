#!/bin/bash
# Script simple para eliminar el Resource Group desde AWS Cloud Shell
# Para ejecutar: 
# 1. Copia todo este script
# 2. Ve a AWS CloudShell (https://console.aws.amazon.com/cloudshell/)
# 3. Pega el script completo y presiona Enter

GROUP_NAME="car-wizard-resources"

echo "Intentando eliminar el Resource Group: $GROUP_NAME"

# 1. Listar el grupo para confirmar que existe
echo "Verificando si el grupo existe..."
aws resource-groups list-groups --query "GroupIdentifiers[?Name=='$GROUP_NAME'].GroupArn" --output text

# 2. Obtener ARN del grupo
GROUP_ARN=$(aws resource-groups list-groups --query "GroupIdentifiers[?Name=='$GROUP_NAME'].GroupArn" --output text)

if [ -z "$GROUP_ARN" ] || [ "$GROUP_ARN" == "None" ]; then
  echo "El Resource Group no existe o ya fue eliminado."
  exit 0
fi

echo "Resource Group encontrado: $GROUP_ARN"

# 3. Eliminar el grupo
echo "Eliminando el Resource Group..."
aws resource-groups delete-group --group-name "$GROUP_NAME" --force

# 4. Verificar eliminación
echo "Verificando si se eliminó..."
sleep 5

VERIFY=$(aws resource-groups list-groups --query "GroupIdentifiers[?Name=='$GROUP_NAME'].GroupArn" --output text)
if [ -z "$VERIFY" ] || [ "$VERIFY" == "None" ]; then
  echo "✅ El Resource Group fue eliminado correctamente."
else
  echo "❌ No se pudo eliminar el Resource Group."
  echo "Intentando un método alternativo..."
  aws resource-groups delete-group --group="$GROUP_NAME" --force
fi

# 5. Listar todos los grupos restantes
echo "Resource Groups restantes:"
aws resource-groups list-groups 