# Compatibilidad

| Agente | ID del CLI | Instalación global habitual |
| --- | --- | --- |
| Codex | `codex` | `~/.codex/skills/windows-clipboard` |
| Claude Code | `claude-code` | `~/.claude/skills/windows-clipboard` |
| Hermes Agent | `hermes-agent` | `~/.hermes/skills/windows-clipboard` |

Las rutas pueden ser enlaces a `~/.agents/skills/windows-clipboard`. CODEX_HOME,
CLAUDE_CONFIG_DIR y HERMES_HOME pueden cambiar destinos; confirmar la salida del
CLI y los archivos instalados. El código usa PSScriptRoot para hallar el sonido.

Contrato idéntico en los tres agentes: leer el SKILL.md, resolver su carpeta,
mostrar el bloque exacto, ejecutar el helper con el texto como datos y comprobar
el resultado. Las herramientas de shell y los permisos los aporta cada agente;
no se invocan herramientas propietarias de Codex dentro del protocolo.

La edición previa era una habilidad local de Codex. El cuerpo público elimina
su ruta de usuario, mantiene el orden copiar-avisar y usa un puente Bash en WSL
en lugar de una dependencia Python. Las primeras audiciones están preservadas
en el repo RobotSpeak; no forman parte del runtime de la habilidad.

Si el agente se ejecuta en Linux fuera de WSL, el helper explica que falta la
interoperabilidad. No sustituir silenciosamente por una campana de terminal.
Si Windows bloquea scripts por su política de ejecución, reportar el problema y
resolverlo con permiso para ese proceso. No modificar la política global.

Hermes admite HERMES_HOME para perfiles. Esta instalación global se dirige al
usuario actual; un perfil adicional requiere una instalación dirigida a ese
perfil, no inferir que quedó instalado en todos los perfiles.

Fuentes: [skills CLI](https://github.com/vercel-labs/skills),
[skills.sh](https://skills.sh/docs). El SKILL.md conserva la activación implícita.
