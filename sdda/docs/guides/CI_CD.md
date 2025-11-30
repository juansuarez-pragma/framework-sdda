# Integración CI/CD

Automatizar validación y despliegue con SDDA.

---

## Arquitectura CI/CD

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PIPELINE SDDA                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   Push/PR          Validate           Test            Build       Deploy    │
│   ───────          ────────           ────            ─────       ──────    │
│                                                                              │
│   ┌─────┐        ┌─────────┐       ┌───────┐       ┌───────┐    ┌───────┐  │
│   │ Git │───────▶│ Analyze │──────▶│ Test  │──────▶│ Build │───▶│Deploy │  │
│   │     │        │ + SDDA  │       │       │       │       │    │       │  │
│   └─────┘        │Validate │       └───────┘       └───────┘    └───────┘  │
│                  └─────────┘                                                │
│                       │                                                      │
│                       ▼                                                      │
│                  ┌─────────┐                                                │
│                  │ Quality │                                                │
│                  │  Gate   │                                                │
│                  └─────────┘                                                │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## GitHub Actions

### Workflow Principal

Crea `.github/workflows/sdda.yml`:

```yaml
name: SDDA Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

env:
  FLUTTER_VERSION: '3.24.0'

jobs:
  # ═══════════════════════════════════════════════════════════════════════════
  # JOB 1: VALIDATE
  # ═══════════════════════════════════════════════════════════════════════════
  validate:
    name: Validate Code
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install Dependencies
        run: flutter pub get

      - name: Install SDDA CLI Dependencies
        run: |
          cd sdda/05_generators
          dart pub get

      - name: Run Flutter Analyze
        run: flutter analyze --no-fatal-infos

      - name: Run SDDA Validate
        run: dart run sdda/05_generators/bin/sdda.dart validate --all

      - name: Check Formatting
        run: dart format --set-exit-if-changed lib/ test/

  # ═══════════════════════════════════════════════════════════════════════════
  # JOB 2: TEST
  # ═══════════════════════════════════════════════════════════════════════════
  test:
    name: Run Tests
    runs-on: ubuntu-latest
    needs: validate

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install Dependencies
        run: flutter pub get

      - name: Run Unit Tests
        run: flutter test --coverage

      - name: Check Coverage Threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -oP '\d+\.\d+')
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage below 80%!"
            exit 1
          fi

      - name: Upload Coverage Report
        uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info
          fail_ci_if_error: true

  # ═══════════════════════════════════════════════════════════════════════════
  # JOB 3: BUILD
  # ═══════════════════════════════════════════════════════════════════════════
  build:
    name: Build App
    runs-on: ubuntu-latest
    needs: test

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install Dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  # ═══════════════════════════════════════════════════════════════════════════
  # JOB 4: QUALITY GATE
  # ═══════════════════════════════════════════════════════════════════════════
  quality-gate:
    name: Quality Gate
    runs-on: ubuntu-latest
    needs: [validate, test]
    if: github.event_name == 'pull_request'

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Check PR Quality
        run: |
          echo "✅ All quality checks passed"
          echo "- Code validates against SDDA standards"
          echo "- All tests pass"
          echo "- Coverage >= 80%"
```

### Workflow de PR Review

Crea `.github/workflows/pr-review.yml`:

```yaml
name: PR Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    name: Automated Review
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          cache: true

      - name: Install Dependencies
        run: |
          flutter pub get
          cd sdda/05_generators && dart pub get

      - name: Get Changed Files
        id: changed-files
        uses: tj-actions/changed-files@v40
        with:
          files: |
            lib/**/*.dart

      - name: Validate Changed Files
        if: steps.changed-files.outputs.any_changed == 'true'
        run: |
          for file in ${{ steps.changed-files.outputs.all_changed_files }}; do
            echo "Validating: $file"
            dart run sdda/05_generators/bin/sdda.dart validate "$file"
          done

      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '✅ SDDA Validation passed for all changed files'
            })
```

---

## GitLab CI

### .gitlab-ci.yml

```yaml
stages:
  - validate
  - test
  - build
  - deploy

variables:
  FLUTTER_VERSION: "3.24.0"

.flutter-setup: &flutter-setup
  before_script:
    - apt-get update -qq && apt-get install -y -qq unzip xz-utils
    - git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter
    - export PATH="/flutter/bin:$PATH"
    - flutter doctor

# ═══════════════════════════════════════════════════════════════════════════
# VALIDATE
# ═══════════════════════════════════════════════════════════════════════════
validate:
  stage: validate
  <<: *flutter-setup
  script:
    - flutter pub get
    - cd sdda/05_generators && dart pub get && cd ../..
    - flutter analyze
    - dart run sdda/05_generators/bin/sdda.dart validate --all
    - dart format --set-exit-if-changed lib/ test/

# ═══════════════════════════════════════════════════════════════════════════
# TEST
# ═══════════════════════════════════════════════════════════════════════════
test:
  stage: test
  <<: *flutter-setup
  script:
    - flutter pub get
    - flutter test --coverage
    - |
      COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -oP '\d+\.\d+')
      if (( $(echo "$COVERAGE < 80" | bc -l) )); then
        echo "Coverage $COVERAGE% is below 80%!"
        exit 1
      fi
  coverage: '/lines.*: (\d+\.\d+)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura.xml

# ═══════════════════════════════════════════════════════════════════════════
# BUILD
# ═══════════════════════════════════════════════════════════════════════════
build:
  stage: build
  <<: *flutter-setup
  script:
    - flutter pub get
    - flutter build apk --release
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/
  only:
    - main
    - develop

# ═══════════════════════════════════════════════════════════════════════════
# DEPLOY
# ═══════════════════════════════════════════════════════════════════════════
deploy-staging:
  stage: deploy
  script:
    - echo "Deploying to staging..."
  environment:
    name: staging
  only:
    - develop

deploy-production:
  stage: deploy
  script:
    - echo "Deploying to production..."
  environment:
    name: production
  only:
    - main
  when: manual
```

---

## Quality Gates Detallados

### Gate 1: Pre-Commit (Local)

Crea `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Running pre-commit checks..."

# 1. Format check
echo "Checking format..."
dart format --set-exit-if-changed lib/ test/
if [ $? -ne 0 ]; then
    echo "❌ Format check failed. Run 'dart format lib/ test/'"
    exit 1
fi

# 2. Analyze
echo "Running analyzer..."
flutter analyze --no-fatal-infos
if [ $? -ne 0 ]; then
    echo "❌ Analyze failed"
    exit 1
fi

# 3. SDDA Validate (staged files only)
echo "Running SDDA validation..."
STAGED_DART=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$')
if [ -n "$STAGED_DART" ]; then
    for file in $STAGED_DART; do
        dart run sdda/05_generators/bin/sdda.dart validate "$file"
        if [ $? -ne 0 ]; then
            echo "❌ SDDA validation failed for $file"
            exit 1
        fi
    done
fi

echo "✅ Pre-commit checks passed"
```

### Gate 2: PR Checks

| Check | Obligatorio | Bloquea Merge |
|-------|-------------|---------------|
| Analyze pass | ✅ | ✅ |
| SDDA validate pass | ✅ | ✅ |
| All tests pass | ✅ | ✅ |
| Coverage ≥ 80% | ✅ | ✅ |
| Format correct | ✅ | ✅ |
| No new warnings | ⚠️ | ❌ |

### Gate 3: Pre-Deploy

| Check | Staging | Production |
|-------|---------|------------|
| All unit tests | ✅ | ✅ |
| Integration tests | ✅ | ✅ |
| E2E tests | ⚠️ | ✅ |
| Coverage ≥ 80% | ✅ | ✅ |
| No critical issues | ✅ | ✅ |
| Manual approval | ❌ | ✅ |

---

## Scripts de Automatización

### script: validate-feature.sh

```bash
#!/bin/bash
# Uso: ./scripts/validate-feature.sh <feature_name>

FEATURE=$1

if [ -z "$FEATURE" ]; then
    echo "Uso: $0 <feature_name>"
    exit 1
fi

echo "═══════════════════════════════════════════════════════"
echo "Validating feature: $FEATURE"
echo "═══════════════════════════════════════════════════════"

# 1. SDDA Validate
echo -e "\n[1/4] Running SDDA validation..."
dart run sdda/05_generators/bin/sdda.dart validate --feature=$FEATURE
if [ $? -ne 0 ]; then
    echo "❌ SDDA validation failed"
    exit 1
fi

# 2. Flutter analyze
echo -e "\n[2/4] Running Flutter analyze..."
flutter analyze lib/features/$FEATURE/
if [ $? -ne 0 ]; then
    echo "❌ Analyze failed"
    exit 1
fi

# 3. Run tests
echo -e "\n[3/4] Running tests..."
flutter test test/features/$FEATURE/ --coverage
if [ $? -ne 0 ]; then
    echo "❌ Tests failed"
    exit 1
fi

# 4. Check coverage
echo -e "\n[4/4] Checking coverage..."
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -oP '\d+\.\d+')
echo "Coverage: $COVERAGE%"

if (( $(echo "$COVERAGE < 80" | bc -l) )); then
    echo "❌ Coverage $COVERAGE% is below 80%"
    exit 1
fi

echo -e "\n═══════════════════════════════════════════════════════"
echo "✅ Feature '$FEATURE' passed all validations"
echo "═══════════════════════════════════════════════════════"
```

### script: generate-and-validate.sh

```bash
#!/bin/bash
# Uso: ./scripts/generate-and-validate.sh <feature_name> <spec_path>

FEATURE=$1
SPEC=$2

if [ -z "$FEATURE" ] || [ -z "$SPEC" ]; then
    echo "Uso: $0 <feature_name> <spec_path>"
    exit 1
fi

echo "═══════════════════════════════════════════════════════"
echo "SDDA Generate & Validate: $FEATURE"
echo "═══════════════════════════════════════════════════════"

# 1. Generate
echo -e "\n[1/2] Generating feature..."
dart run sdda/05_generators/bin/sdda.dart generate feature $FEATURE \
    --spec=$SPEC \
    --with-tests

if [ $? -ne 0 ]; then
    echo "❌ Generation failed"
    exit 1
fi

# 2. Validate
echo -e "\n[2/2] Validating generated code..."
./scripts/validate-feature.sh $FEATURE

if [ $? -ne 0 ]; then
    echo "❌ Validation failed"
    exit 1
fi

echo -e "\n═══════════════════════════════════════════════════════"
echo "✅ Feature '$FEATURE' generated and validated successfully"
echo "═══════════════════════════════════════════════════════"
```

---

## Dashboard de Métricas

### Badges para README

```markdown
![Coverage](https://img.shields.io/codecov/c/github/user/repo)
![Build](https://img.shields.io/github/actions/workflow/status/user/repo/sdda.yml)
![Tests](https://img.shields.io/badge/tests-passing-green)
```

### Reporte Automático

Agregar al workflow:

```yaml
- name: Generate Metrics Report
  run: |
    echo "# SDDA Metrics Report" > metrics-report.md
    echo "## Coverage" >> metrics-report.md
    lcov --summary coverage/lcov.info >> metrics-report.md
    echo "## Test Results" >> metrics-report.md
    flutter test --reporter json > test-results.json
    # Parse and append results

- name: Upload Metrics
  uses: actions/upload-artifact@v3
  with:
    name: metrics-report
    path: metrics-report.md
```

---

## Siguiente Paso

Ver [Troubleshooting](./TROUBLESHOOTING.md) para resolver problemas comunes.
