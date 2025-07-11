# Guia de Troubleshooting - Claude Code + MCPs

## 📋 Índice
1. [Problemas de Instalação](#problemas-de-instalação)
2. [Erros de Configuração](#erros-de-configuração)
3. [Problemas com MCPs](#problemas-com-mcps)
4. [Erros do TaskMaster](#erros-do-taskmaster)
5. [Problemas do Context7](#problemas-do-context7)
6. [Performance e Otimização](#performance-e-otimização)
7. [Debugging Avançado](#debugging-avançado)

## 🔧 Problemas de Instalação

### Erro: "command not found: claude"

**Sintomas**:
```bash
$ claude
bash: command not found: claude
```

**Soluções**:
```bash
# 1. Verificar se está instalado
npm list -g @anthropic/claude-code

# 2. Se não estiver, instalar
npm install -g @anthropic/claude-code

# 3. Verificar PATH
echo $PATH
which node
which npm

# 4. Se o PATH estiver incorreto
export PATH="$PATH:$(npm bin -g)"
```

### Erro: "Permission denied" durante instalação

**Soluções**:
```bash
# Opção 1: Usar npx (recomendado)
npx @anthropic/claude-code

# Opção 2: Mudar diretório npm global
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
npm install -g @anthropic/claude-code

# Opção 3: Usar nvm (melhor solução)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
npm install -g @anthropic/claude-code
```

### Erro: Node.js version incompatível

**Sintomas**:
```
Error: Node.js version 16.x.x is not supported. Required: >=20.0.0
```

**Solução**:
```bash
# Atualizar Node.js com nvm
nvm install 20
nvm use 20
nvm alias default 20

# Verificar versão
node --version  # Deve mostrar v20.x.x ou superior
```

## ⚙️ Erros de Configuração

### Arquivo .claude.json não encontrado

**Sintomas**:
```
Warning: Configuration file not found
```

**Soluções**:
```bash
# 1. Criar arquivo de configuração
mkdir -p ~/.claude
touch ~/.claude.json

# 2. Adicionar configuração mínima
cat > ~/.claude.json << 'EOF'
{
  "mcpServers": {}
}
EOF

# 3. Verificar permissões
chmod 644 ~/.claude.json
```

### JSON inválido em configuração

**Sintomas**:
```
Error: Invalid JSON in configuration file
```

**Diagnóstico e Solução**:
```bash
# 1. Validar JSON
cat ~/.claude.json | jq .

# 2. Se houver erro, o jq mostrará onde
# Exemplo de erro comum: vírgula extra
{
  "mcpServers": {
    "context7": {...},  // <- vírgula extra aqui
  }
}

# 3. Usar validador online
# https://jsonlint.com/

# 4. Backup e recriar
mv ~/.claude.json ~/.claude.json.backup
# Recriar arquivo correto
```

### Variáveis de ambiente não carregando

**Sintomas**:
- MCPs não reconhecem configurações
- TaskMaster usa configurações padrão

**Soluções**:
```bash
# 1. Verificar se estão definidas
env | grep -E "(CLAUDE|TASKMASTER|MCP)"

# 2. Recarregar shell
source ~/.bashrc
# ou
exec bash

# 3. Verificar arquivo correto
# Para bash: ~/.bashrc
# Para zsh: ~/.zshrc
# Para fish: ~/.config/fish/config.fish

# 4. Debug de carregamento
echo "Loading .bashrc" >> ~/.bashrc
# Abrir novo terminal e verificar se aparece
```

## 🔌 Problemas com MCPs

### MCP não inicia

**Sintomas**:
```
Error: Failed to start MCP server 'context7'
```

**Soluções**:
```bash
# 1. Testar comando manualmente
npx -y @upstash/context7-mcp

# 2. Limpar cache npm
npm cache clean --force

# 3. Verificar logs
claude logs --mcp context7

# 4. Reinstalar MCP específico
npm uninstall -g @upstash/context7-mcp
npm install -g @upstash/context7-mcp
```

### MCP timeout

**Sintomas**:
```
Error: MCP server 'taskmaster-ai' timed out
```

**Soluções**:
```bash
# 1. Aumentar timeout na configuração
{
  "mcpServers": {
    "taskmaster-ai": {
      "timeout": 30000,  // 30 segundos
      "command": "npx",
      "args": ["task-master-ai"]
    }
  }
}

# 2. Verificar recursos do sistema
top  # Ver CPU e memória
df -h  # Ver espaço em disco

# 3. Matar processos zumbis
ps aux | grep -E "(mcp|taskmaster)" | grep defunct
# kill -9 [PID]
```

### Múltiplos MCPs conflitando

**Sintomas**:
- Comandos misturados
- Respostas incorretas

**Solução**:
```bash
# 1. Verificar processos rodando
ps aux | grep -E "(mcp|context7|taskmaster)"

# 2. Matar todos e reiniciar
pkill -f "mcp"
pkill -f "context7"
pkill -f "taskmaster"

# 3. Iniciar Claude Code limpo
claude --clean-start
```

## 📊 Erros do TaskMaster

### "TaskMaster not initialized"

**Soluções**:
```bash
# 1. No projeto, executar
/project-setup

# 2. Verificar estrutura
ls -la .taskmaster/

# 3. Se faltar config
mkdir -p .taskmaster
/project-setup --force
```

### "API key invalid or missing"

**Sintomas**:
```
Error: API key not found for provider
```

**Soluções**:
```bash
# 1. Verificar configuração
/models

# 2. Para Claude Code (padrão)
# Não precisa API key!

# 3. Para outros providers
export OPENAI_API_KEY="sua-key"
export PERPLEXITY_API_KEY="sua-key"

# 4. Ou no arquivo de config
{
  "taskmaster-ai": {
    "env": {
      "OPENAI_API_KEY": "sk-..."
    }
  }
}
```

### Tarefas não sincronizando

**Soluções**:
```bash
# 1. Verificar arquivo de tarefas
cat .taskmaster/tasks/tasks.json | jq .

# 2. Validar integridade
/validate-dependencies

# 3. Reparar se necessário
/fix-dependencies

# 4. Backup e regenerar
cp .taskmaster/tasks/tasks.json tasks.backup.json
/generate
```

## 🔍 Problemas do Context7

### Context7 não retorna resultados

**Sintomas**:
```
"No documentation found"
```

**Soluções**:
```bash
# 1. Verificar sintaxe exata
# CORRETO: "use context7"
# ERRADO: "use Context7", "context7", "use context 7"

# 2. Ser específico
# BOM: "React useState hook use context7"
# RUIM: "hooks use context7"

# 3. Testar conectividade
ping -c 4 google.com

# 4. Verificar processo
ps aux | grep context7
```

### Documentação desatualizada

**Soluções**:
```bash
# 1. Forçar atualização de cache
pkill -f context7
# Reiniciar Claude Code

# 2. Especificar versão
"Next.js 14 app router use context7"
"React 18 concurrent features use context7"

# 3. Verificar fonte
# Context7 busca em documentações oficiais
```

## ⚡ Performance e Otimização

### Claude Code lento para iniciar

**Soluções**:
```bash
# 1. Desabilitar MCPs não usados
{
  "mcpServers": {
    // "unused-mcp": {...}  // Comentar
  }
}

# 2. Modo de desenvolvimento
claude --dev-mode  # Menos verificações

# 3. Limpar cache
rm -rf ~/.claude/cache/*
npm cache clean --force
```

### Alto uso de memória

**Diagnóstico**:
```bash
# 1. Monitorar uso
top -p $(pgrep -f claude)

# 2. Ver processos MCP
ps aux | grep -E "(mcp|node)" | awk '{print $2, $11}'
```

**Soluções**:
```bash
# 1. Limitar memória Node.js
export NODE_OPTIONS="--max-old-space-size=2048"

# 2. Configurar garbage collection
export NODE_OPTIONS="--expose-gc --max-old-space-size=2048"

# 3. Desabilitar features não usadas
{
  "performance": {
    "disableCache": false,
    "lightweight": true
  }
}
```

## 🐛 Debugging Avançado

### Ativar logs detalhados

```bash
# 1. Modo debug completo
export CLAUDE_DEBUG=1
export MCP_DEBUG=1
export TASKMASTER_DEBUG=1

# 2. Salvar logs
claude --log-level debug 2>&1 | tee claude-debug.log

# 3. Logs específicos do MCP
claude logs --mcp taskmaster-ai --tail 100
```

### Analisar comunicação MCP

```bash
# 1. Interceptar mensagens
export MCP_TRACE=1
claude

# 2. Ver protocolo JSON-RPC
# As mensagens aparecerão no terminal

# 3. Salvar trace
export MCP_TRACE_FILE=~/mcp-trace.json
```

### Modo de recuperação

```bash
# 1. Reset completo
rm -rf ~/.claude/cache
rm -rf ~/.claude/.taskmaster-global/cache
pkill -f "claude|mcp|context7|taskmaster"

# 2. Recriar configuração
mv ~/.claude.json ~/.claude.json.old
# Recriar do zero

# 3. Teste mínimo
cat > ~/.claude.json << 'EOF'
{
  "mcpServers": {}
}
EOF

# 4. Adicionar MCPs um por vez
```

### Relatório de diagnóstico

```bash
#!/bin/bash
# diagnostic.sh

echo "=== Claude Code Diagnostic ==="
echo "Date: $(date)"
echo ""

echo "1. Versions:"
echo "Node: $(node --version)"
echo "npm: $(npm --version)"
echo "Claude: $(claude --version 2>/dev/null || echo 'Not installed')"
echo ""

echo "2. Configuration:"
echo "Config exists: $([ -f ~/.claude.json ] && echo 'Yes' || echo 'No')"
echo "CLAUDE.md exists: $([ -f ~/.claude/CLAUDE.md ] && echo 'Yes' || echo 'No')"
echo ""

echo "3. Environment:"
env | grep -E "(CLAUDE|MCP|TASKMASTER)" | sort
echo ""

echo "4. Processes:"
ps aux | grep -E "(claude|mcp|context7|taskmaster)" | grep -v grep
echo ""

echo "5. Disk Space:"
df -h ~ | grep -E "(Filesystem|home)"
echo ""

echo "6. Network:"
ping -c 1 google.com &>/dev/null && echo "Internet: OK" || echo "Internet: FAILED"
```

### Casos específicos

#### WSL2 no Windows
```bash
# Problema: MCPs não iniciam
# Solução: Usar caminho Windows
{
  "mcpServers": {
    "taskmaster-ai": {
      "command": "cmd.exe",
      "args": ["/c", "npx", "task-master-ai"]
    }
  }
}
```

#### macOS com Apple Silicon
```bash
# Problema: Binários incompatíveis
# Solução: Forçar arquitetura
arch -x86_64 npm install -g @anthropic/claude-code
```

#### Linux com SELinux
```bash
# Problema: Permission denied
# Solução: Ajustar contexto
chcon -t bin_t ~/.npm-global/bin/claude
```

## 📞 Suporte Adicional

### Recursos
- [GitHub Issues](https://github.com/anthropics/claude-code/issues)
- [Documentação Oficial](https://docs.anthropic.com/claude-code)
- [Comunidade Discord](https://discord.gg/anthropic)

### Coletar informações para suporte
```bash
# Gerar relatório completo
claude diagnostic --full > claude-report.txt

# Incluir:
# - Arquivo claude-report.txt
# - Configuração (sem API keys!)
# - Passos para reproduzir
# - Mensagens de erro completas
```

---

**Dica**: A maioria dos problemas são resolvidos com:
1. Verificar configuração JSON
2. Reiniciar Claude Code
3. Verificar variáveis de ambiente
4. Atualizar para última versão