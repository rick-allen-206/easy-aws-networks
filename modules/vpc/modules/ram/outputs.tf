output "ram_arn" {
  description = "ARN of the RAM share"
  value       = aws_ram_resource_share.this.arn
}