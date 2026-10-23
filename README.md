# Gradio Spaces — versão em português para Android

Aplicativo Flutter para explorar Spaces Gradio do Hugging Face, acessar o HuggingChat e guardar arquivos gerados pelos serviços.

**Este pacote é código-fonte revisado. Não contém APK compilado.** A inferência é executada online pelos serviços acessados. Os arquivos já salvos podem ser consultados localmente.

## Gerar o APK pelo computador

Requisitos:

- Flutter com Dart >=3.9.0 e <4.0.0. O workflow incluído usa Flutter 3.35.7.
- JDK 17.
- Android SDK, ferramentas de compilação e licenças aceitas.
- Internet para obter dependências e ferramentas na primeira compilação.
- Linux, macOS ou Windows com Git Bash para os scripts `.sh`.

Abra um terminal na pasta que contém este README e execute:

```bash
flutter doctor --android-licenses
bash scripts/gerar-apk.sh teste
```

O script restaura os arquivos ausentes do Gradle Wrapper a partir de um projeto Flutter temporário, instala as dependências, executa a análise e os testes, e tenta gerar o APK de depuração. Ele preserva os arquivos Android personalizados.

Resultado esperado após compilação bem-sucedida:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Transfira esse arquivo para o Android e abra-o para instalar. O aparelho pode solicitar autorização para instalar aplicativos dessa origem. A versão revisada usa Android 7.0/API 24 ou superior.

Para executar diretamente num dispositivo conectado:

```bash
bash scripts/preparar-android.sh
flutter devices
flutter run
```

## Gerar pelo GitHub usando o celular

O pacote inclui `.github/workflows/android-apk.yml`. O workflow foi preparado, mas não foi enviado nem executado em uma conta GitHub.

1. Crie um repositório e envie o conteúdo desta pasta para a raiz dele. A pasta `.github` também precisa estar incluída.
2. Abra **Actions → Gerar APK Android → Run workflow**.
3. Aguarde a compilação. Se falhar, abra a etapa que apresentou erro para ler o diagnóstico.
4. Se passar, baixe o artefato **gradio-spaces-android-teste**.
5. Extraia o artefato e instale `app-debug.apk`.

O GitHub pode aplicar limites ou cobrança conforme a conta e o uso. O fluxo gera somente APK de teste. Nenhum token pessoal do Hugging Face ou chave de publicação precisa ser colocado no repositório.

## Gerar versão assinada para distribuição

Primeiro crie sua própria chave de assinatura, fora do controle de versão:

```bash
keytool -genkeypair -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Copie `android/key.properties.example` para `android/key.properties` e preencha os campos. O caminho `storeFile` é relativo à pasta `android` ou absoluto. Guarde a chave e as senhas, pois são necessárias para futuras atualizações.

```bash
bash scripts/gerar-apk.sh publicacao
```

O script exige a configuração de assinatura e gera APKs separados por arquitetura na pasta `build/app/outputs/flutter-apk/`. Para o seu realme RMX3830, procure o APK `app-arm64-v8a-release.apk`.

Para gerar um Android App Bundle, após configurar a assinatura:

```bash
flutter build appbundle --release
```

O Gradle mantém uma assinatura de depuração como alternativa para execuções locais sem chave; **essa alternativa não é uma assinatura de publicação**. O script `publicacao` impede esse uso acidental.

## Login no Hugging Face

O aplicativo usa a página oficial de login em WebView para os favoritos e para compartilhar a sessão com o chat. Também preserva o serviço OAuth do projeto.

O identificador OAuth presente no código pertence à configuração original. Para distribuir uma edição própria, cadastre seu cliente no Hugging Face e confira os valores em:

- `lib/services/hf_oauth_service.dart`: identificador do cliente e URI de retorno.
- `android/app/build.gradle.kts`: esquema de retorno do AppAuth.
- `android/app/src/main/AndroidManifest.xml`: esquema e host do retorno.
- Configuração iOS, caso também decida gerar uma edição para iPhone.

O esquema de retorno foi preservado para evitar quebrar o cadastro original. O funcionamento real do login depende do cadastro, das regras e das páginas atuais do Hugging Face e precisa ser testado no aparelho. Tokens OAuth e cookies de sessão agora são armazenados separadamente; um token OAuth não é inserido como cookie de sessão do site.

## O que foi alterado

- Interface própria, 36 categorias, mensagens e datas relativas em português do Brasil.
- Localização padrão dos controles Material em português.
- Fontes do sistema para evitar download de fontes externas.
- Rota `/outputs` registrada.
- Câmera e microfone declarados no Android, solicitados apenas quando um Space precisa deles e mediante consentimento.
- Origens de mídia limitadas ao Space HTTPS selecionado e a `huggingface.co`.
- Cancelamento de exceções de certificado TLS.
- Remoção de registros de cookies, tokens e dados de autenticação.
- Remoção da identificação de usuário por raspagem de links da página; a sessão é conferida com o servidor.
- Busca com caracteres especiais codificados corretamente na URL.
- Java 17, Kotlin 2.2.0, Android Gradle Plugin 8.12.1 e Gradle 8.13 para atender aos requisitos de `share_plus 12.0.0`.
- Memória máxima do heap do Gradle reduzida de 8 GB para 2 GB e dois workers.
- Testes da política de origens substituindo o teste de contador que não correspondia ao aplicativo.
- Scripts de preparação e compilação e workflow manual de APK de teste.

As páginas externas, os nomes e as descrições de Spaces fornecidos pelo Hugging Face conservam o idioma original. Esta revisão tem foco no Android; o código de iOS permanece incluído, mas não foi validado.

## Validação e limitações

O ambiente desta revisão não dispõe de Flutter/Dart nem de um Android SDK configurado. Por isso não foi possível executar `flutter analyze`, `flutter test`, compilar APK ou testar em aparelho. Verificações locais de estrutura e scripts estão registradas em `VALIDACAO.md`. Ter código preparado não equivale a uma compilação homologada.

O arquivo `pubspec.lock` original foi preservado como referência; `flutter pub get` precisa atualizá-lo para incluir a localização Material e remover as dependências de fontes. Revise e mantenha o novo lock após a primeira resolução bem-sucedida.

Os binários do simulador iOS (`Runner.app`, `Runner-iOS-Simulator.zip`) e relatórios de build antigos foram retirados do pacote revisado. Eles não são necessários para compilar o Android. Não foi removido código-fonte das plataformas.

Compilar Flutter diretamente no Termux não é o fluxo documentado aqui. Pelo Android, use o workflow incluído; pelo computador, use o SDK Flutter e o Android SDK.

## Referências técnicas

- https://docs.flutter.dev/deployment/android
- https://inappwebview.dev/docs/web-rtc/
- https://pub.dev/packages/share_plus/versions/12.0.0
