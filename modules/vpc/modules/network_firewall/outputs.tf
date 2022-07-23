output "firewall_attachment_ids" {
  description = "A list of firewall attachment IDs"
  value       = [for i in aws_networkfirewall_firewall.this.firewall_status[0].sync_states : merge(i.attachment[0], { availability_zone = i.availability_zone })]
}
