# Netpoint Claude Code — Team Configuration

> Configuração padrão de Claude Code para times Netpoint / Defensys.
> Execute o script de onboarding em uma máquina nova e clone os projetos — tudo está configurado automaticamente.

## O que este repositório contém

```
netpoint-claude-config/
├── setup.sh                    ← script de onboarding para máquina nova
├── agents/                     ← agents customizados do time
│   ├── cybersecurity-pentest.md
│   ├── owasp-auditor.md
│   └── qa-engineer.md
├── mcp/
│   └── mcp.json                ← template de ~/.mcp.json global
├── settings/
│   ├── settings-base.json      ← template ~/.claude/settings.json
│   ├── settings-dotnet.json    ← para projetos C#/.NET (EadxPro)
│   └── settings-python.json    ← para projetos Python (filtro-dns, WorldWifi)
└── claude-md/
    ├── CLAUDE-personal.md      ← template CLAUDE.md pessoal
    ├── CLAUDE-dotnet.md        ← template para projetos C#
    └── CLAUDE-python.md        ← template para projetos Python/FastAPI
```

## Setup rápido (máquina nova)

```bash
curl -fsSL https://raw.githubusercontent.com/wellbersantos/netpoint-claude-config/main/setup.sh | bash
```

Ou clone e execute:

```bash
git clone https://github.com/wellbersantos/netpoint-claude-config.git
cd netpoint-claude-config
bash setup.sh
```

## O que o setup instala

- **LSP servers** — code intelligence para C#, TypeScript, Go, Rust, Python
- **GSD defaults** — configuração padrão do workflow de desenvolvimento
- **~/.mcp.json** — MCP servers globais (context7, playwright, docker)
- **~/.claude/CLAUDE.md** — template pessoal para preencher
- **agents/** — cybersecurity-pentest, owasp-auditor, qa-engineer
- **Skills Antigravity** — 1.000+ skills de desenvolvimento
- **Skills CyberSecurity** — 754 skills de segurança (OWASP, pentest, forensics)

## Estrutura por projeto (já no repo do projeto)

Cada projeto já tem configurado via Git:

```
projeto/
├── CLAUDE.md              ← contexto técnico do projeto
├── .mcp.json              ← MCP servers do projeto
└── .claude/
    ├── settings.json      ← permissões e plugins
    └── agents/            ← agents do time
```

Projetos configurados:
- `EadxPro` — ASP.NET Core 8, C#, PostgreSQL
- `filter-dns` — FastAPI, Python, AdGuard, Docker
- `captive_portal` (WorldWifi) — FastAPI, OPNsense API

## Como usar os agents

```
# No Claude Code, dentro do projeto:
use o agent owasp-auditor para auditar este endpoint contra OWASP Top 10
use o agent qa-engineer para criar testes para este módulo
use o agent cybersecurity-pentest para testar esta API
```

## Requisitos

- Node.js 18+
- Claude Code CLI: `npm install -g @anthropic-ai/claude-code`
- Git
- Docker (para MCP terraform/docker)
- uv/uvx (para MCP servers AWS) — instalado automaticamente pelo setup

## Contribuindo

Ao criar um novo agent ou atualizar uma configuração:

1. Faça as mudanças localmente em `~/.claude/agents/` ou `~/.claude/settings.json`
2. Copie os arquivos relevantes para este repositório
3. Abra um PR com descrição do que mudou e por quê

## Maintainer

Wellber Santos — wellber@corp.netpoint.com.br
