# RobotSpeak incluido

La implementación canónica está en https://github.com/oddradiocircle/robotspeak.
`robotspeak-source.json` fija su commit y SHA-256. La habilidad distribuye
`scripts/robot-voice.ps1` y `scripts/ROBOTSPEAK-LICENSE`, sin cambiar la fuente.
El updater de mantenimiento es `tools/sync-robotspeak.sh <checkout-robotspeak>`;
lee una revisión Git ya confirmada y actualiza la copia y su manifest.

Usar OK para confirmar y ERR para errores. No usar R/ERRE como mensajes.
Para copiar, el cierre elegido es Ready y el punto es 50 ms. El helper fija
estos parámetros, el timbre Digital y la articulación Plain para conservar la elección aunque cambien defaults upstream.

Audiciones: ejecutar el script PowerShell con `-Word OK -Mood All`; para repetir,
`-Repeat 3`; `-EndingOnly` omite aviso y Morse. No emitir todas las muestras al
copiar: el helper reproduce una sola confirmación y usa `-PauseMs 0`.

El catálogo tiene catorce terminaciones: Ready, Relieved, Neutral, Happy, Enthusiastic,
Satisfied, Calm, Sad, Curious, Doubtful, Concerned, Frustrated, Apologetic y
Surprised. Las etiquetas expresan intenciones de diseño, no un diccionario
emocional universal. La teoría y el historial pertenecen a RobotSpeak.

`copy.ps1 -Sound Off` o `copy.sh -Sound Off` desactiva el audio de esa copia.
`-Sound On` lo habilita. No se cambia el volumen de Windows.

Recepción: RCV + Neutral, Digital y Plain; puntos de 50 ms. La terminación
descendente diferencia recibir de copiar. Ambas acciones admiten Sound Off.

Frases de estado para agentes (OK, ERR, K, RCV): [diccionario de RobotSpeak](https://github.com/oddradiocircle/robotspeak/blob/main/docs/dictionary.md).
