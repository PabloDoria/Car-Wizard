resource "aws_ecr_repository" "ecr_repo" {
    name = "car-wizard"
    image_tag_mutability = "MUTABLE"
    force_delete = true

    lifecycle {
        ignore_changes = [name]
    }
}