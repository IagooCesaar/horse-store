# Horse Store

**horse-store** é um projeto com objetivo de praticar desenvolvimento multi-camadas de aplicação. Foi criado utilizando a IDE _Delphi Community Edition 11 Alexandria_ e tem como principais dependências bibliotecas gratuitas.

## Sobre o projeto

![Grupo de Projetos](https://github.com/IagooCesaar/horse-store/assets/12894025/3e8ed9b4-c1dc-408e-9428-ec17a2d7ea7a)


- **loja.exe:** Cliente VCL (Visual Components Library ou Biblioteca de Componentes Visuais);
- **loja_server_console.exe:** Versão console API, portável para Linux
- **loja_server_vcl.exe:** Versão com interface gráfica da API, exclusivo para Windows;
- **loja_server_test.exe:** Projeto de testes

### Padrões de Projeto (Design Patterns)

---

#### Servidor

- **Abstract Factory**: “Fábrica” que retorna objetos que obedecem um (ou mais) “contrato(s)” (interface);
- **SRP - Single Responsiblity Principle**: Única responsabilidade;
    - Ex: Model contém regra de negócio, DAO acesso aos dados, Entity interface com os dados, DTO trafegar dados;
- **************OCP - Open-Closed Principle:************** Objetos ou entidades devem estar abertos para extensão, mas fechados para modificação, ou seja, quando novos comportamentos e recursos precisam ser adicionados no software, devemos estender e não alterar o código fonte original.
    - Ex: DAO Oficial e DAO In-Memory, implementam mesmas interfaces, um tem objetivo de acesso a banco de dados e o outro salva dados em memória;
- **DIP — Dependency Inversion Principle:** Inversão de dependência, como cada classe tem seu objetivo bem definido, uma não “invade” a outra. Logo, uma classe não precisa saber como conectar ao repositório, basta acionar a classe que implementa tal interface;
- (Desejado) ****LSP— Liskov Substitution Principle:**** Implementação de injeção de dependência nos Model’s para definição dos DAOs.

> Fonte: [https://medium.com/desenvolvendo-com-paixao/o-que-é-solid-o-guia-completo-para-você-entender-os-5-princípios-da-poo-2b937b3fc530](https://medium.com/desenvolvendo-com-paixao/o-que-%C3%A9-solid-o-guia-completo-para-voc%C3%AA-entender-os-5-princ%C3%ADpios-da-poo-2b937b3fc530)
> 

#### Cliente

- MVC: Padrão Model + View + Controller:
    - **Model**: classe para interfacear dados enviados ou recebidos da API
    - **View**: basicamente são as telas gráficas do cliente;
    - **Controller**: classes responsáveis por obter os dados, no caso, oriundos da API;

### Estrutura pastas Servidor

![Estrutura de pastas parte 1](https://github.com/IagooCesaar/horse-store/assets/12894025/cf96eaa0-e9f1-46db-bef5-01205737ebab)

![Estrutura de pastas parte 2](https://github.com/IagooCesaar/horse-store/assets/12894025/24231dce-a9ed-4c37-80c3-a779f0258436)

- ./
    - src
        - **controllers**
            - Loja.Controller.X.pas
        - **model**
            - **bo**:
                - Loja.Model.Bo.Interfaces.pas
                - Loja.Model.Bo.Factory.pas
                - Loja.Model.Bo.X.pas
            - **dao**:
                - **in-memory**
                    - Loja.Model.Dao.X.Factory.InMemory.pas
                - **oficial**
                    - Loja.Model.Dao.X.Factory.pas
                - Loja.Model.Dao.Interfaces.pas
                - Loja.Model.Dao.Factory.pa
                - Loja.Model.Dao.X.Interfaces.pas
            - **dto**:
                - Loja.Model.Dto.Req.X.pas
                - Loja.Model.Dto.Resp.X.pas
            - entity
                - Loja.Model.Entity.X.pas
            - Loja.Model.Interfaces.pas
            - Loja.Model.Factory.pas
            - Loja.Model.X.pas
        - App.pas
- boss.json

### Principais dependências

- Boss

[https://github.com/HashLoad/boss](https://github.com/HashLoad/boss)

- Horse

[https://github.com/HashLoad/horse](https://github.com/HashLoad/horse)

- GBSwagger

[https://github.com/gabrielbaltazar/gbswagger](https://github.com/gabrielbaltazar/gbswagger)

[https://github.com/IagooCesaar/gbswagger](https://github.com/IagooCesaar/gbswagger)

- Horse Json Interceptor

[https://github.com/IagooCesaar/Horse-JsonInterceptor](https://github.com/IagooCesaar/Horse-JsonInterceptor)

- RestRequest4D

[https://github.com/viniciussanchez/RESTRequest4Delphi](https://github.com/viniciussanchez/RESTRequest4Delphi)

- Dataset Serialize

[https://github.com/viniciussanchez/dataset-serialize](https://github.com/viniciussanchez/dataset-serialize)

- Delphi Code Coverage

[https://github.com/DelphiCodeCoverage/DelphiCodeCoverage](https://github.com/DelphiCodeCoverage/DelphiCodeCoverage)

- Pascal Database Engine

[https://github.com/IagooCesaar/pascal-database-engine](https://github.com/IagooCesaar/pascal-database-engine)

[https://github.com/antoniojmsjr/MultithreadingFireDAC](https://github.com/antoniojmsjr/MultithreadingFireDAC)

### Banco de Dados

#### Firebird 3.0

[Firebird: The true open source database for Windows, Linux, Mac OS X and more](https://firebirdsql.org/en/firebird-3-0/)

```jsx
> isql -user sysdba employee

SQL> create user SYSDBA password 'SomethingCryptic';
SQL> commit;
SQL> quit;
```

#### IBExpert

[IBExpert Download Center](https://www.ibexpert.net/downloadcenter/)

![IBExpert](https://github.com/IagooCesaar/horse-store/assets/12894025/7f0ba175-50ee-4ef7-81a6-7dc3c1702587)

<aside>
💡 Script modelo para criação da base de dados: https://github.com/IagooCesaar/horse-store/tree/main/server/database

</aside>

### Apresentando e Executando os projetos 🚀

[![Vídeo apresentação projeto](https://img.youtube.com/vi/oTl5mswK1vc/0.jpg)](https://www.youtube.com/watch?v=oTl5mswK1vc)

## Iniciando o projeto

Primeiro passo será instalar versão 11 da IDE Delphi, podendo ser até mesmo a versão [Community Edition](https://www.embarcadero.com/br/products/delphi/starter).

Será necessário obter o **Boss**, que é um gerenciador de dependência para o Delphi, similar ao NPM e YARN para Node.js. Verifique pela versão compatível com seu dispositivo dentre as opções em [Releases](https://github.com/HashLoad/boss/releases).

Para rodar o projeto de testes será necessário a instalação do **DelphiCodeCoverage**. Neste projeto foi utilizada a versão 1.0.15, que pode [ser obtida aqui](https://github.com/DelphiCodeCoverage/DelphiCodeCoverage/releases).

Após realizar download do **Boss** e do **DelphiCodeCoverage**, recomendo colocar ambos os executáveis em uma mesma pasta em seu computador, e adicionar o caminho para acesso a esta pasta na variável **PATH** do seu Windows (nível de usuário ou a nível do computador). Com isto, você conseguirá utilizar estes executáveis facilmente no [Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=pt-br&gl=br&icid=CNavAppsWindowsApps) (ou outros consoles do Windows).

Após fazer download do projeto, abra o Windows Terminal e navegue até a pasta onde se encontra o projeto.

![Windows Terminal](https://github.com/IagooCesaar/horse-store/assets/12894025/f23cd05a-6985-4da1-aff9-4370b0dfd570)

- Baixando dependências para o projeto CLIENTE: Navegue até a pasta do projeto cliente (ex: `cd .\cliente\vcl`) e rode o comando `boss install`. Aguarde o final do procedimento e então retorne para a pasta anterior (ex: `cd ..\..`).

- Baixando dependências para o projeto SERVER: Navegue até a pasta do projeto server (ex: `cd .\server`) e rode o comando `boss install`. Aguarde o final do procedimento.

> IMPORTANTE: <br>
> Este projeto foi construído utilizando versão do **GBSwagger** que ainda não foi disponibilizada oficialmente. Ou seja, embora no arquivo `boss.json` esteja indicando a versão **3.0.7** do GBSwagger, este projeto exige versão superior.<br>
> Deste modo, até que a nova versão desta dependência sejam publicadas, é recomendado que seja realizado o download manual da lib e então atualizada a dependência em `\server\modules\gbswagger`. Assim que a nova versão for disponibilizada, este projeto será atualizado.

Para executar a avaliação de cobertura de código, execute o arquivo `code_coverage.bat` que se encontra na pasta `.\server\`. Os resultados serão salvos em `.\server\Win64\Debug\`. Recomenda-se, para esta avaliação, abrir o arquivo `.\server\Win64\Debug\CodeCoverage_summary.html`

![Relatório de cobertura de código](https://github.com/IagooCesaar/horse-store/assets/12894025/f7db4c89-86a1-4d44-89a0-4a5e91af40c6)

> 💡 Execute o script de criação do banco de dados antes de rodar o script de verificação de cobertura de código.

> 💡 Utilize o projeto `loja_server_vcl` para configurar o acesso ao banco de dados

> 💡 No vídeo há mais detalhes sobre a execução deste projeto