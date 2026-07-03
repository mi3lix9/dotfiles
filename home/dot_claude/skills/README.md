# Agent skills

Personal Claude Code skills live here and deploy to `~/.claude/skills/`.

Each skill is a directory containing a `SKILL.md` (with YAML frontmatter:
`name`, `description`) plus any supporting files. Example:

```
skills/
└── my-skill/
    └── SKILL.md
```

Add a skill directory here, then `chezmoi add ~/.claude/skills/my-skill` (or
re-run the bootstrap) to track it. Keep skills free of secrets — this repo is
public.
