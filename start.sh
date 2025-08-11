#!/bin/bash

echo "🚀 Iniciando sistema de rastreamento de gastos WhatsApp..."

# Verifica se o Docker está rodando
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Para containers existentes
echo "🔄 Parando containers existentes..."
docker-compose down

# Inicia os serviços
echo "🔧 Iniciando serviços..."
docker-compose up -d

# Aguarda os serviços subirem
echo "⏳ Aguardando serviços iniciarem..."
sleep 10

# Baixa o modelo Llama 3.2 no Ollama
echo "📥 Baixando modelo Llama 3.2..."
docker exec ollama ollama pull llama3.2

echo "✅ Sistema iniciado com sucesso!"
echo ""
echo "🌐 Acesse o n8n em: http://localhost:5678"
echo "   Usuário: admin"
echo "   Senha: senhaSegura"
echo ""
echo "📱 WAHA (WhatsApp) em: http://localhost:3000"
echo "🤖 Ollama em: http://localhost:11434"
echo ""
echo "📋 Para importar o workflow:"
echo "   1. Acesse o n8n"
echo "   2. Vá em 'Settings' > 'Import'"
echo "   3. Selecione o arquivo: whatsapp-to-sheets-workflow.json"
echo ""
echo "🔧 Para configurar o Google Sheets:"
echo "   1. Vá até https://console.developers.google.com"
echo "   2. Crie um projeto e ative a API do Google Sheets"
echo "   3. Crie credenciais de conta de serviço"
echo "   4. No n8n, configure as credenciais do Google Sheets"
echo "   5. Substitua 'YOUR_GOOGLE_SHEET_ID' no workflow pelo ID da sua planilha"