resource "aws_security_group" "security_groups" {
  for_each = var.security_groups_config

  name        = each.key
  description = each.value.description
  vpc_id      = aws_vpc.b2111933_vpc.id
}

locals {
  sg_ingress = flatten([
    for sg_name, sg in var.security_groups_config : [
      for rule in sg.ingress : {
        sg_name     = sg_name
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_blocks = rule.cidr_blocks
      }
    ]
  ])

  sg_egress = flatten([
    for sg_name, sg in var.security_groups_config : [
      for rule in sg.egress : {
        sg_name     = sg_name
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_blocks = rule.cidr_blocks
      }
    ]
  ])
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each = { for idx, rule in local.sg_ingress : "${rule.sg_name}-ingress-${idx}" => rule }

  type              = "ingress"
  security_group_id = aws_security_group.security_groups[each.value.sg_name].id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "egress_rules" {
  for_each = { for idx, rule in local.sg_egress : "${rule.sg_name}-egress-${idx}" => rule }

  type              = "egress"
  security_group_id = aws_security_group.security_groups[each.value.sg_name].id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "sg_icmp" {
  for_each                 = toset(["sg_linux", "sg_windows"])
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.security_groups[each.value].id
  source_security_group_id = aws_security_group.security_groups[each.value].id
}
