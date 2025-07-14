# Instalação do Claudia no WSL (Windows Subsystem for Linux)

Este guia fornece instruções detalhadas para instalar e configurar o [Claudia](https://github.com/getAsterisk/claudia) - uma GUI poderosa para o Claude Code - no Windows Subsystem for Linux (WSL).

## 📋 Pré-requisitos

### Sistema Operacional
- Windows 10/11 com WSL2 instalado
- Ubuntu 20.04+ no WSL (testado com Ubuntu 24.04 LTS)
- WSLg habilitado (Windows 11) ou servidor X11 configurado
- Mínimo 4GB RAM (8GB recomendado)
- 2GB de espaço em disco livre

### Software Necessário
- Claude Code CLI instalado e configurado
- Acesso ao terminal WSL

## 🚀 Instalação Rápida

Execute o script de instalação automatizada:

```bash
# Clone este repositório
git clone https://github.com/[seu-usuario]/claude-mcp-config.git
cd claude-mcp-config

# Execute o script de instalação
chmod +x scripts/install-claudia-wsl.sh
./scripts/install-claudia-wsl.sh
```

## 📝 Instalação Manual Passo a Passo

### 1. Verificar Dependências Já Instaladas

Antes de instalar, verifique o que já está disponível:

```bash
# Verificar Rust
rustc --version

# Verificar Git
git --version

# Verificar dependências de sistema
dpkg -l | grep -E "(libwebkit2gtk|libgtk-3|build-essential)"
```

### 2. Instalar Dependências do Sistema

```bash
sudo apt update
sudo apt install -y \
  libwebkit2gtk-4.1-dev \
  libgtk-3-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev \
  patchelf \
  build-essential \
  curl \
  wget \
  file \
  libssl-dev \
  libxdo-dev \
  libsoup-3.0-dev \
  libjavascriptcoregtk-4.1-dev \
  git
```

### 3. Instalar Rust (se necessário)

```bash
# Instalar Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Carregar variáveis de ambiente
source ~/.cargo/env

# Verificar instalação
rustc --version
```

### 4. Instalar Bun

```bash
# Instalar Bun
curl -fsSL https://bun.sh/install | bash

# Carregar variáveis de ambiente
source ~/.bashrc

# Verificar instalação
~/.bun/bin/bun --version
```

### 5. Configurar PATH para Bun

```bash
# Adicionar Bun ao PATH permanentemente
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 6. Clonar o Repositório do Claudia

```bash
# Clonar o repositório
git clone https://github.com/getAsterisk/claudia.git
cd claudia
```

### 7. Instalar Dependências do Frontend

```bash
# Instalar dependências com Bun
bun install
```

### 8. Compilar o Claudia

#### Opção A: Modo Desenvolvimento (Recomendado para primeiro teste)
```bash
bun run tauri dev
```

#### Opção B: Build de Produção
```bash
bun run tauri build
```

## 🖥️ Configuração de Display no WSL

### WSLg (Windows 11)
O WSLg já vem configurado por padrão no Windows 11. Não é necessária configuração adicional.

### X11 Server (Windows 10)

1. **Instale um servidor X11**:
   - [VcXsrv](https://sourceforge.net/projects/vcxsrv/) (Gratuito)
   - [X410](https://x410.dev/) (Pago)
   - [MobaXterm](https://mobaxterm.mobatek.net/) (Gratuito com versão Pro)

2. **Configure o servidor X11**:
   - Inicie o servidor com as opções:
     - Multiple windows
     - Display number: 0
     - Start no client
     - Disable access control

3. **Configure as variáveis de ambiente no WSL**:
```bash
echo 'export DISPLAY=:0.0' >> ~/.bashrc
echo 'export LIBGL_ALWAYS_INDIRECT=1' >> ~/.bashrc
source ~/.bashrc
```

4. **Teste a configuração**:
```bash
# Instalar aplicativos de teste
sudo apt install x11-apps

# Testar
xclock
# ou
xeyes
```

## 🏃 Executando o Claudia

### Modo Desenvolvimento
```bash
cd ~/claudia
bun run tauri dev
```

### Executável Compilado
```bash
# Após compilar com 'bun run tauri build'
./claudia/src-tauri/target/release/claudia
```

### Criar Atalho
```bash
# Criar alias para facilitar execução
echo 'alias claudia="cd ~/claudia && bun run tauri dev"' >> ~/.bashrc
echo 'alias claudia-exe="~/claudia/src-tauri/target/release/claudia"' >> ~/.bashrc
source ~/.bashrc
```

## 🐛 Solução de Problemas Comuns

### Erro: "bun: command not found"
```bash
# Solução temporária
export PATH="$HOME/.bun/bin:$PATH"

# Solução permanente
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Erro: "cannot open display"
```bash
# Verificar variável DISPLAY
echo $DISPLAY

# Se vazio, configurar
export DISPLAY=:0.0

# Testar
xclock
```

### Erro: "webkit2gtk not found"
```bash
# Reinstalar dependências
sudo apt update
sudo apt install --reinstall libwebkit2gtk-4.1-dev
```

### Compilação muito lenta
1. **Use modo desenvolvimento para testes**:
   ```bash
   bun run tauri dev
   ```

2. **Aumente recursos do WSL**:
   Crie/edite `%USERPROFILE%\.wslconfig`:
   ```ini
   [wsl2]
   memory=8GB
   processors=4
   swap=2GB
   ```

3. **Reinicie o WSL**:
   ```powershell
   wsl --shutdown
   ```

### Erro de permissão ao executar
```bash
chmod +x ~/claudia/src-tauri/target/release/claudia
```

### Processo de build interrompido
```bash
# Limpar cache e reconstruir
cd ~/claudia
rm -rf target
rm -rf node_modules
bun install
bun run tauri build
```

## 📁 Estrutura de Arquivos Após Instalação

```
~/
├── claudia/                    # Código fonte do Claudia
│   ├── src/                    # Frontend React
│   ├── src-tauri/              # Backend Rust
│   ├── target/                 # Arquivos compilados
│   │   └── release/           
│   │       ├── claudia         # Executável principal
│   │       └── bundle/         # Instaladores
│   └── node_modules/           # Dependências Node
├── .bun/                       # Instalação do Bun
│   └── bin/                    # Executáveis do Bun
└── .cargo/                     # Instalação do Rust
    └── bin/                    # Ferramentas Rust
```

## 🔄 Atualizando o Claudia

```bash
cd ~/claudia
git pull origin main
bun install
bun run tauri build
```

## 💡 Dicas de Otimização

### 1. Performance
```bash
# Compilar com otimizações máximas
bun run tauri build --release

# Usar menos threads se a memória for limitada
cargo build -j 2
```

### 2. Desenvolvimento
```bash
# Hot reload para desenvolvimento
bun run tauri dev

# Logs detalhados
RUST_LOG=debug bun run tauri dev
```

### 3. Integração com VS Code
```bash
# Instalar extensão Remote-WSL
code --install-extension ms-vscode-remote.remote-wsl

# Abrir projeto no VS Code
cd ~/claudia
code .
```

## 📊 Recursos de Sistema

### Requisitos Mínimos
- CPU: 2 cores
- RAM: 4GB
- Disco: 2GB livres

### Recomendado
- CPU: 4+ cores
- RAM: 8GB+
- Disco: 5GB livres
- GPU: Aceleração de hardware ajuda na performance

## 🔍 Verificação de Instalação

Execute este script para verificar se tudo está instalado corretamente:

```bash
#!/bin/bash
echo "=== Verificando Instalação do Claudia ==="
echo

# Verificar Rust
echo -n "Rust: "
if command -v rustc &> /dev/null; then
    rustc --version
else
    echo "❌ Não instalado"
fi

# Verificar Bun
echo -n "Bun: "
if [ -f ~/.bun/bin/bun ]; then
    ~/.bun/bin/bun --version
else
    echo "❌ Não instalado"
fi

# Verificar Git
echo -n "Git: "
if command -v git &> /dev/null; then
    git --version
else
    echo "❌ Não instalado"
fi

# Verificar Claude Code
echo -n "Claude Code: "
if command -v claude &> /dev/null; then
    claude --version
else
    echo "❌ Não instalado"
fi

# Verificar Claudia
echo -n "Claudia: "
if [ -d ~/claudia ]; then
    echo "✅ Diretório existe"
    if [ -f ~/claudia/src-tauri/target/release/claudia ]; then
        echo "  ✅ Executável compilado encontrado"
    else
        echo "  ⚠️  Executável não compilado ainda"
    fi
else
    echo "❌ Não clonado"
fi

# Verificar Display
echo -n "Display: "
if [ -n "$DISPLAY" ]; then
    echo "✅ Configurado como $DISPLAY"
else
    echo "❌ Não configurado"
fi
```

## 🤝 Contribuindo

Encontrou um problema ou tem sugestões para melhorar este guia?

1. Abra uma issue neste repositório
2. Ou contribua com melhorias via Pull Request

## 📚 Recursos Adicionais

- [Documentação oficial do Claudia](https://claudiacode.com)
- [Tauri Documentation](https://tauri.app)
- [WSL Documentation](https://docs.microsoft.com/windows/wsl/)
- [WSLg Documentation](https://github.com/microsoft/wslg)
- [Claude Code](https://claude.ai/code)

## 📄 Notas de Versão

- **Testado em**: WSL2 com Ubuntu 24.04 LTS
- **Data**: Janeiro 2025
- **Versão do Claudia**: Latest (main branch)

---

**Problemas?** Abra uma issue com os logs de erro e informações do sistema.