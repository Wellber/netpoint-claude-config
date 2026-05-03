# Template CLAUDE.md Pessoal — Netpoint/Defensys

> Copie este arquivo para ~/.claude/CLAUDE.md e preencha com seu contexto.

## Desenvolvedor

- **Nome:** [SEU NOME]
- **Email:** [SEU EMAIL @netpoint.com.br ou @defensys...]
- **Time:** [Netpoint / Defensys / WorldWifi]

## Empresa

- **Netpoint:** hospedagem, EAD (EadxPro), infraestrutura cloud AWS (us-east-1)
- **Defensys:** segurança, telecom, filtro-dns, WorldWifi captive portal
- **CNPJ Netpoint:** 64.460.536/0001-72

## Stack principal

- [liste suas linguagens: C#, Python, Node.js, Go, Rust...]
- [frameworks que usa com mais frequência]

## Regras obrigatórias de trabalho

1. **Propor antes de executar** — nunca rodar comandos destrutivos em produção sem confirmação
2. **Backup antes de editar** — `cp arquivo arquivo.bak.$(date +%Y%m%d_%H%M%S)`
3. **Auditoria em servidores** — registrar em `/root/$(hostname).log` (Linux) ou `C:\audit\$env:COMPUTERNAME.log` (Windows)
4. **Acesso via ssh-manager** — nunca SSH manual quando o ssh-manager estiver disponível
5. **Idioma:** português em documentação, comentários e commits

## Padrão de commit

```
feat(escopo): descrição em português
fix(escopo): descrição
chore(deps): atualizar pacotes
hotfix(prod): correção urgente
```

## Projetos em que trabalho

- [nome do projeto] — [stack] — path: ~/Documents/Projetos/...
- [nome do projeto] — [stack] — servidor: [nome no ssh-manager]

## Acesso a servidores

- Chave SSH: `~/.ssh/id_ed25519`
- Usar sempre o ssh-manager para acessar servidores
- Servidores Windows: usar PowerShell

> Consulte o CLAUDE.md de cada projeto para contexto técnico detalhado.
