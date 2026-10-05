# Windows Clipboard + RobotSpeak

[![skills.sh](https://skills.sh/b/oddradiocircle/windows-clipboard)](https://skills.sh/oddradiocircle/windows-clipboard/windows-clipboard)

Una habilidad para **Codex, Claude Code y Hermes Agent**: muestra el texto que se va a pegar, lo copia exactamente al portapapeles de Windows y confirma con **pip-pip → OK → cierre listo para usar**.

El punto Morse dura **50 ms**, la raya **150 ms** y la música usa velocidad **1,2×**. El sonido lo genera [RobotSpeak](https://github.com/oddradiocircle/robotspeak) en memoria con PowerShell/.NET.

## Instalación a nivel de usuario

```bash
npx skills add oddradiocircle/windows-clipboard@windows-clipboard --global --agent codex claude-code hermes-agent --yes
```

El comando es **`npx skills`**, en plural. Node/npm se usa para instalar; copiar y generar sonido solo requiere Windows PowerShell. WSL utiliza Bash y wslpath incluidos para llamar al mismo script.

El CLI permite enlaces a una copia central o `--copy` para copias independientes. [CLI oficial](https://github.com/vercel-labs/skills).

## Uso

La habilidad permite activación automática para entregar comandos que se pegarán en otra terminal. También se puede pedir explícitamente: «copia este comando al portapapeles y avísame».

- WSL: pasar el contenido UTF-8 por stdin a `bash <ruta-de-la-habilidad>/scripts/copy.sh`.
- Windows: invocar `scripts/copy.ps1 -Text $text` desde la ruta instalada.

El sonido es parametrizable: `-Sound On` (predeterminado) o `-Sound Off`, tanto en `copy.ps1` como en `copy.sh`. Off conserva la copia exacta y no reproduce audio. `-Timbre Classic`, `-Timbre Digital` o `-Timbre Crystal` cambia el timbre.

No ejecuta los comandos copiados ni registra su contenido. Si una copia falla, no anuncia OK; si el sonido falla después de copiar, distingue ese resultado parcial.

## Plataformas y pruebas

[Compatibilidad y rutas](references/compatibility.md) · [Sonido y procedencia](references/robotspeak.md)

Las tres herramientas de agente usan el mismo SKILL.md y los mismos scripts. El reproductor requiere Windows o WSL con interoperabilidad Windows; la compatibilidad con el agente no implica audio nativo en Linux/macOS.

```powershell
.\tests\clipboard.ps1
.\tests\read.ps1
```

La prueba realiza una copia, verifica Unicode y texto literal, y restaura el portapapeles anterior en memoria. Emite el sonido de confirmación.

MIT. Daniel Gómez / oddradiocircle. La licencia y revisión de RobotSpeak viajan con el paquete.

El sonido elegido es OK electrónico (`Digital`), con articulación uniforme
(`Plain`), punto de 50 ms y cierre Ready: «listo para usar».

## Recibir del portapapeles

«Lee lo que copié» o «el contenido está en mi portapapeles» activa la lectura.
WSL usa `scripts/read.sh`; Windows PowerShell usa `scripts/read.ps1`. Ambos
aceptan `-Sound On|Off` y `-Timbre`. El aviso **RCV** significa «recibido»: usa
una terminación descendente para distinguirlo del OK ascendente de la copia.
El sonido confirma la recepción, no la ejecución del contenido.

La lectura devuelve una instantánea del texto UTF-8, sin añadir salto de línea
ni sobrescribir el portapapeles. No hay vigilancia automática ni historial. Si
no hay texto, falla sin sonido. Las advertencias van a stderr.
