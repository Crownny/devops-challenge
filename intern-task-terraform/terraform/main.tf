locals {
  # The real files from the intern-task-app task, embedded so the instance
  # builds exactly the image that task builds.
  dockerfile_b64 = base64encode(file("${path.module}/../../intern-task-app/Dockerfile"))
  app_py_b64     = base64encode(file("${path.module}/../../intern-task-app/app/app.py"))

  user_data = templatefile("${path.module}/user_data.yaml.tftpl", {
    admin_user       = var.admin_user
    ssh_public_key   = var.ssh_public_key
    ssh_allowed_cidr = var.ssh_allowed_cidr
    app_port         = var.app_port
    dockerfile_b64   = local.dockerfile_b64
    app_py_b64       = local.app_py_b64
  })
}

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  user_data                   = local.user_data
  user_data_replace_on_change = false

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = { Name = "intern-task-app" }

  lifecycle {
    # cloud-init only runs user_data at first boot, so editing it later
    # cannot change a running instance. Ignoring it keeps unrelated
    # changes from touching the instance because of user_data.
    ignore_changes = [user_data]
  }
}
