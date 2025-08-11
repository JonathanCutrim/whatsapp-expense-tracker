#!/bin/bash

echo "📦 Deploy direto para VPS (sem GitHub)..."

# Verificar se temos acesso à VPS
echo "🔐 Testando conexão com VPS..."
if ! ssh -o ConnectTimeout=5 root@31.97.90.110 "echo 'Conexão OK'"; then
    echo "❌ Erro: Não foi possível conectar na VPS"
    echo "Verifique se você tem acesso SSH configurado"
    exit 1
fi

# Criar diretório temporário na VPS
echo "📁 Preparando ambiente na VPS..."
ssh root@31.97.90.110 << 'EOF'
mkdir -p /tmp/whatsapp-gastos
rm -rf /opt/whatsapp-gastos
mkdir -p /opt/whatsapp-gastos
EOF

# Upload dos arquivos
echo "📤 Enviando arquivos..."
scp -r * root@31.97.90.110:/tmp/whatsapp-gastos/

# Executar instalação na VPS
echo "🚀 Instalando na VPS..."
ssh root@31.97.90.110 << 'EOF'
# Copiar arquivos para local final
cp -r /tmp/whatsapp-gastos/* /opt/whatsapp-gastos/
cd /opt/whatsapp-gastos

# Dar permissão aos scripts
chmod +x *.sh

# Executar setup completo
./setup-vps.sh

# Limpar arquivos temporários
rm -rf /tmp/whatsapp-gastos
EOF

echo ""
echo "✅ Deploy concluído com sucesso!"
echo ""
echo "🌐 Acesso aos serviços:"
echo "   📊 n8n: http://31.97.90.110:5678"
echo "      Usuário: admin"
echo "      Senha: senhaSegura"
echo ""
echo "   📱 WAHA: http://31.97.90.110:3000"
echo "   🤖 Ollama: http://31.97.90.110:11434"
echo ""
echo "🔧 Próximos passos:"
echo "   1. Configure o Google Sheets no n8n"
echo "   2. Importe o workflow"
echo "   3. Configure o WhatsApp no WAHA"