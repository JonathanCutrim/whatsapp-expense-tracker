# 🎯 Sistema de Rastreamento de Gastos via WhatsApp

Sistema completo para receber mensagens do WhatsApp, interpretar gastos usando IA local (Ollama) e salvar em Google Sheets.

## 🚀 Início Rápido

### Opção 1: Local
```bash
./start.sh
```

### Opção 2: VPS (31.97.90.110)
Veja [deploy-vps.md](deploy-vps.md) para instruções detalhadas.

**Resumo rápido:**
```bash
# 1. Criar repo no GitHub com os arquivos
# 2. Na VPS:
ssh root@31.97.90.110
curl -fsSL https://raw.githubusercontent.com/SEU_USUARIO/whatsapp-expense-tracker/main/setup-vps.sh | bash
```

## 🔧 Pré-requisitos

### 1. **Google Sheets API**
- Crie um projeto no [Google Cloud Console](https://console.developers.google.com)
- Ative a Google Sheets API
- Crie credenciais de conta de serviço
- Baixe o arquivo JSON das credenciais

### 2. **Planilha do Google Sheets**
- Crie uma nova planilha
- Anote o ID da planilha (na URL)
- Compartilhe com o email da conta de serviço (com permissão de edição)

## 📦 Instalação Manual

### 1. **Iniciar os serviços**
```bash
docker-compose up -d
```

### 2. **Aguardar e baixar modelo IA**
```bash
# Aguarda Ollama iniciar
sleep 30
# Baixa o modelo Llama 3.2
docker exec ollama ollama pull llama3.2
```

### 3. **Acessar n8n**
- URL: https://cda.jonathanlacerda.dev
- Usuário: `admin`
- Senha: `senhaSegura`

### 4. **Configurar credenciais no n8n**
- Google Sheets: Faça upload do JSON da conta de serviço

### 5. **Importar workflow**
- Importe o arquivo `whatsapp-to-sheets-workflow.json`
- Substitua `YOUR_GOOGLE_SHEET_ID` pelo ID da sua planilha

### 6. **Configurar WAHA (WhatsApp)**
- Acesse https://wp.jonathanlacerda.dev
- Escaneie o QR Code do WhatsApp
- O webhook já está configurado para: `http://n8n:5678/webhook/whatsapp-gasto`

## Estrutura da Planilha

A planilha deve ter as seguintes colunas:
- `timestamp`: Data/hora da mensagem
- `phone_number`: Número do WhatsApp
- `original_message`: Mensagem original
- `tipo`: Tipo (transacao/mensagem_comum)
- `valor`: Valor financeiro (se aplicável)
- `descricao`: Descrição da transação
- `categoria`: Categoria da transação

## Como Usar

1. Envie mensagens no WhatsApp conectado ao WAHA
2. Mensagens financeiras serão automaticamente parseadas
3. Dados serão salvos na planilha do Google Sheets

## Exemplos de Mensagens

**Transação financeira**:
```
Gastei R$ 25,50 com almoço no restaurante
```

**Mensagem comum**:
```
Olá, como você está?
```