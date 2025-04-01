# Comandos para importar los usuarios existentes:
#
# terraform import 'aws_iam_user.team_members["anad"]' car-wizard-anad
# terraform import 'aws_iam_user.team_members["angelg"]' car-wizard-angelg
# terraform import 'aws_iam_user.team_members["luism"]' car-wizard-luism
#
# Ejecutar estos comandos antes de terraform apply

# También necesitarás importar las políticas y grupos asociados si existen:
#
# terraform import aws_iam_group.viewers car-wizard-viewers
# terraform import aws_iam_group_membership.team team
# terraform import aws_iam_policy.view_access CarWizardViewAccess 