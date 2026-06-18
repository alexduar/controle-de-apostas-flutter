# 🎰 Bet Tracker

O **Bet Tracker** é um aplicativo móvel elegante e moderno desenvolvido em Flutter para ajudar usuários a gerenciarem suas apostas de forma simples e eficiente. Com um design focado em Dark Mode e uma arquitetura robusta, o app permite registrar palpites, acompanhar lucros ou prejuízos em tempo real e manter um histórico persistente localmente.

---

## ✨ Funcionalidades

* **Painel de Saldo Geral:** Um card dinâmico no topo que muda de cor (Verde para lucro, Vermelho para prejuízo) baseado no acumulado histórico de todas as suas apostas.
* **Registro Detalhado:** Campos para inserir o nome do evento/jogo, valor apostado e o status (Ganhei ou Perdi).
* **Gestão de Prejuízo Inteligente:** Ao marcar uma aposta como "Perdi", o app calcula automaticamente o prejuízo com base no valor apostado, otimizando o tempo do usuário.
* **Data e Hora Automáticas:** Cada registro armazena o momento exato em que a movimentação foi criada.
* **Tema Dark Premium:** Interface visualmente confortável e moderna, utilizando cores contrastantes de alta fidelidade (Verde Neon e Vermelho Vibrante).
* **Persistência de Dados Local:** Suas apostas continuam salvas mesmo se o aplicativo for fechado ou o dispositivo reiniciado.

---

## 🏗️ Arquitetura e Padrões de Projeto (Design Patterns)

O projeto foi refatorado seguindo o padrão de arquitetura **MVVM (Model-View-ViewModel)** integrado ao padrão **Observer** utilizando a classe `ChangeNotifier` nativa do Flutter. Isso garante uma separação clara entre a interface do usuário (UI) e as regras de negócio.

### Estrutura de Pastas

```text
lib/
│
├── core/
│   └── constants/
│       └── app_strings.dart    # Centralização de Textos (Evita Strings fixas)
│
├── data/
│   ├── models/
│   │   └── bet_model.dart      # Estrutura de dados e serialização JSON
│   └── services/
│       └── storage_service.dart # Persistência de dados (SharedPreferences)
│
├── controllers/
│   └── bet_controller.dart     # Regras de negócio e Gerenciamento de Estado
│
├── views/
│   ├── home/
│   │   └── home_screen.dart    # Tela principal (Dashboard)
│   └── widgets/
│       └── add_bet_modal.dart  # Modal de inserção de nova aposta
│
└── main.dart                   # Inicialização do App e Configuração de Temas