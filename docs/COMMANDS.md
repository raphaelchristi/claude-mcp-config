# Guia Completo de Comandos Slash - TaskMaster AI

## 📋 Índice
1. [Comandos de Setup e Configuração](#comandos-de-setup-e-configuração)
2. [Comandos de Planejamento](#comandos-de-planejamento)
3. [Comandos de Desenvolvimento](#comandos-de-desenvolvimento)
4. [Comandos de Análise](#comandos-de-análise)
5. [Comandos de Gestão](#comandos-de-gestão)
6. [Referência Rápida](#referência-rápida)

## 🏗️ Comandos de Setup e Configuração

### `/project-setup`
**Descrição**: Inicializa um novo projeto com TaskMaster

**Uso**:
```bash
/project-setup
```

**O que faz**:
- Cria estrutura de diretórios `.taskmaster/`
- Configura modelos de IA
- Valida API keys
- Cria templates iniciais

**Opções**:
- `--skip-install`: Pula instalação de dependências
- `--rules [profiles]`: Adiciona perfis de regras (claude, cursor, etc.)

---

### `/models`
**Descrição**: Gerencia configuração de modelos de IA

**Uso**:
```bash
/models                    # Ver configuração atual
/models --set-main gpt-4   # Definir modelo principal
/models --list-available   # Listar modelos disponíveis
```

**Modelos Disponíveis**:
- `claude-code` (padrão)
- `gpt-4`, `gpt-3.5-turbo`
- `gemini-pro`, `gemini-flash`
- `llama-sonar` (com busca web)

---

### `/rules`
**Descrição**: Gerencia regras e perfis do projeto

**Uso**:
```bash
/rules add cursor          # Adicionar perfil
/rules remove vscode       # Remover perfil
/rules list               # Listar perfis ativos
```

**Perfis Disponíveis**:
- `claude`: Regras para Claude Code
- `cursor`: Regras para Cursor IDE
- `vscode`: Regras para VS Code
- `cline`: Regras para Cline
- `windsurf`: Regras para Windsurf

## 📝 Comandos de Planejamento

### `/prd "descrição"`
**Descrição**: Comando rápido para criar PRD com contexto inicial

**Uso**:
```bash
/prd "Sistema de e-commerce com carrinho e pagamento"
/prd "API REST para gerenciamento de tarefas"
```

**Processo**:
1. Inicia com o contexto fornecido
2. Claude faz perguntas para detalhar requisitos
3. Gera PRD completo de forma iterativa
4. Salva automaticamente em `.taskmaster/docs/prd.txt`

**Exemplo de Diálogo**:
```
User: /prd "Aplicativo de delivery de comida"

Claude: Entendi! Vou criar um PRD para um aplicativo de delivery. 
Algumas perguntas para detalhar:

1. Quais são os tipos de usuários? (cliente, restaurante, entregador?)
2. Principais funcionalidades para cada tipo?
3. Plataformas alvo? (Web, Mobile, ambos?)
4. Integrações necessárias? (pagamento, mapas, etc.)

User: 1. Todos os três tipos
2. Cliente: buscar, pedir, acompanhar. Restaurante: cardápio, pedidos. 
   Entregador: rotas, entregas
3. Mobile primeiro, web admin
4. Stripe, Google Maps, notificações push

Claude: Perfeito! Mais alguns detalhes...
[continua o diálogo iterativo]
```

---

### `/create-prd`
**Descrição**: Cria Product Requirements Document interativo (forma completa)

**Uso**:
```bash
/create-prd
```

**Processo Interativo**:
1. Nome e descrição do projeto
2. Objetivos principais
3. Funcionalidades essenciais
4. Requisitos técnicos
5. Restrições e considerações

**Resultado**: Arquivo `.taskmaster/docs/prd.txt`

**Diferença do `/prd`**: Este comando segue um formulário estruturado, enquanto `/prd` é mais conversacional e flexível.

---

### `/update-prd`
**Descrição**: Atualiza PRD existente e propaga mudanças

**Uso**:
```bash
/update-prd "Adicionar autenticação OAuth"
/update-prd --file custom-prd.txt
```

**Funcionalidades**:
- Rastreia mudanças
- Atualiza tarefas afetadas
- Mantém histórico de versões

---

### `/parse-prd`
**Descrição**: Converte PRD em tarefas estruturadas

**Uso**:
```bash
/parse-prd                      # PRD padrão
/parse-prd --num-tasks 20       # Especificar número
/parse-prd --research           # Com pesquisa aprofundada
```

**Opções**:
- `--append`: Adiciona às tarefas existentes
- `--force`: Sobrescreve tarefas existentes
- `--input [file]`: PRD customizado

## 🎯 Comandos de Desenvolvimento

### `/task-status`
**Descrição**: Dashboard completo do projeto

**Uso**:
```bash
/task-status              # Status geral
/task-status --metrics    # Com métricas detalhadas
```

**Informações Mostradas**:
- Progress bar de conclusão
- Distribuição por status
- Tarefas bloqueadas
- Próximas prioridades
- Métricas de velocidade

---

### `/next-task`
**Descrição**: Recomenda próxima tarefa baseada em prioridades

**Uso**:
```bash
/next-task                # Próxima tarefa
/next-task --complexity   # Com análise de complexidade
```

**Algoritmo Considera**:
- Dependências resolvidas
- Prioridade da tarefa
- Complexidade estimada
- Contexto atual

---

### `/complete-task [id]`
**Descrição**: Marca tarefa como concluída com validação

**Uso**:
```bash
/complete-task 5          # Completar tarefa 5
/complete-task 5.2        # Completar subtarefa
/complete-task 5,6,7      # Múltiplas tarefas
```

**Validações**:
- Verifica critérios de aceitação
- Atualiza dependências
- Sugere próxima tarefa

---

### `/quick-task "descrição"`
**Descrição**: Adiciona tarefa rápida ao backlog

**Uso**:
```bash
/quick-task "Corrigir bug no login"
/quick-task "Adicionar validação de email" --priority high
```

**Características**:
- Geração automática de ID
- Estimativa de complexidade
- Integração com contexto

## 🔍 Comandos de Análise

### `/complexity`
**Descrição**: Análise de complexidade do projeto

**Uso**:
```bash
/complexity               # Análise geral
/complexity --threshold 7 # Tarefas acima de 7
/complexity --ids 5,6,7   # Tarefas específicas
```

**Métricas**:
- Score de complexidade (1-10)
- Recomendações de divisão
- Identificação de riscos
- Sugestões de simplificação

---

### `/break-down [id]`
**Descrição**: Divide tarefa complexa em subtarefas

**Uso**:
```bash
/break-down 15           # Dividir tarefa 15
/break-down 15 --num 5   # Em 5 subtarefas
/break-down 15 --research # Com pesquisa técnica
```

**Processo**:
- Análise da tarefa
- Identificação de componentes
- Criação de subtarefas lógicas
- Definição de dependências

---

### `/research [id|topic]`
**Descrição**: Pesquisa técnica com IA

**Uso**:
```bash
/research 23              # Pesquisar sobre tarefa 23
/research "Docker setup"  # Pesquisar tópico
/research 23 --save       # Salvar em documentação
```

**Recursos**:
- Busca em documentações
- Melhores práticas
- Exemplos de código
- Considerações de segurança

## 🔧 Comandos de Gestão

### `/add-task`
**Descrição**: Adiciona tarefa com IA

**Uso**:
```bash
/add-task --prompt "Sistema de notificações"
/add-task --manual        # Modo manual
```

**Campos Manuais**:
- `--title`: Título da tarefa
- `--description`: Descrição detalhada
- `--priority`: high/medium/low
- `--dependencies`: IDs separados por vírgula

---

### `/update-task [id]`
**Descrição**: Atualiza informações da tarefa

**Uso**:
```bash
/update-task 15 --prompt "Adicionar cache Redis"
/update-task 15 --append  # Adicionar informações
```

---

### `/remove-task [id]`
**Descrição**: Remove tarefa do projeto

**Uso**:
```bash
/remove-task 15          # Remove tarefa 15
/remove-task 15 --confirm # Sem confirmação
```

---

### `/move-task [from] [to]`
**Descrição**: Reordena tarefas

**Uso**:
```bash
/move-task 15 3          # Move 15 para posição 3
/move-task 15.2 16       # Subtarefa para outra tarefa
```

---

### `/add-dependency`
**Descrição**: Adiciona dependência entre tarefas

**Uso**:
```bash
/add-dependency --id 15 --depends-on 14
```

---

### `/validate-dependencies`
**Descrição**: Verifica integridade das dependências

**Uso**:
```bash
/validate-dependencies    # Verificar todas
/fix-dependencies        # Corrigir problemas
```

## 📊 Comandos de Tags

### `/list-tags`
**Descrição**: Lista todas as tags disponíveis

**Uso**:
```bash
/list-tags               # Listar tags
/list-tags --metadata    # Com metadados
```

---

### `/add-tag [name]`
**Descrição**: Cria nova tag para organização

**Uso**:
```bash
/add-tag feature-auth    # Nova tag
/add-tag sprint-1 --copy-from-current
```

---

### `/use-tag [name]`
**Descrição**: Muda para contexto de tag

**Uso**:
```bash
/use-tag feature-auth    # Mudar contexto
/use-tag main           # Voltar ao principal
```

## 📖 Referência Rápida

### Comandos Essenciais
```bash
# Setup inicial
/project-setup
/prd "descrição do projeto"    # Criação rápida de PRD
/create-prd                    # Criação estruturada de PRD
/parse-prd

# Workflow diário
/task-status
/next-task
/complete-task [id]

# Gestão
/quick-task "descrição"
/complexity
/break-down [id]
```

### Atalhos Úteis
```bash
/ts     → /task-status
/nt     → /next-task
/ct     → /complete-task
/qt     → /quick-task
```

### Fluxo Típico
```mermaid
graph LR
    A[/project-setup] --> B[/create-prd]
    B --> C[/parse-prd]
    C --> D[/task-status]
    D --> E[/next-task]
    E --> F[Implementar]
    F --> G[/complete-task]
    G --> E
```

## 💡 Dicas Avançadas

### Combinando Comandos
```bash
# Análise completa antes de sprint
/complexity && /task-status --metrics

# Preparar próxima feature
/add-tag feature-x && /use-tag feature-x && /quick-task "Setup inicial"
```

### Automação com Aliases
```bash
# No seu ~/.bashrc
alias tm-start="claude /project-setup && claude /create-prd"
alias tm-work="claude /next-task"
alias tm-done="claude /complete-task"
```

### Integração com Git
```bash
# Pre-commit hook
claude /task-status --check-incomplete

# Post-merge
claude /update-prd --from-git
```

---

**Próximo**: Veja [Exemplos de Workflows](../examples/WORKFLOWS.md) para casos de uso completos.