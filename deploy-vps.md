# 🚀 Deploy na VPS - Guia Completo

## 📋 Método 1: GitHub (Recomendado)

### 1. **Criar repositório no GitHub**
```bash
# No seu computador local:
cd /home/jonathan/n8n
git init
git add .
git commit -m "Initial commit - WhatsApp Expense Tracker"

# Criar repositório no GitHub e depois:
git remote add origin https://github.com/JonathanCutrim/whatsapp-expense-tracker.git
git push -u origin main
```

### 2. **Deploy na VPS**
```bash
# Conectar na VPS:
ssh root@31.97.90.110

# Baixar e executar o script de setup:
curl -fsSL https://raw.githubusercontent.com/JonathanCutrim/whatsapp-expense-tracker/refs/heads/main/setup-vps.sh?token=GHSAT0AAAAAADJBA33W4WDZFNDQZT26B2HA2E2FDVA | bash
```

**OU baixar e executar manualmente:**
```bash
ssh root@31.97.90.110
wget https://raw.githubusercontent.com/JonathanCutrim/whatsapp-expense-tracker/refs/heads/main/setup-vps.sh?token=GHSAT0AAAAAADJBA33W4WDZFNDQZT26B2HA2E2FDVA
chmod +x setup-vps.sh
./setup-vps.sh
```

---

## 📋 Método 2: Upload Direto (Sem GitHub)

### 1. **Criar arquivo de deploy local**
```bash
# Criar arquivo com todos os configs:
cd /home/jonathan/n8n
cat > deploy-direct.sh << 'EOF'
#!/bin/bash

echo "📦 Fazendo upload direto para VPS..."

# Upload via SCP
scp -r * root@31.97.90.110:/tmp/whatsapp-gastos/

# Executar setup na VPS
ssh root@31.97.90.110 << 'REMOTE_EOF'
# Mover arquivos para local final
mkdir -p /opt/whatsapp-gastos
cp -r /tmp/whatsapp-gastos/* /opt/whatsapp-gastos/
cd /opt/whatsapp-gastos

# Executar setup
chmod +x setup-vps.sh
./setup-vps.sh
REMOTE_EOF

echo "✅ Deploy concluído!"
EOF

chmod +x deploy-direct.sh
```

### 2. **Executar deploy**
```bash
./deploy-direct.sh
```

---

## 📋 Método 3: Setup Manual Passo a Passo

### 1. **Conectar na VPS**
```bash
ssh root@31.97.90.110
# Senha: h&-(cUx8J-1r)1j@1mE?
```

### 2. **Preparar ambiente**
```bash
# Atualizar sistema
apt update && apt upgrade -y

# Instalar dependências
apt install -y git curl wget docker.io docker-compose

# Iniciar Docker
systemctl start docker
systemctl enable docker

# Configurar firewall
ufw allow 22
ufw allow 5678
ufw allow 3000  
ufw allow 11434
ufw --force enable
```

### 3. **Criar arquivos de configuração**

**docker-compose.yml:**
```bash
mkdir -p /opt/whatsapp-gastos
cd /opt/whatsapp-gastos

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - GENERIC_TIMEZONE=America/Sao_Paulo
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=senhaSegura
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - WEBHOOK_URL=http://31.97.90.110:5678
      - N8N_PROTOCOL=http
    volumes:
      - n8n_data:/home/node/.n8n
      - ./n8n/workflows:/home/node/.n8n/workflows
    depends_on:
      - ollama
      - waha
    networks:
      - expense_tracker

  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    environment:
      - OLLAMA_HOST=0.0.0.0:11434
    networks:
      - expense_tracker

  waha:
    image: devlikeapro/waha:2024.12.12
    container_name: waha
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - WHATSAPP_HOOK_URL=http://n8n:5678/webhook/whatsapp-gasto
      - WHATSAPP_HOOK_EVENTS=message
    volumes:
      - waha_data:/app/.wwebjs_auth
    networks:
      - expense_tracker

volumes:
  n8n_data:
  ollama_data:
  waha_data:

networks:
  expense_tracker:
    driver: bridge
EOF
```

### 4. **Iniciar serviços**
```bash
# Iniciar containers
docker-compose up -d

# Aguardar inicialização
sleep 30

# Baixar modelo IA
docker exec ollama ollama pull llama3.2
```

### 5. **Upload do workflow**
```bash
# Do seu computador local:
scp whatsapp-to-sheets-workflow.json root@31.97.90.110:/opt/whatsapp-gastos/
```

---

## ✅ Verificação do Deploy

### 1. **Testar serviços**
```bash
# Na VPS:
docker-compose ps

# Verificar logs:
docker-compose logs -f
```

### 2. **Acessar interfaces**
- **n8n**: http://31.97.90.110:5678 (admin/senhaSegura)
- **WAHA**: http://31.97.90.110:3000
- **Ollama**: http://31.97.90.110:11434

### 3. **Configurar sistema**
1. Acessar n8n e configurar Google Sheets
2. Importar workflow
3. Atualizar ID da planilha
4. Conectar WhatsApp via WAHA

---

## 🔧 Comandos Úteis na VPS

```bash
# Ver status dos containers
docker-compose ps

# Ver logs
docker-compose logs -f

# Reiniciar serviços
docker-compose restart

# Parar serviços
docker-compose down

# Atualizar projeto (se usando GitHub)
cd /opt/whatsapp-gastos
git pull origin main
docker-compose down
docker-compose up -d
```

---

## 🚨 Resolução de Problemas

### Firewall bloqueando acesso:
```bash
ufw status
ufw allow 5678
ufw allow 3000
ufw allow 11434
```

### Containers não iniciando:
```bash
docker-compose logs
docker system prune -f
docker-compose up -d
```

### Modelo IA não baixado:
```bash
docker exec ollama ollama list
docker exec ollama ollama pull llama3.2
```