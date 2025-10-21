
# salas_chat_firebase_app

Um app de chat construído com Flutter + Firebase (iOS, Android)
Este repositório contém o código-fonte de um aplicativo de salas de chat (chat rooms) que utiliza Firebase para backend (banco de dados, armazenamento).

<img src="https://github.com/user-attachments/assets/738e08e2-6e71-4dcf-8bfe-0b1dce5f661f" width=140>
<img src="https://github.com/user-attachments/assets/21b8a5ba-acd5-43db-b2d6-708903578222" width=140>
<img src="https://github.com/user-attachments/assets/1db03c7a-f9fd-4057-808c-deca3b394bbd" width=140>
<img src="https://github.com/user-attachments/assets/5b56f0e9-9e47-4d09-9802-954607ddbee9" width=140>
<img src="https://github.com/user-attachments/assets/6605ddaa-d03f-46fc-9dd9-2302b9dd876b" width=140>

> ⚠️ Observação: deve-se adaptar/implementar corretamente os serviços Firebase (configuração, regras, credenciais) antes de pôr em produção.

---

## Conteúdo deste README

1. Pré-requisitos
2. Como rodar o projeto
3. Detalhamento da pasta `lib/` e seus arquivos principais
4. Boas práticas / Considerações
5. Licença & Contribuição

---

## 1. Pré-requisitos

* Ter instalado Flutter SDK + ambiente configurado para iOS/Android/Web.
* Criar ou ter um projeto Firebase configurado (com Authentication, Firestore/RealtimeDatabase, etc.).
* Rodar `flutter pub get` para baixar dependências.
* Em alguns casos, gerar arquivos de configuração do Firebase para cada plataforma.

---

## 2. Como rodar o projeto

```bash
# Clone o repositório
git clone https://github.com/LinikerThiers/salas_chat_firebase_app.git
cd salas_chat_firebase_app

# Instale as dependências
flutter pub get

# Para executar no Android
flutter run -d android

# Para executar no iOS
flutter run -d ios

# Para executar no Web
flutter run -d chrome
```

> Certifique-se de que os arquivos de configuração do Firebase (por exemplo `google-services.json` para Android, `GoogleService-Info.plist` para iOS) estejam corretamente ligados.


## 3. Detalhamento da pasta `lib/`

*(Aqui, como não temos o conteúdo completo de cada arquivo via GitHub diretamente, apresento um padrão comum e o que se espera em projetos de chat com Firebase — ajuste conforme seu código real.)*

### Estrutura sugerida

Dentro de `lib/`, normalmente teremos algo como:

```
lib/
  main.dart
  firebase_options.dart           ← (gerado pelo FlutterFire CLI)
  my_app.dart
  models/
    chat_model.dart
  pages/
    home_page.dart
      /chat/
        chat_page.dart
      /splash_screen/
        splash_screen.dart
```

#### `main.dart`

📍 Ponto de entrada da aplicação Flutter.

* É o primeiro arquivo executado quando o app inicia.

* Inicializa o Firebase usando o arquivo firebase_options.dart.

* Chama o widget principal MyApp, definido em my_app.dart.

#### `firebase_options.dart`

📍 Arquivo gerado automaticamente pelo FlutterFire CLI.

* Contém as configurações específicas do seu projeto Firebase (ID do app, chave da API, etc.).

* É usado pelo main.dart para inicializar corretamente o Firebase em diferentes plataformas (Android, iOS, Web, etc.).

⚠️ Não deve ser alterado manualmente.
Ele é recriado quando você roda o comando:

#### `my_app.dart`

📍 Widget raiz da aplicação.

* Define o MaterialApp, temas, título e rotas de navegação.

* Pode gerenciar qual tela deve ser exibida ao iniciar o app (por exemplo, SplashScreen → HomePage).

* Centraliza a configuração visual e estrutural do app.

#### `models/`

📍 Modelo de dados para mensagens no chat.

* Define a estrutura de uma mensagem trocada entre usuários.

* Utilizada para converter dados entre o Firestore e os widgets do app.

#### `🖥️ Páginas`
`pages/home_page.dart`

📍 Tela inicial do app.

* Exibe um campo para o usuário inserir seu nickname.

* Ao confirmar, o app navega para a tela de chat (ChatPage).

* Pode armazenar o nickname localmente via SharedPreferences para não precisar digitá-lo novamente.

Funções comuns:

* Validação do campo de nickname.

* Redirecionamento com Navigator.push().

#### `pages/chat/chat_page.dart`

📍 Tela principal de chat.

* Exibe o chat em tempo real entre os usuários.

* Usa o Cloud Firestore para ler e enviar mensagens.

* Cada mensagem é representada por um objeto ChatModel.

* Pode usar um StreamBuilder para atualizar automaticamente as mensagens quando novas são enviadas.

Principais componentes:

* Campo de texto → onde o usuário digita a mensagem.

* Botão de envio → adiciona a mensagem ao Firestore.

* Lista de mensagens → atualiza automaticamente com as mensagens da sala.

#### `pages/splash_screen/splash_screen.dart`

📍 Tela de carregamento inicial.

* Mostra uma animação ou logotipo enquanto o app é inicializado.

* Pode verificar se já existe um nickname salvo localmente.

* Redireciona automaticamente para HomePage ou ChatPage dependendo do estado do usuário.

---

### Arquivos e suas responsabilidades principais

Aqui vai uma lista rápida de cada arquivo/folder com sua função **específica** (ajuste conforme o código real):

| Arquivo/Pasta           | Função principal                                                   |
| ----------------------- | ------------------------------------------------------------------ |
| `main.dart`             | Entrada da app; inicializa Firebase; define MyApp e navegação.     |
| `firebase_options.dart` | Configuração de Firebase gerada automaticamente pelas plataformas. |
| `models/`               | Contém modelos de dados (User, ChatRoom, Message).                 |
| `pages/`              | Contém as telas visuais da aplicação (home, chat, splash).  |

---

## 4. Boas práticas / Considerações

* Mantenha separação clara entre UI (screens/widgets) e lógica de negócio (services).
* Utilize streams (e.g., `StreamBuilder`) para refletir em tempo real as mensagens de chat.
* Cuide da segurança no Firebase: regras de leitura/gravação, validação de usuários, evitar acesso indevido.
* Considere usar state management (Provider, Riverpod, Bloc) se a complexidade aumentar.
* Faça tratamento de erros (login falhou, envio de mensagem falhou, network offline).
* No Web ou multiplataforma, atente-se aos requisitos específicos (ex: permissões, importação de Firebase).
* Testes: aproveite a pasta `test/` para escrever testes unitários ou de widget para serviços e UI.

---

## 5. Licença & Contribuição

* Se você deseja que alguém contribua, adicione uma seção para *Contributing* (pull requests, issues, estilo de codificação).
* Informe qual licença (ex: MIT) se aplicável.
* Dê créditos ao autor inicial (neste caso, o repositório original do Liniker Thiers).

---

[1]: https://firebase.google.com/docs/flutter/setup?utm_source=chatgpt.com "Add Firebase to your Flutter app"
