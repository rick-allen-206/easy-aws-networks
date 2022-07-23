resource "aws_ram_resource_share" "this" {
  name                      = var.ram_name
  allow_external_principals = var.allow_external_principals

  tags = var.tags
}

resource "aws_ram_resource_association" "this" {
  count              = length(var.resource_arns)
  resource_arn       = var.resource_arns[count.index]
  resource_share_arn = aws_ram_resource_share.this.arn
}
