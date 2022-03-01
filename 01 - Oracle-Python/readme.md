# Acessar banco de dados Oracle pelo Python

Processar datasets usando Pandas é muito prático, mas ninguém entende mais de processamento de dados do que os bancos de dados. Eles possuem mecanismos de consultas otimizadas.
Ao trabalhar com grandes volumes de dados, seu equipamento local pode não ter memória suficiente para processar os dados pelo Pandas.
Podemos usar um Banco de Dados tradicional como o Oracle, feitos para essas tarefas.

Para esse artigo serão necessários alguns procedimentos preliminares, descritos a seguir:

### Instalação do Instant Client (Basic ou Light) do Oracle

LINUX:
https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-basiclite-linuxx64.rpm

WINDOWS: 
https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html

MacOS: 
https://www.oracle.com/database/technologies/instant-client/macos-intel-x86-downloads.html


### Pacote cx_Oracle

O pacote cx_Oracle é um módulo de extensão Python que permite acesso ao banco de dados. Os programas feitos em Python poderão acessar às bibliotecas do cliente Oracle e ter acesso diretamente à base de dados. A vantagem desse processo está no fato do processamento dos dados serem feitos no Banco de Dados e não na memória da máquina, onde o código Python está rodando.
