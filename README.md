# BarberFlow

Aplicativo mobile de agendamento de barbearia desenvolvido com Flutter.

## Integrantes

- Iago Pinheiro
- Pedro
- Kaio

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.47.1
- Dart SDK >= 3.13.1 (já vem com o Flutter)
- Android Studio ou VS Code com extensões Flutter/Dart
- Git

## Como rodar

### 1. Clone o repositório

```bash
git clone git@github.com:iago-pinheiro/BarberFlow.git
cd BarberFlow
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Rode o projeto

#### Web (mais rápido pra testar)

```bash
flutter run -d chrome
```

#### Celular Android (USB)

1. Ative **Depuração USB** no celular (Configurações → Opções do Desenvolvedor)
2. Conecte o celular via cabo USB
3. Rode:

```bash
flutter run
```

#### Emulador Android

```bash
flutter emulators                          # lista emuladores disponíveis
flutter emulators --launch <nome>          # abre um emulador
flutter run                                # roda no emulador
```

#### Build release

```bash
flutter build apk          # gera APK para instalar no celular
flutter build web          # gera build web na pasta build/web
```

### Rodar testes

```bash
flutter test
```

### Verificar código

```bash
flutter analyze
```

## Estrutura do projeto

```
lib/
├── main.dart                          # Ponto de entrada
├── core/
│   ├── constants/                     # Constantes (strings, dimensões, rotas)
│   ├── providers/                     # Estado global (Provider)
│   │   ├── app_provider.dart          # Tema, variant A/B, métricas
│   │   ├── booking_provider.dart      # Estado do agendamento
│   │   └── appointments_provider.dart # Estado dos agendamentos
│   ├── router/                        # Rotas (GoRouter)
│   ├── services/                      # Serviços A/B Test e Métricas
│   ├── theme/                         # Cores, textos e tema do app
│   └── utils/                         # Utilitários
├── data/
│   ├── mock/                          # Dados mockados (serviços, profissionais)
│   ├── models/                        # Modelos de dados
│   └── repositories/                  # Repositórios (CRUD em memória)
└── features/
    ├── home/                          # Tela inicial + variantes A/B
    ├── services/                      # Tela de serviços
    ├── professionals/                 # Tela de profissionais
    ├── booking/                       # Tela de agendamento
    └── appointments/                  # Tela de agendamentos do usuário
```

## Funcionalidades implementadas

- **Home com Teste A/B**: Duas variantes (controle vs tratamento) rotacionadas automaticamente
- **Serviços**: Lista com filtros por categoria (corte, barba, combo, sobrancelha)
- **Profissionais**: Grade com indicadores de disponibilidade
- **Agendamento**: Seleção de profissional, data, horário e confirmação
- **Agendamentos**: Lista de agendamentos ativos/cancelados com opção de cancelar
- **Dashboard de Métricas**: Acesse `/ab-metrics` para ver taxa de conversão por variante

## Stack

- **Flutter** 3.47.1
- **Provider** — gerenciamento de estado
- **GoRouter** — navegação declarativa
- **SharedPreferences** — persistência local (A/B test)
- **intl** — formatação de datas

## Convenções

- Commits em **PT-BR** no formato semântico: `feat:`, `fix:`, `refactor:`, `docs:`
- Sempre rodar `flutter analyze` e `flutter test` antes de commitar
- Não fazer push direto no `main` — usar branches para features
