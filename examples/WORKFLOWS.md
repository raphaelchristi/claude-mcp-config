# Exemplos de Workflows com Claude Code + MCPs

## 📋 Índice
1. [Novo Projeto do Zero](#novo-projeto-do-zero)
2. [Desenvolvimento de Feature](#desenvolvimento-de-feature)
3. [Debugging com Context7](#debugging-com-context7)
4. [Refatoração Guiada](#refatoração-guiada)
5. [Sprint Planning](#sprint-planning)
6. [Workflows Avançados](#workflows-avançados)

## 🚀 Novo Projeto do Zero

### Cenário: E-commerce com Next.js

```bash
# 1. Iniciar Claude Code
claude

# 2. Setup inicial
/project-setup

# 3. Criar PRD interativo
/create-prd
```

**Exemplo de diálogo PRD**:
```
Claude: Qual o nome do projeto?
> NextCommerce

Claude: Descreva o projeto em 2-3 frases:
> Plataforma de e-commerce moderna com Next.js 14, 
> incluindo catálogo de produtos, carrinho e checkout.

Claude: Quais as principais funcionalidades?
> 1. Catálogo com filtros
> 2. Carrinho persistente
> 3. Checkout com Stripe
> 4. Admin dashboard
> 5. Sistema de reviews
```

```bash
# 4. Gerar tarefas do PRD
/parse-prd --num-tasks 15 --research

# 5. Analisar complexidade
/complexity

# Output esperado:
📊 Análise de Complexidade:
- Setup Next.js + TypeScript: ⭐⭐ (2/10)
- Integração Stripe: ⭐⭐⭐⭐⭐⭐⭐ (7/10) ⚠️
- Dashboard Admin: ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10) ⚠️
```

```bash
# 6. Quebrar tarefas complexas
/break-down 3  # Stripe
/break-down 8  # Dashboard

# 7. Começar desenvolvimento
/next-task

# Claude sugere: "Setup inicial do Next.js com TypeScript"
```

**Implementação com Context7**:
```bash
# Pesquisar documentação atualizada
"Como configurar Next.js 14 com TypeScript e Tailwind? use context7"

# Após implementar
/complete-task 1

# Próxima tarefa
/next-task
```

## 💡 Desenvolvimento de Feature

### Cenário: Sistema de Autenticação

```bash
# 1. Criar tag para a feature
/add-tag auth-system
/use-tag auth-system

# 2. Adicionar tarefas relacionadas
/quick-task "Setup NextAuth.js com providers OAuth"
/quick-task "Criar páginas de login/registro"
/quick-task "Implementar middleware de proteção de rotas"
/quick-task "Adicionar refresh tokens"

# 3. Ver status específico da feature
/task-status

# 4. Pesquisar best practices
/research "NextAuth.js OAuth implementation"
```

**Desenvolvimento iterativo**:
```bash
# Trabalhando na primeira tarefa
/next-task

# Dúvida específica
"Como configurar Google OAuth no NextAuth.js? use context7"

# Claude retorna documentação atualizada...

# Implementar e testar
/complete-task 1

# Problema encontrado
/update-task 2 --append "Descobri que precisa configurar CORS primeiro"

# Adicionar subtarefa
/add-subtask --id 2 --title "Configurar CORS no backend"
```

## 🐛 Debugging com Context7

### Cenário: Erro no React Hook

**Problema**: `Invalid hook call` em produção

```bash
# 1. Buscar documentação específica
"React Invalid hook call error causes and solutions use context7"

# 2. Verificar versão específica
"React 18 hooks rules and common mistakes use context7"

# 3. Comparar implementações
"useEffect vs useLayoutEffect performance React 18 use context7"
```

**Workflow de debugging**:
```bash
# Criar tarefa para o bug
/quick-task "Fix: Invalid hook call in ProductCard component" --priority high

# Pesquisar padrões
/research "React hooks debugging strategies"

# Após resolver
/complete-task 15
/update-task 15 --append "Solução: Hook estava sendo chamado condicionalmente"
```

## 🔨 Refatoração Guiada

### Cenário: Migração de JavaScript para TypeScript

```bash
# 1. Planejar refatoração
/create-prd
> Migração completa do projeto para TypeScript
> Manter funcionalidade, adicionar type safety

# 2. Gerar plano de migração
/parse-prd --num-tasks 20

# 3. Análise de impacto
/complexity --threshold 5

# 4. Estratégia por módulos
/add-tag ts-migration-phase1
/use-tag ts-migration-phase1

# 5. Migrar incrementalmente
/next-task
```

**Exemplo de migração**:
```bash
# Buscar patterns TypeScript
"TypeScript migration strategies for React components use context7"

# Configurar ambiente
"tsconfig.json best practices for React projects use context7"

# Tipos para bibliotecas
"How to add types for JavaScript libraries TypeScript use context7"
```

## 📅 Sprint Planning

### Cenário: Planning de 2 semanas

```bash
# 1. Criar tag para sprint
/add-tag sprint-15
/use-tag sprint-15

# 2. Análise de capacidade
/task-status --metrics

Output:
📊 Métricas do Projeto:
- Velocidade média: 8 tarefas/semana
- Complexidade média concluída: 4.5
- Taxa de conclusão: 85%

# 3. Selecionar tarefas para sprint
/complexity --threshold 6  # Ver tarefas médias

# 4. Estimar esforço
/research "Story points estimation for e-commerce features"

# 5. Definir metas
/quick-task "SPRINT GOAL: Implementar fluxo completo de checkout"
```

**Acompanhamento diário**:
```bash
# Daily standup
/task-status

# Bloqueios
/task-status --filter blocked

# Progresso individual
/complete-task 23
/next-task
```

## 🎯 Workflows Avançados

### 1. Integração Contínua com Tarefas

```bash
# Hook pre-commit
#!/bin/bash
# .git/hooks/pre-commit

# Verificar tarefas incompletas
claude /task-status --check-wip

# Se houver WIP, avisar
if [ $? -ne 0 ]; then
  echo "⚠️  Tarefas em progresso detectadas"
  claude /task-status --filter in-progress
fi
```

### 2. Review Automatizado

```bash
# Após PR merge
/complete-task $(git log -1 --pretty=%B | grep -oP 'task-\K\d+')

# Atualizar PRD com mudanças
/update-prd --from-git

# Planejar próximas tarefas
/complexity --affected-by-last-change
```

### 3. Documentação Automática

```bash
# Gerar docs de tarefas concluídas
/task-status --completed --export-docs > docs/completed-features.md

# Criar changelog
/task-status --completed --since "2 weeks ago" --format changelog
```

### 4. Multi-Feature Development

```bash
# Trabalhar em paralelo
/add-tag feature-payments
/add-tag feature-analytics
/add-tag bugfixes

# Alternar contextos
/use-tag feature-payments
/next-task
# ... trabalhar ...

/use-tag bugfixes
/quick-task "Fix: Memory leak in cart updates"
/next-task
```

### 5. Template de Projeto

```bash
# Criar template reutilizável
cat > project-template.sh << 'EOF'
#!/bin/bash
claude /project-setup --rules cursor,claude
claude /create-prd --template saas
claude /parse-prd --num-tasks 25 --research
claude /complexity
claude /add-tag mvp
claude /use-tag mvp
EOF

# Usar em novo projeto
chmod +x project-template.sh
./project-template.sh
```

## 📊 Métricas e Relatórios

### Relatório Semanal
```bash
# Gerar relatório
/task-status --metrics --format report > weekly-report.md

# Análise de produtividade
/complexity --completed --last-week

# Identificar gargalos
/task-status --average-time-per-complexity
```

### Dashboard Customizado
```bash
#!/bin/bash
# dashboard.sh

echo "🎯 Project Dashboard"
echo "=================="

# Status geral
claude /task-status --summary

# Próximas prioridades
echo -e "\n📌 Próximas 3 tarefas:"
claude /next-task --count 3

# Riscos
echo -e "\n⚠️  Tarefas complexas:"
claude /complexity --threshold 7 --pending
```

## 🔄 Ciclo Completo de Desenvolvimento

```mermaid
graph TD
    A[Ideia] --> B[/create-prd]
    B --> C[/parse-prd]
    C --> D[/complexity]
    D --> E{Complexo?}
    E -->|Sim| F[/break-down]
    E -->|Não| G[/next-task]
    F --> G
    G --> H[Context7 Research]
    H --> I[Implementar]
    I --> J[/complete-task]
    J --> K{Mais tarefas?}
    K -->|Sim| G
    K -->|Não| L[/task-status --final]
```

---

**Dica Final**: Combine o poder do Context7 para documentação atualizada com o TaskMaster para gestão inteligente. Juntos, eles transformam seu workflow de desenvolvimento! 🚀