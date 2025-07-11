# Comandos Customizados do Claude Code

## 📋 Visão Geral

O Claude Code permite criar comandos customizados através de arquivos Markdown no diretório `~/.claude/commands/`. Estes comandos estendem as funcionalidades do Claude com instruções específicas e workflows personalizados.

## 🔧 Como Funcionam

### Estrutura de Diretórios
```
~/.claude/
└── commands/
    ├── prd.md          # Comando /prd
    ├── mycommand.md    # Comando /mycommand
    └── ...
```

### Formato do Arquivo

Cada arquivo `.md` em `~/.claude/commands/` define um comando slash. O nome do arquivo (sem extensão) torna-se o comando.

**Estrutura básica**:
```markdown
# Título do Comando

## Command: `/nome-do-comando`

**Usage**: `/nome-do-comando [parâmetros]`

**Description**: Descrição breve do que o comando faz

## Instructions

[Instruções detalhadas para o Claude seguir]

## Examples

[Exemplos de uso]
```

## 📝 Comando /prd - Product Requirements Document

### Localização
`~/.claude/commands/prd.md`

### Funcionalidades
- **Processo Interativo de 4 Fases**: Guia estruturado para criar PRDs completos
- **Perguntas Contextualizadas**: Adapta perguntas baseadas no tipo de projeto
- **Template Otimizado**: PRD pronto para TaskMaster AI parsing
- **User Stories Detalhadas**: Com critérios de aceitação testáveis

### Fases do Processo

#### Phase 1: Initial Context Gathering
- Problem Statement
- Target Users
- Business Context
- Scope Boundaries  
- Technical Context

#### Phase 2: Deep-dive Context
- Business Goals Deep-dive
- User Experience Deep-dive
- Technical Deep-dive

#### Phase 3: PRD Generation
Gera documento completo com:
- Product overview
- Goals e KPIs
- User personas
- Functional requirements
- Technical considerations
- User stories

#### Phase 4: TaskMaster Optimization
- Salva em `.taskmaster/docs/prd.md`
- Otimiza para `/parse-prd`
- Oferece refinamentos

### Exemplo de Uso
```bash
/prd "E-commerce platform for handmade crafts"
```

## 🚀 Criando Seus Próprios Comandos

### Passo 1: Criar Arquivo
```bash
# Criar novo comando
touch ~/.claude/commands/meucomando.md
```

### Passo 2: Definir Estrutura
```markdown
# Meu Comando Customizado

## Command: `/meucomando`

**Usage**: `/meucomando [parâmetro]`

**Description**: Faz algo específico e útil

## Instructions

Você é um assistente especializado em [área]. Quando o usuário usar este comando:

1. Faça X
2. Pergunte Y
3. Gere Z

## Process

[Descreva o processo passo a passo]

## Output Format

[Defina o formato esperado da saída]
```

### Passo 3: Usar o Comando
```bash
# No Claude Code
/meucomando "contexto inicial"
```

## 💡 Exemplos de Comandos Customizados

### 1. Code Review Assistant
```markdown
# Code Review Assistant

## Command: `/review`

**Usage**: `/review [arquivo ou pasta]`

**Description**: Realiza code review detalhado

## Instructions

Analise o código fornecido e forneça:
1. Problemas de segurança
2. Melhorias de performance
3. Padrões de código
4. Sugestões de refatoração
```

### 2. API Documentation Generator
```markdown
# API Docs Generator

## Command: `/apidocs`

**Usage**: `/apidocs [arquivo de rotas]`

**Description**: Gera documentação OpenAPI/Swagger

## Instructions

Analise as rotas e gere documentação completa incluindo:
- Endpoints
- Parâmetros
- Responses
- Exemplos
```

### 3. Test Generator
```markdown
# Test Generator

## Command: `/tests`

**Usage**: `/tests [arquivo ou função]`

**Description**: Gera testes unitários e de integração

## Instructions

Crie testes abrangentes considerando:
- Happy path
- Edge cases
- Error scenarios
- Mocks necessários
```

## 🔍 Melhores Práticas

### 1. Nomenclatura
- Use nomes descritivos e curtos
- Evite conflitos com comandos existentes
- Use lowercase e hífens se necessário

### 2. Documentação
- Sempre inclua exemplos de uso
- Descreva claramente o output esperado
- Liste pré-requisitos se houver

### 3. Instruções
- Seja específico sobre o comportamento
- Defina tom e estilo de resposta
- Inclua validações e error handling

### 4. Integração
- Considere integração com outros comandos
- Use ferramentas disponíveis (Context7, TaskMaster)
- Mantenha consistência com workflow existente

## 🛠️ Comandos Customizados Disponíveis

### Comandos Atuais em `~/.claude/commands/`:
1. **`/prd`** - Product Requirements Document Generator
   - Processo interativo de 4 fases
   - Template otimizado para 2025
   - Integração com TaskMaster

### Como Descobrir Comandos
```bash
# Listar todos os comandos customizados
ls ~/.claude/commands/

# Ver conteúdo de um comando
cat ~/.claude/commands/prd.md
```

## 📚 Recursos Adicionais

### Templates de Comandos
Você pode criar templates para diferentes tipos de projetos:
- `/prd-saas` - PRD específico para SaaS
- `/prd-mobile` - PRD para apps mobile
- `/prd-api` - PRD para APIs

### Comandos Compostos
Combine múltiplos comandos em workflows:
```markdown
## Instructions

1. Execute `/prd` para criar requisitos
2. Use `/parse-prd` para gerar tarefas
3. Execute `/complexity` para análise
```

### Versionamento
Mantenha versões dos seus comandos:
```bash
# Backup antes de editar
cp ~/.claude/commands/prd.md ~/.claude/commands/prd.md.v1

# Ou use git
cd ~/.claude/commands
git init
git add .
git commit -m "Initial commands"
```

---

**Dica**: Comandos customizados são uma forma poderosa de padronizar workflows e compartilhar conhecimento com sua equipe!