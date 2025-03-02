data "aws_ecr_repository" "ecr_repo" {
  name = "car-wizard"
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "car-wizard"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}