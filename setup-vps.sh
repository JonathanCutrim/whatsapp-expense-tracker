#!/bin/bash

echo "🌐 Configurando sistema para VPS (31.97.90.110)..."

# Atualiza sistema
echo "📦 Atualizando sistema..."
apt update && apt upgrade -y

# Instala Git se não estiver instalado
echo "📋 Instalando Git..."
apt install -y git curl wget

# Instala Docker
echo "🐳 Instalando Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl start docker
systemctl enable docker
rm get-docker.sh

# Instala Docker Compose
echo "🔧 Instalando Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Configura firewall
echo "🔥 Configurando firewall..."
ufw allow 22    # SSH
ufw allow 5678  # n8n
ufw allow 3000  # WAHA
ufw allow 11434 # Ollama
ufw --force enable

# Remove diretório se já existir
rm -rf /opt/whatsapp-gastos

# Clona o projeto do GitHub
echo "📥 Clonando projeto do GitHub..."
cd /opt
git clone https://github.com/JonathanCutrim/whatsapp-expense-tracker.git whatsapp-gastos
cd /opt/whatsapp-gastos

# Torna scripts executáveis
chmod +x *.sh

# Atualiza URLs no docker-compose para VPS
echo "🔧 Configurando para VPS..."
sed -i 's/localhost/31.97.90.110/g' docker-compose.yml

# Inicia os serviços
echo "🚀 Iniciando serviços..."
docker-compose up -d

# Aguarda serviços iniciarem
echo "⏳ Aguardando serviços iniciarem..."
sleep 30

# Baixa modelo Llama 3.2
echo "🤖 Baixando modelo IA Llama 3.2..."
docker exec ollama ollama pull llama3.2

echo ""
echo "✅ VPS configurada e sistema iniciado!"
echo ""
echo "🌐 Acesso aos serviços:"
echo "   📊 n8n: http://31.97.90.110:5678"
echo "      Usuário: admin"
echo "      Senha: senhaSegura"
echo ""
echo "   📱 WAHA (WhatsApp): http://31.97.90.110:3000"
echo "   🤖 Ollama: http://31.97.90.110:11434"
echo ""
echo "🔧 Próximos passos:"
echo "   1. Acesse o n8n e configure as credenciais do Google Sheets"
echo "   2. Importe o workflow: whatsapp-to-sheets-workflow.json"
echo "   3. Substitua 'YOUR_GOOGLE_SHEET_ID' pelo ID da sua planilha"
echo "   4. Acesse WAHA e escaneie o QR Code do WhatsApp"
echo "   5. Teste enviando uma mensagem: 'Gastei R$ 20 com lanche'"
echo ""
echo "📊 Para monitorar:"
echo "   docker-compose logs -f"