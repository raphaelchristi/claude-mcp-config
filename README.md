# Claude Code MCP Configuration Guide 🤖

Este repositório documenta a configuração completa dos servidores MCP (Model Context Protocol) com Claude Code, incluindo Context7 e TaskMaster AI.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Instalação](#instalação)
- [Configuração dos MCPs](#configuração-dos-mcps)
- [Comandos Disponíveis](#comandos-disponíveis)
- [Estrutura de Arquivos](#estrutura-de-arquivos)
- [Comandos Customizados](#comandos-customizados)
- [Exemplos de Uso](#exemplos-de-uso)
- [Troubleshooting](#troubleshooting)

## 🎯 Visão Geral

Esta configuração integra o Claude Code com dois poderosos servidores MCP:

### 🔍 Context7
- **Função**: Acesso a documentação em tempo real
- **Benefício**: Documentação sempre atualizada de frameworks e bibliotecas
- **Uso**: Adicione "use context7" em qualquer pergunta técnica

### 📊 TaskMaster AI
- **Função**: Gerenciamento inteligente de projetos
- **Benefício**: Geração automática de tarefas, análise de complexidade
- **Uso**: Comandos slash como `/project-setup`, `/parse-prd`, etc.

## 🚀 Instalação

### Pré-requisitos
- Node.js v20+ instalado
- npm ou yarn
- Claude Code CLI

### Passo 1: Instalar Claude Code
```bash
npm install -g @anthropic/claude-code
```

### Passo 2: Configurar os MCPs

1. **Criar arquivo de configuração principal**:
```bash
# Criar diretório de configuração
mkdir -p ~/.claude

# Copiar o arquivo de configuração
cp config/claude.json ~/.claude.json
```

2. **Configurar as variáveis de ambiente**:
```bash
# Adicionar ao seu ~/.bashrc ou ~/.zshrc
export CLAUDECODE=1
export CLAUDE_CODE_ENTRYPOINT=cli
export TASKMASTER_DEFAULT_PROVIDER=claude-code
export TASKMASTER_GLOBAL_CONFIG=~/.claude/.taskmaster-global/config.json
```

3. **Criar configuração global do TaskMaster**:
```bash
mkdir -p ~/.claude/.taskmaster-global
cp config/taskmaster-global-config.json ~/.claude/.taskmaster-global/config.json
```

4. **Adicionar instruções globais**:
```bash
cp config/CLAUDE.md ~/.claude/CLAUDE.md
```

## 🔧 Configuração dos MCPs

### Context7 - Documentação em Tempo Real

**Arquivo**: `~/.claude.json`
```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {}
    }
  }
}
```

**Como usar**:
```
# Exemplo de uso
"Como implementar autenticação no Next.js 15? use context7"
"Mostre exemplos de React Hooks use context7"
```

### TaskMaster AI - Gerenciamento de Projetos

**Arquivo**: `~/.claude.json`
```json
{
  "mcpServers": {
    "taskmaster-ai": {
      "type": "stdio",
      "command": "npx",
      "args": ["task-master-ai"],
      "env": {}
    }
  }
}
```

**Comandos disponíveis**:
- `/project-setup` - Inicializar projeto
- `/prd "descrição"` - Criar PRD de forma rápida e conversacional
- `/create-prd` - Criar documento de requisitos estruturado
- `/parse-prd` - Gerar tarefas do PRD
- `/task-status` - Ver status do projeto
- `/next-task` - Próxima tarefa prioritária
- `/complexity` - Análise de complexidade
- `/break-down [id]` - Dividir tarefa complexa
- `/complete-task [id]` - Marcar tarefa como concluída

## 📁 Estrutura de Arquivos

```
~/.claude/
├── .claude.json                    # Configuração principal do Claude Code
├── CLAUDE.md                       # Instruções globais para o Claude
├── commands/                       # Comandos customizados
│   └── prd.md                     # Comando /prd para criar PRDs
└── .taskmaster-global/
    └── config.json                 # Configuração global do TaskMaster

~/.cursor/mcp.json                  # Configuração adicional para Cursor (opcional)
```

### Arquivos de Configuração

1. **`.claude.json`**: Configuração principal com os servidores MCP
2. **`CLAUDE.md`**: Instruções globais que o Claude seguirá em todos os projetos
3. **`.taskmaster-global/config.json`**: Configurações de modelos e preferências do TaskMaster
4. **`commands/`**: Diretório com comandos customizados (como `/prd`)

## 🎨 Comandos Customizados

O Claude Code suporta comandos customizados através de arquivos Markdown em `~/.claude/commands/`.

### Comando /prd Incluído
- **Localização**: `~/.claude/commands/prd.md`
- **Função**: Cria PRDs completos através de processo interativo de 4 fases
- **Características**:
  - Perguntas estruturadas e contextualizadas
  - Template otimizado para 2025
  - User stories com critérios de aceitação
  - Integração perfeita com TaskMaster

### Criar Seus Próprios Comandos
```bash
# Criar novo comando
echo "# Meu Comando" > ~/.claude/commands/meucomando.md
```

Veja [docs/CUSTOM-COMMANDS.md](docs/CUSTOM-COMMANDS.md) para guia completo.

## 💡 Exemplos de Uso

### Exemplo 1: Pesquisa de Documentação
```bash
# No Claude Code
User: Como usar o novo App Router do Next.js? use context7
Claude: [Retorna documentação atualizada do Next.js App Router]
```

### Exemplo 2: Gerenciamento de Projeto
```bash
# Iniciar novo projeto
/project-setup

# Criar documento de requisitos
/create-prd

# Gerar tarefas
/parse-prd

# Ver próxima tarefa
/next-task

# Marcar tarefa como concluída
/complete-task 1
```

### Exemplo 3: Workflow Completo
```bash
# 1. Inicializar projeto
/project-setup

# 2. Criar PRD interativo
/create-prd
[Claude fará perguntas sobre o projeto]

# 3. Gerar tarefas automaticamente
/parse-prd

# 4. Analisar complexidade
/complexity

# 5. Começar desenvolvimento
/next-task
[Implementar tarefa]
/complete-task 1

# 6. Continuar ciclo
/next-task
```

## 🐛 Troubleshooting

### Problema: "MCP server not found"
**Solução**:
```bash
# Verificar se o arquivo existe
ls -la ~/.claude.json

# Recarregar configuração
claude --reload-config
```

### Problema: "TaskMaster not initialized"
**Solução**:
```bash
# Rodar setup do projeto
/project-setup

# Verificar configuração global
cat ~/.claude/.taskmaster-global/config.json
```

### Problema: Context7 não retorna resultados
**Solução**:
- Verifique se está usando a sintaxe exata: "use context7"
- Seja específico com o nome da biblioteca/framework
- Tente incluir a versão quando conhecida

### Verificar MCPs Ativos
```bash
# Ver processos MCP rodando
ps aux | grep -E "(taskmaster|context7|mcp)"

# Ver logs do Claude Code
claude logs
```

## 🔐 Segurança

**Importante**: Nunca commite arquivos com chaves de API!

Se você usar APIs adicionais (Perplexity, OpenAI, etc.):
1. Use variáveis de ambiente
2. Adicione ao `.gitignore`
3. Use um gerenciador de secrets

## 🤝 Contribuindo

1. Fork este repositório
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commite suas mudanças: `git commit -m 'Add nova funcionalidade'`
4. Push: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

## 📚 Recursos Adicionais

- [Documentação do Claude Code](https://docs.anthropic.com/claude-code)
- [Context7 MCP](https://github.com/upstash/context7-mcp)
- [TaskMaster AI](https://github.com/taskmaster-ai/taskmaster)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Claudia (GUI para Claude Code)](https://github.com/getAsterisk/claudia)
- [Instalação do Claudia no WSL](docs/CLAUDIA-WSL-INSTALLATION.md)

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

**Pronto para revolucionar seu workflow de desenvolvimento?** 🚀

Comece com a instalação e explore o poder dos MCPs com Claude Code!