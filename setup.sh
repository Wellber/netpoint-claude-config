#!/usr/bin/env bash
# =============================================================================
# Netpoint / Defensys — Claude Code Team Setup
# Configura o ambiente de desenvolvimento com Claude Code para novos membros
# Uso: bash setup-claude-team.sh
# =============================================================================

set -e

VERDE='\033[0;32m'
AMARELO='\033[1;33m'
AZUL='\033[0;34m'
VERMELHO='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${VERDE}✅ $1${NC}"; }
info() { echo -e "${AZUL}ℹ️  $1${NC}"; }
warn() { echo -e "${AMARELO}⚠️  $1${NC}"; }
erro() { echo -e "${VERMELHO}❌ $1${NC}"; exit 1; }

echo ""
echo -e "${AZUL}================================================${NC}"
echo -e "${AZUL}  Netpoint/Defensys — Claude Code Team Setup   ${NC}"
echo -e "${AZUL}================================================${NC}"
echo ""

# ─────────────────────────────────────────────
# 1. Verificar pré-requisitos
# ─────────────────────────────────────────────
info "Verificando pré-requisitos..."

command -v node  >/dev/null 2>&1 || erro "Node.js não encontrado. Instale via https://nodejs.org"
command -v npm   >/dev/null 2>&1 || erro "npm não encontrado."
command -v git   >/dev/null 2>&1 || erro "git não encontrado."
command -v claude >/dev/null 2>&1 || erro "Claude Code não instalado. Execute: npm install -g @anthropic-ai/claude-code"

NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
[ "$NODE_VERSION" -lt 18 ] && erro "Node.js 18+ necessário. Versão atual: $(node -v)"

ok "Pré-requisitos OK (Node $(node -v), Claude Code $(claude --version))"

# ─────────────────────────────────────────────
# 2. Detectar SO e package manager
# ─────────────────────────────────────────────
OS="$(uname -s)"
info "Sistema: $OS"

install_pkg() {
  if [ "$OS" = "Darwin" ]; then
    command -v brew >/dev/null 2>&1 && brew install "$1" || warn "Homebrew não encontrado, instale $1 manualmente"
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y "$1"
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y "$1"
  else
    warn "Instale $1 manualmente"
  fi
}

# ─────────────────────────────────────────────
# 3. Instalar LSP binários (code intelligence)
# ─────────────────────────────────────────────
info "Instalando LSP servers para code intelligence..."

# TypeScript/JavaScript
if ! command -v typescript-language-server >/dev/null 2>&1; then
  npm install -g typescript typescript-language-server
  ok "typescript-language-server instalado"
else
  ok "typescript-language-server já presente"
fi

# Go
if command -v go >/dev/null 2>&1; then
  if ! command -v gopls >/dev/null 2>&1; then
    go install golang.org/x/tools/gopls@latest
    ok "gopls instalado"
  else
    ok "gopls já presente"
  fi
else
  warn "Go não encontrado, pulando gopls"
fi

# .NET / C# (necessário para EadxPro)
if command -v dotnet >/dev/null 2>&1; then
  if ! command -v csharp-ls >/dev/null 2>&1; then
    dotnet tool install -g csharp-ls --version 0.17.0 2>/dev/null || \
    dotnet tool update -g csharp-ls 2>/dev/null || true
    ok "csharp-ls instalado"
    # Garantir .dotnet/tools no PATH
    if ! echo "$PATH" | grep -q ".dotnet/tools"; then
      echo 'export PATH="$PATH:$HOME/.dotnet/tools"' >> ~/.zprofile 2>/dev/null || \
      echo 'export PATH="$PATH:$HOME/.dotnet/tools"' >> ~/.bashrc
      warn ".dotnet/tools adicionado ao PATH — reinicie o terminal"
    fi
  else
    ok "csharp-ls já presente"
  fi
else
  warn ".NET não encontrado, pulando csharp-ls"
fi

# Rust
if command -v rustup >/dev/null 2>&1; then
  if ! command -v rust-analyzer >/dev/null 2>&1; then
    source "$HOME/.cargo/env" 2>/dev/null || true
    rustup component add rust-analyzer
    ok "rust-analyzer instalado"
    if ! echo "$PATH" | grep -q ".cargo/bin"; then
      echo '. "$HOME/.cargo/env"' >> ~/.zprofile 2>/dev/null || \
      echo '. "$HOME/.cargo/env"' >> ~/.bashrc
    fi
  else
    ok "rust-analyzer já presente"
  fi
else
  warn "Rust/rustup não encontrado, pulando rust-analyzer"
fi

# Python
if ! command -v pyright-langserver >/dev/null 2>&1 && ! command -v pyright >/dev/null 2>&1; then
  npm install -g pyright 2>/dev/null || warn "Falha ao instalar pyright"
  ok "pyright instalado"
else
  ok "pyright já presente"
fi

# ─────────────────────────────────────────────
# 4. Instalar uvx (necessário para MCP servers AWS)
# ─────────────────────────────────────────────
if ! command -v uvx >/dev/null 2>&1; then
  info "Instalando uv/uvx..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  source "$HOME/.cargo/env" 2>/dev/null || true
  ok "uvx instalado"
else
  ok "uvx já presente"
fi

# ─────────────────────────────────────────────
# 5. Criar estrutura ~/.claude
# ─────────────────────────────────────────────
info "Configurando ~/.claude..."
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/skills/skills
mkdir -p ~/.gsd

# ─────────────────────────────────────────────
# 6. Instalar GSD (Get Shit Done)
# ─────────────────────────────────────────────
info "Instalando GSD workflow system..."

if [ ! -f ~/.claude/get-shit-done/VERSION ]; then
  # Tentar instalar via npm se disponível no registry da empresa
  # ou clonar do repo interno
  warn "GSD não encontrado. Instale manualmente conforme documentação interna."
  warn "Ou copie de uma máquina que já tem: rsync -av DEV_MACHINE:~/.claude/get-shit-done/ ~/.claude/get-shit-done/"
else
  GSD_VERSION=$(cat ~/.claude/get-shit-done/VERSION)
  ok "GSD v$GSD_VERSION já instalado"
fi

# Configurar defaults do GSD
cat > ~/.gsd/defaults.json << 'GSDEOF'
{
  "mode": "yolo",
  "granularity": "standard",
  "parallelization": true,
  "commit_docs": true,
  "model_profile": "balanced",
  "resolve_model_ids": "omit",
  "workflow": {
    "research": true,
    "research_before_questions": false,
    "plan_check": true,
    "verifier": true,
    "nyquist_validation": true,
    "auto_advance": true
  }
}
GSDEOF
ok "GSD defaults configurados"

# ─────────────────────────────────────────────
# 7. Instalar skills Antigravity (se não existir)
# ─────────────────────────────────────────────
SKILLS_COUNT=$(ls ~/.claude/skills/skills/ 2>/dev/null | wc -l)
if [ "$SKILLS_COUNT" -lt 100 ]; then
  info "Instalando Antigravity skills..."
  mkdir -p ~/.claude/skills
  cd ~/.claude/skills
  npm install antigravity-awesome-skills@latest 2>/dev/null || warn "Falha no npm, tentando via npx..."
  npx antigravity-awesome-skills --claude 2>/dev/null || true
  ok "Skills instaladas"
else
  ok "Skills já instaladas ($SKILLS_COUNT skills)"
fi

# ─────────────────────────────────────────────
# 8. Instalar skills de CyberSecurity
# ─────────────────────────────────────────────
CYBERSEC_CHECK=$(ls ~/.claude/skills/skills/ 2>/dev/null | grep "^acquiring-disk" | wc -l)
if [ "$CYBERSEC_CHECK" -eq 0 ]; then
  info "Instalando CyberSecurity skills..."
  TMPDIR=$(mktemp -d)
  git clone --depth=1 https://github.com/mukul975/anthropic-cybersecurity-skills.git "$TMPDIR/cybersec" 2>/dev/null
  cp -r "$TMPDIR/cybersec/skills/"* ~/.claude/skills/skills/ 2>/dev/null || true
  rm -rf "$TMPDIR"
  ok "CyberSecurity skills instaladas"
else
  ok "CyberSecurity skills já instaladas"
fi

# ─────────────────────────────────────────────
# 9. Criar agents do time
# ─────────────────────────────────────────────
info "Instalando agents do time..."

AGENTS_REPO="https://raw.githubusercontent.com/netpoint-dev/claude-team-config/main/agents"

# Por enquanto copiar do template local se existir, ou criar placeholder
for agent in cybersecurity-pentest owasp-auditor qa-engineer; do
  if [ ! -f ~/.claude/agents/$agent.md ]; then
    warn "Agent $agent não encontrado — copie de uma máquina configurada ou do repo do time"
  else
    ok "Agent $agent presente"
  fi
done

# ─────────────────────────────────────────────
# 10. Criar ~/.mcp.json global
# ─────────────────────────────────────────────
info "Configurando ~/.mcp.json global..."

if [ ! -f ~/.mcp.json ]; then
  cat > ~/.mcp.json << 'MCPEOF'
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    },
    "docker": {
      "command": "docker",
      "args": ["mcp", "gateway", "run"]
    }
  }
}
MCPEOF
  ok "~/.mcp.json criado"
else
  ok "~/.mcp.json já existe"
fi

# ─────────────────────────────────────────────
# 11. Criar CLAUDE.md pessoal (template)
# ─────────────────────────────────────────────
if [ ! -f ~/.claude/CLAUDE.md ]; then
  info "Criando CLAUDE.md pessoal (template)..."
  cat > ~/.claude/CLAUDE.md << 'MDEOF'
# CLAUDE.md — Pessoal

## Desenvolvedor
- **Nome:** [SEU NOME]
- **Email:** [SEU EMAIL]
- **Time:** Netpoint / Defensys

## Empresa
- **Netpoint:** hospedagem, EAD (EadxPro), infraestrutura cloud AWS
- **Defensys:** segurança, telecom, filtro-dns, WorldWifi

## Stack principal
- [liste suas linguagens principais]

## Regras obrigatórias
1. Sempre propor antes de executar comandos destrutivos em produção
2. Backup de qualquer arquivo antes de editar em servidor
3. Registrar comandos em `/root/$(hostname).log` nos servidores Linux
4. Usar ssh-manager para acesso SSH — nunca direto quando disponível
5. Idioma: português em documentação e commits

## Projetos ativos
- [liste seus projetos]

> Edite este arquivo com seu contexto específico.
> Consulte o CLAUDE.md do projeto para contexto técnico detalhado.
MDEOF
  warn "CLAUDE.md pessoal criado em ~/.claude/CLAUDE.md — edite com seu contexto"
else
  ok "~/.claude/CLAUDE.md já existe"
fi

# ─────────────────────────────────────────────
# 12. Configurar ~/.claude/settings.json base
# ─────────────────────────────────────────────
if [ ! -f ~/.claude/settings.json ]; then
  cat > ~/.claude/settings.json << 'SETTEOF'
{
  "permissions": {
    "defaultMode": "auto"
  },
  "model": "sonnet",
  "skipDangerousModePermissionPrompt": true
}
SETTEOF
  ok "~/.claude/settings.json criado"
else
  ok "~/.claude/settings.json já existe"
fi

# ─────────────────────────────────────────────
# Resumo
# ─────────────────────────────────────────────
echo ""
echo -e "${VERDE}================================================${NC}"
echo -e "${VERDE}  Setup concluído!                             ${NC}"
echo -e "${VERDE}================================================${NC}"
echo ""
echo "Próximos passos:"
echo "  1. Edite ~/.claude/CLAUDE.md com seu contexto pessoal"
echo "  2. Execute 'claude' e faça login: claude auth login"
echo "  3. Reinicie o terminal para garantir que o PATH está atualizado"
echo "  4. Em cada projeto, os arquivos CLAUDE.md, .mcp.json e .claude/ já estão configurados"
echo ""
echo "Recursos do time:"
echo "  Skills:  ~/.claude/skills/skills/ ($(ls ~/.claude/skills/skills/ 2>/dev/null | wc -l) skills)"
echo "  Agents:  ~/.claude/agents/ ($(ls ~/.claude/agents/*.md 2>/dev/null | wc -l) agents)"
echo "  GSD:     /gsd:new-project, /gsd:autonomous, /gsd:progress"
echo ""
echo "Documentação: CLAUDE.md em cada projeto"
echo ""
