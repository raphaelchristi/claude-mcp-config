# Guia de Instalação Completo - Claude Code com MCPs

## 📋 Índice
1. [Pré-requisitos](#pré-requisitos)
2. [Instalação do Claude Code](#instalação-do-claude-code)
3. [Configuração Inicial](#configuração-inicial)
4. [Configuração dos MCPs](#configuração-dos-mcps)
5. [Verificação da Instalação](#verificação-da-instalação)
6. [Configurações Avançadas](#configurações-avançadas)

## 🔧 Pré-requisitos

### Sistema Operacional
- Linux, macOS ou Windows (com WSL2)
- Terminal com suporte a bash/zsh

### Software Necessário
```bash
# Node.js v20 ou superior
node --version  # Deve mostrar v20.x.x ou superior

# npm v10 ou superior
npm --version   # Deve mostrar v10.x.x ou superior

# Git
git --version   # Qualquer versão recente
```

### Instalação do Node.js (se necessário)
```bash
# Usando nvm (recomendado)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 20
nvm use 20
```

## 🚀 Instalação do Claude Code

### Método 1: Instalação Global (Recomendado)
```bash
# Instalar Claude Code globalmente
npm install -g @anthropic/claude-code

# Verificar instalação
claude --version
```

### Método 2: Usando npx (sem instalação)
```bash
# Executar diretamente
npx @anthropic/claude-code
```

## ⚙️ Configuração Inicial

### 1. Criar Estrutura de Diretórios
```bash
# Criar diretórios necessários
mkdir -p ~/.claude/.taskmaster-global
mkdir -p ~/.config/claude
```

### 2. Configurar Variáveis de Ambiente
```bash
# Adicionar ao ~/.bashrc ou ~/.zshrc
echo 'export CLAUDECODE=1' >> ~/.bashrc
echo 'export CLAUDE_CODE_ENTRYPOINT=cli' >> ~/.bashrc
echo 'export TASKMASTER_DEFAULT_PROVIDER=claude-code' >> ~/.bashrc
echo 'export TASKMASTER_GLOBAL_CONFIG=~/.claude/.taskmaster-global/config.json' >> ~/.bashrc

# Recarregar configurações
source ~/.bashrc
```

### 3. Configuração da API Key (se aplicável)
```bash
# Se você tem uma API key do Anthropic
export ANTHROPIC_API_KEY="sua-api-key-aqui"
```

## 🔌 Configuração dos MCPs

### 1. Criar Arquivo de Configuração Principal
```bash
# Criar ~/.claude.json
cat > ~/.claude.json << 'EOF'
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp"
      ],
      "env": {}
    },
    "taskmaster-ai": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "task-master-ai"
      ],
      "env": {}
    }
  }
}
EOF
```

### 2. Configurar TaskMaster Global
```bash
# Criar configuração global do TaskMaster
cat > ~/.claude/.taskmaster-global/config.json << 'EOF'
{
  "models": {
    "main": {
      "provider": "claude-code",
      "modelId": "sonnet",
      "maxTokens": 32000,
      "temperature": 0.2
    },
    "research": {
      "provider": "claude-code",
      "modelId": "opus",
      "maxTokens": 32000,
      "temperature": 0.1
    },
    "fallback": {
      "provider": "claude-code",
      "modelId": "sonnet",
      "maxTokens": 32000,
      "temperature": 0.2
    }
  },
  "global": {
    "logLevel": "info",
    "debug": false,
    "defaultNumTasks": 10,
    "defaultSubtasks": 5,
    "defaultPriority": "medium",
    "responseLanguage": "Portuguese"
  }
}
EOF
```

### 3. Adicionar Instruções Globais (CLAUDE.md)
```bash
# Baixar o arquivo CLAUDE.md do repositório
curl -o ~/.claude/CLAUDE.md https://raw.githubusercontent.com/seu-usuario/claude-mcp-config/main/config/CLAUDE.md

# Ou copiar manualmente
cp /caminho/para/CLAUDE.md ~/.claude/CLAUDE.md
```

## ✅ Verificação da Instalação

### 1. Testar Claude Code
```bash
# Abrir Claude Code
claude

# Você deve ver a interface do Claude Code
```

### 2. Verificar MCPs Carregados
```bash
# No Claude Code, digite:
/mcp

# Deve listar Context7 e TaskMaster AI
```

### 3. Testar Context7
```bash
# No Claude Code:
"Como usar React Hooks? use context7"

# Deve retornar documentação atualizada
```

### 4. Testar TaskMaster
```bash
# No Claude Code:
/models

# Deve mostrar a configuração dos modelos
```

## 🛠️ Configurações Avançadas

### Adicionar APIs Externas (Opcional)

Se você quiser usar APIs externas com o TaskMaster:

```bash
# Editar ~/.claude.json
{
  "mcpServers": {
    "taskmaster-ai": {
      "type": "stdio",
      "command": "npx",
      "args": ["task-master-ai"],
      "env": {
        "PERPLEXITY_API_KEY": "sua-chave-aqui",
        "OPENAI_API_KEY": "sua-chave-aqui",
        "GOOGLE_API_KEY": "sua-chave-aqui"
      }
    }
  }
}
```

### Configurar para Cursor (Opcional)
```bash
# Se você também usa Cursor
mkdir -p ~/.cursor
cp ~/.claude.json ~/.cursor/mcp.json
```

### Aliases Úteis
```bash
# Adicionar ao ~/.bashrc
alias cc='claude'
alias tm='claude /task-status'
alias nt='claude /next-task'
```

## 🔍 Troubleshooting de Instalação

### Problema: "command not found: claude"
```bash
# Verificar instalação
npm list -g @anthropic/claude-code

# Reinstalar se necessário
npm uninstall -g @anthropic/claude-code
npm install -g @anthropic/claude-code
```

### Problema: "MCP server failed to start"
```bash
# Verificar permissões
chmod +x ~/.claude.json

# Verificar sintaxe JSON
cat ~/.claude.json | jq .

# Testar comando manualmente
npx -y @upstash/context7-mcp
```

### Problema: Variáveis de ambiente não carregam
```bash
# Verificar se foram adicionadas
grep CLAUDECODE ~/.bashrc

# Forçar recarga
exec bash
# ou
source ~/.bashrc
```

## 📝 Próximos Passos

1. Leia o [Guia de Comandos](COMMANDS.md)
2. Veja [Exemplos de Workflows](../examples/WORKFLOWS.md)
3. Configure seu primeiro projeto com `/project-setup`

---

**Instalação concluída!** 🎉 

Agora você tem o Claude Code configurado com Context7 e TaskMaster AI.