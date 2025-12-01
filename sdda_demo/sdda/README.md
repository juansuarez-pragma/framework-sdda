# SDDA - Specification-Driven Development for AI Agents

Este directorio contiene la configuración y contexto para generación de código con IA.

## Estructura

```
sdda/
├── sdda.yaml                 # Configuración principal
├── analysis_options.yaml     # Reglas de linting
├── 01_specs/                 # Especificaciones de features
├── 02_contracts/             # Tests como contratos
├── 03_context/               # Contexto para IA
│   ├── architecture/         # Documentación de arquitectura
│   ├── conventions/          # Convenciones de código
│   ├── patterns/             # Patrones de ejemplo
│   ├── api/                  # Catálogo de APIs
│   └── schemas/              # Esquemas de datos
└── 04_prompts/               # Templates de prompts
```

## Uso

```bash
# Generar un feature completo
sdda generate feature auth

# Generar un UseCase
sdda generate usecase Login --feature=auth

# Validar código
sdda validate --all

# Generar prompt para IA
sdda prompt usecase --feature=auth --name=Login
```

## Filosofía

**"La IA NO imagina código, la IA IMPLEMENTA especificaciones"**

Entrada: Especificación + Tests + Contexto → Salida: Código Validado
