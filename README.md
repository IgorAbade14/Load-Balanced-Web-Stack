# 🌐 Load Balanced Web Stack com Terraform & AWS 

Este projeto demonstra a criação de uma infraestrutura de alta disponibilidade na AWS utilizando Terraform. Ele estabelece uma rede completa (VPC) e um par de instâncias EC2 rodando servidores web Apache, balanceados por um Application Load Balancer (ALB).

## 🏗️ Arquitetura do Projeto

A infraestrutura foi desenhada seguindo boas práticas de segregação, segurança e resiliência:

### VPC Customizada
Rede isolada com bloco CIDR `10.0.0.0/16`.

### Subnets Públicas
Duas subnets em zonas de disponibilidade diferentes (`us-east-1a` e `us-east-1b`) para garantir alta disponibilidade.

### Internet Gateway & Route Tables
Configuração de roteamento permitindo acesso externo à rede.

### Application Load Balancer (ALB)
Atua como ponto de entrada, distribuindo as requisições entre os servidores.

### Security Groups (Segurança)
- **LB-SG**: Permite tráfego HTTP (porta 80) de qualquer origem.  
- **App-SG**: Permite tráfego apenas vindo do Load Balancer (regra em cascata).

## 🚀 Tecnologias Utilizadas

- Terraform — Infraestrutura como Código (IaC)  
- AWS — EC2, VPC, ALB, Internet Gateway  
- Bash (User Data) — Automação de setup (Apache + deploy HTML/CSS)  
- GitHub Actions — Pipeline de CI/CD para automação do deploy  

## 📄 Como visualizar o projeto

Após executar o `terraform apply`, será gerado um DNS do Load Balancer.

Ao acessar esse endereço no navegador, o tráfego será distribuído entre:

- 🔵 Servidor Primário (Azul)  
- 🟢 Servidor Secundário (Verde)  

Isso demonstra na prática:

- Balanceamento de carga funcionando  
- Alta disponibilidade da aplicação  

## 🛠️ Como Executar

```bash
#1. Clone o repositório
git clone https://github.com/seu-usuario/load-balanced-web-stack.git
cd load-balanced-web-stack

#2. Configure suas credenciais AWS
export AWS_ACCESS_KEY_ID="sua_key"
export AWS_SECRET_ACCESS_KEY="seu_secret"

#3. Inicialize e aplique a infraestrutura
terraform init
terraform plan
terraform apply

```

## 👨‍💻 Desenvolvido por:

https://github.com/IgorAbade14  
https://www.linkedin.com/in/igorabade14/
