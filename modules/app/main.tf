# 1. O Recurso do Load Balancer
resource "aws_lb" "web_stack_lb" {
  name               = "lb-web-stack-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  
  # CORREÇÃO: O ALB precisa de DUAS subnets em zonas diferentes para alta disponibilidade
  # Aqui passamos a lista com os IDs que vêm lá do seu módulo de network
  subnets            = [var.subnet_a_id, var.subnet_b_id]
  
  # Aqui você usa o Security Group que criou para o LB
  security_groups    = [var.lb_sg_id]

  tags = {
    Name    = "lb-web-stack-${var.environment}"
    Project = "Load-Balanced-Web-Stack"
  }
}

# 2. O Target Group (A lista de destino)
resource "aws_lb_target_group" "web_tg" {
  name     = "tg-web-stack-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id # Precisa receber o ID da VPC para saber onde os alvos estão

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}


resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_stack_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_instance" "server_1" {
  ami           = var.ami_ubuntu
  instance_type = "t3.micro"
  subnet_id     = var.subnet_a_id
  vpc_security_group_ids = [var.app_sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              cat <<HTML > /var/www/html/index.html
              <!DOCTYPE html>
                <html lang="pt-br">
                  <head>
                    <meta charset="UTF-8">
                    <title>Web Stack - Abade</title>
                    <style>
                      body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
                      .card { background: white; padding: 2rem; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); text-align: center; border-top: 10px solid #007bff; }
                      h1 { color: #333; }
                      .badge { background-color: #007bff; color: white; padding: 5px 15px; border-radius: 20px; font-weight: bold; }
                      .footer { margin-top: 20px; font-size: 0.8rem; color: #777; }
                    </style>
                  </head>
                  <body>
                    <div class="card">
                      <h1>DevOps Lab - AWS</h1>
                      <p>Você está conectado ao:</p>
                      <div class="badge">SERVIDOR PRIMÁRIO</div>
                      <p id="time"></p>
                    <div class="footer">Projeto: Load Balanced Web Stack | Dev: Abade</div>
                    </div>
                    <script>
                    document.getElementById('time').innerText = "Acesso em: " + new Date().toLocaleString();
                    </script>
                  </body>
                </html>
              HTML
              EOF           

  tags = { Name = "web-server-1" }
}

resource "aws_instance" "server_2" {
  ami           = var.ami_ubuntu
  instance_type = "t3.micro"
  subnet_id     = var.subnet_b_id
  vpc_security_group_ids = [var.app_sg_id]
  associate_public_ip_address = true

  # O CORAÇÃO DO NEGÓCIO:

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              cat <<HTML> /var/www/html/index.html
              <!DOCTYPE html>
                <html lang="pt-br">
                  <head>
                    <meta charset="UTF-8">
                    <title>Web Stack - Abade</title>
                    <style>
                      body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
                      .card { background: white; padding: 2rem; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); text-align: center; border-top: 10px solid #007bff; }
                      h1 { color: #333; }
                      .badge { background-color: #28a745; color: white; padding: 5px 15px; border-radius: 20px; font-weight: bold; }
                      .footer { margin-top: 20px; font-size: 0.8rem; color: #777; }
                    </style>
                  </head>
                  <body>
                    <div class="card">
                      <h1>DevOps Lab - AWS</h1>
                      <p>Você está conectado ao:</p>
                      <div class="badge">SERVIDOR SECUNDÁRIO</div>
                      <p id="time"></p>
                    <div class="footer">Projeto: Load Balanced Web Stack | Dev: Abade</div>
                    </div>
                    <script>
                    document.getElementById('time').innerText = "Acesso em: " + new Date().toLocaleString();
                    </script>
                  </body>
                </html>
              HTML
              EOF

  tags = { Name = "web-server-2" }
}

resource "aws_lb_target_group_attachment" "attach_server_1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_server_2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.server_2.id
  port             = 80
}