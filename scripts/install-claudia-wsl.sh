#!/bin/bash

# Script de instalação do Claudia para WSL
# Este script automatiza a instalação completa do Claudia no Windows Subsystem for Linux

set -e  # Sair em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir com cores
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════╗"
echo "║       Claudia WSL Installation Script         ║"
echo "║         GUI for Claude Code on WSL            ║"
echo "╚═══════════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar se está rodando no WSL
if ! grep -q microsoft /proc/version; then
    print_error "Este script deve ser executado no WSL!"
    exit 1
fi

print_info "Verificando pré-requisitos..."

# Verificar Claude Code
if ! command -v claude &> /dev/null; then
    print_error "Claude Code não está instalado!"
    print_info "Por favor, instale o Claude Code primeiro: https://claude.ai/code"
    exit 1
else
    print_success "Claude Code encontrado: $(claude --version)"
fi

# Verificar e instalar dependências do sistema
print_info "Verificando dependências do sistema..."

DEPS_TO_INSTALL=""

# Lista de dependências necessárias
REQUIRED_DEPS=(
    "libwebkit2gtk-4.1-dev"
    "libgtk-3-dev"
    "libayatana-appindicator3-dev"
    "librsvg2-dev"
    "patchelf"
    "build-essential"
    "curl"
    "wget"
    "file"
    "libssl-dev"
    "libxdo-dev"
    "libsoup-3.0-dev"
    "libjavascriptcoregtk-4.1-dev"
    "git"
)

# Verificar cada dependência
for dep in "${REQUIRED_DEPS[@]}"; do
    if ! dpkg -l | grep -q "^ii  $dep"; then
        DEPS_TO_INSTALL="$DEPS_TO_INSTALL $dep"
    fi
done

if [ -n "$DEPS_TO_INSTALL" ]; then
    print_warning "Instalando dependências do sistema..."
    print_info "Você precisará inserir sua senha para sudo"
    sudo apt update
    sudo apt install -y $DEPS_TO_INSTALL
    print_success "Dependências do sistema instaladas"
else
    print_success "Todas as dependências do sistema já estão instaladas"
fi

# Verificar/Instalar Rust
if ! command -v rustc &> /dev/null; then
    print_warning "Rust não encontrado. Instalando..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    print_success "Rust instalado: $(rustc --version)"
else
    print_success "Rust já instalado: $(rustc --version)"
fi

# Verificar/Instalar Bun
if [ ! -f ~/.bun/bin/bun ]; then
    print_warning "Bun não encontrado. Instalando..."
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
    print_success "Bun instalado: $(~/.bun/bin/bun --version)"
    
    # Adicionar ao PATH permanentemente se não estiver
    if ! grep -q ".bun/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
        print_info "Bun adicionado ao PATH em ~/.bashrc"
    fi
else
    print_success "Bun já instalado: $(~/.bun/bin/bun --version)"
fi

# Garantir que Bun está no PATH
export PATH="$HOME/.bun/bin:$PATH"

# Verificar Git
if ! command -v git &> /dev/null; then
    print_error "Git não encontrado!"
    exit 1
else
    print_success "Git encontrado: $(git --version)"
fi

# Clonar Claudia se não existir
CLAUDIA_DIR="$HOME/claudia"

if [ -d "$CLAUDIA_DIR" ]; then
    print_info "Diretório Claudia já existe. Atualizando..."
    cd "$CLAUDIA_DIR"
    git pull origin main || print_warning "Não foi possível atualizar. Continuando com versão atual..."
else
    print_info "Clonando repositório do Claudia..."
    git clone https://github.com/getAsterisk/claudia.git "$CLAUDIA_DIR"
    cd "$CLAUDIA_DIR"
fi

print_success "Repositório Claudia pronto em: $CLAUDIA_DIR"

# Instalar dependências do frontend
print_info "Instalando dependências do frontend..."
cd "$CLAUDIA_DIR"
~/.bun/bin/bun install
print_success "Dependências do frontend instaladas"

# Verificar configuração de display
print_info "Verificando configuração de display..."

if [ -z "$DISPLAY" ]; then
    print_warning "Variável DISPLAY não configurada"
    
    # Detectar Windows 11 (WSLg)
    if command -v wslg.exe &> /dev/null; then
        print_info "WSLg detectado (Windows 11)"
        export DISPLAY=:0
    else
        print_info "Configurando para X11 Server (Windows 10)"
        export DISPLAY=:0.0
        export LIBGL_ALWAYS_INDIRECT=1
        
        # Adicionar ao .bashrc se não estiver
        if ! grep -q "export DISPLAY=" ~/.bashrc; then
            echo 'export DISPLAY=:0.0' >> ~/.bashrc
            echo 'export LIBGL_ALWAYS_INDIRECT=1' >> ~/.bashrc
            print_info "Variáveis de display adicionadas ao ~/.bashrc"
        fi
    fi
else
    print_success "Display configurado: $DISPLAY"
fi

# Opções de compilação
echo
print_info "Como você deseja prosseguir?"
echo "1) Executar em modo desenvolvimento (recomendado para primeiro teste)"
echo "2) Compilar versão de produção"
echo "3) Apenas verificar instalação"
echo

read -p "Escolha uma opção [1-3]: " choice

case $choice in
    1)
        print_info "Iniciando Claudia em modo desenvolvimento..."
        print_warning "Pressione Ctrl+C para parar"
        cd "$CLAUDIA_DIR"
        ~/.bun/bin/bun run tauri dev
        ;;
    2)
        print_info "Compilando Claudia para produção..."
        print_warning "Isso pode demorar 10-15 minutos na primeira vez"
        cd "$CLAUDIA_DIR"
        ~/.bun/bin/bun run tauri build
        
        if [ -f "$CLAUDIA_DIR/src-tauri/target/release/claudia" ]; then
            print_success "Claudia compilado com sucesso!"
            print_info "Executável disponível em: $CLAUDIA_DIR/src-tauri/target/release/claudia"
            
            # Criar link simbólico opcional
            read -p "Deseja criar um link em /usr/local/bin? (s/N): " create_link
            if [[ $create_link =~ ^[Ss]$ ]]; then
                sudo ln -sf "$CLAUDIA_DIR/src-tauri/target/release/claudia" /usr/local/bin/claudia
                print_success "Link criado. Você pode executar 'claudia' de qualquer lugar"
            fi
        else
            print_error "Falha na compilação"
            exit 1
        fi
        ;;
    3)
        print_info "Verificação de instalação:"
        echo
        echo -n "Rust: "
        rustc --version || echo "❌ Não instalado"
        
        echo -n "Bun: "
        ~/.bun/bin/bun --version || echo "❌ Não instalado"
        
        echo -n "Git: "
        git --version || echo "❌ Não instalado"
        
        echo -n "Claude Code: "
        claude --version || echo "❌ Não instalado"
        
        echo -n "Display: "
        if [ -n "$DISPLAY" ]; then
            echo "✅ $DISPLAY"
        else
            echo "❌ Não configurado"
        fi
        
        echo -n "Claudia: "
        if [ -d "$CLAUDIA_DIR" ]; then
            echo "✅ Clonado em $CLAUDIA_DIR"
            if [ -f "$CLAUDIA_DIR/src-tauri/target/release/claudia" ]; then
                echo "  ✅ Executável compilado"
            else
                echo "  ⚠️  Ainda não compilado"
            fi
        else
            echo "❌ Não encontrado"
        fi
        ;;
    *)
        print_error "Opção inválida"
        exit 1
        ;;
esac

echo
print_success "Script finalizado!"
print_info "Para mais informações, consulte: docs/CLAUDIA-WSL-INSTALLATION.md"

# Criar aliases úteis
if ! grep -q "alias claudia=" ~/.bashrc; then
    echo
    print_info "Deseja adicionar aliases úteis ao ~/.bashrc? (s/N)"
    read -p "> " add_aliases
    
    if [[ $add_aliases =~ ^[Ss]$ ]]; then
        echo "" >> ~/.bashrc
        echo "# Claudia aliases" >> ~/.bashrc
        echo "alias claudia-dev='cd $CLAUDIA_DIR && ~/.bun/bin/bun run tauri dev'" >> ~/.bashrc
        echo "alias claudia-build='cd $CLAUDIA_DIR && ~/.bun/bin/bun run tauri build'" >> ~/.bashrc
        
        if [ -f "$CLAUDIA_DIR/src-tauri/target/release/claudia" ]; then
            echo "alias claudia-run='$CLAUDIA_DIR/src-tauri/target/release/claudia'" >> ~/.bashrc
        fi
        
        print_success "Aliases adicionados. Execute 'source ~/.bashrc' para ativar"
    fi
fi