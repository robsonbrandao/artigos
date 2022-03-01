# Acessar banco de dados Oracle pelo Python

Processar datasets usando Pandas é muito prático, mas ninguém entende mais de processamento de dados do que os bancos de dados. Eles possuem mecanismos de consultas otimizadas.
Ao trabalhar com grandes volumes de dados, seu equipamento local pode não ter memória suficiente para processar os dados pelo Pandas.
Podemos usar um Banco de Dados tradicional como o Oracle, feitos para essas tarefas.

Para esse artigo serão necessários alguns procedimentos preliminares, descritos a seguir:

## Instalação do Instant Client (Basic ou Light) do Oracle

LINUX:
https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-basiclite-linuxx64.rpm

WINDOWS: 
https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html

MacOS: 
https://www.oracle.com/database/technologies/instant-client/macos-intel-x86-downloads.html


## Pacote cx_Oracle

O pacote cx_Oracle é um módulo de extensão Python que permite acesso ao banco de dados. Os programas feitos em Python poderão acessar às bibliotecas do cliente Oracle e ter acesso diretamente à base de dados. A vantagem desse processo está no fato do processamento dos dados serem feitos no Banco de Dados e não na memória da máquina, onde o código Python está rodando.

![cx_Oracle](https://user-images.githubusercontent.com/12257852/156086578-abcbdd01-da39-4c4e-a649-b454a4ffce4b.png)

Os programas escritos em Python conversam com as bibliotecas de conexão do Oracle

## Procedimento passo a passo no ambiente Python

#### 1. Abrir um notebook e instale os pacotes necessários

```python
Instalação do Pacote cx_Oracle.
!pip install cx_Oracle
```

#### 2. Carregar as bibliotecas 

```python
import cx_Oracle
import pandas as pd
import sqlalchemy
```
#### 3. Indicar o local onde o cx_Oracle pode encontrar os arquivos do client do Oracle. A pasta usada para concentrar os arquivos nesse tutorial foi C:\Dados.

```python
try:
    cx_Oracle.init_oracle_client(lib_dir=r"D:\Oracle\instantclient_19_11")
except Exception as e:
    print(str(e))
```
#### 4. Carregar o banco de dados Oracle. O método makedsn() cria a conexão com o servidor Oracle e o método connect() efetiva a conexão.

```python
dsnStr = cx_Oracle.makedsn("localhost", "1521", "xe")
conexao = cx_Oracle.connect(user="seu user", password="password", dsn=dsnStr)
print(conexao.version)
```
#### 5. Abrir um cursor. Uma conexão fornece objetos do tipo cursor; os quais permitem operações DDL e DML no banco conectado.

```python
cursorDDL = conexao.cursor()
cursorDML = conexao.cursor()
```
#### 6. Criar tabelas lendo o arquivo Esquema_Papelaria.sql clonado para sua pasta local.

```python
fd = open('./Dados/Esquema_Papelaria.sql', 'r')
sqlFile = fd.read()
fd.close()

A cada ";", fazer um split para separar uma linha de comando de outra.
sqlCommands = sqlFile.split(';') 
for command in sqlCommands:
    if(command == ''): break; 
    try:
        print(command)
        print()
        cursorDDL.execute(command)
    except Exception as msg:
        print("Erro de SQL: "+ str(msg) + ": "+ command)
print('Script finalizado.')

Se o erro invalid SQL statement aparecer, pode IGNORAR! Ocorre por ser o fim do arquivo.
```

#### 7. Inserir registros dentro das tabelas com o arquivo Dados_Papelaria.sql

```python
fd = open('./Dados/Dados_Papelaria.sql', 'r')
# Usar o método read() para ler instruções do arquivo carregados em "fd"
sqlFile = fd.read()
fd.close()

sqlCommands = sqlFile.split(';')
for command in sqlCommands:
 try:
        print(command)
        print()
        cursorDDL.execute(command)        
 except Exception as msg:
        print("Erro de SQL: "+ str(msg) + ": |"+ command+'|')
print('Script finalizado.')
Ignore a mensagem "Erro de SQL: ORA-00900: Instrução SQL Inválida: |"
```
#### 8. Usar o cursorDML para inserir registros também. Para isso é só usar o método execute().

```python
cursorDML.execute("insert into produto values (9,'Lapiseira Pentel 07', 'ambos', (19.80))");

cursorDML.execute("insert into produto values (10,'grampos','escritório', (4.80))");
```
#### 9. Agora podemos confirmar as inserções com commit() ou cancelar tudo com rollback().

```python
conexao.commit()
```
## Recuperando dados com cursores

Pode-se requisitar os dados da base um por vez, o que consome mais recursos de rede e processamento no servidor. 

Há também a possibilidade de requisitar múltiplos dados por vez (batch), sendo este um processo mais eficiente. Se houver memória suficiente — ou poucos dados —, pode-se recuperar todos os dados de uma vez.

- **Recuperando 1 por vez:**
```python
cursorDML.execute("select * from produto where categoria = \'escolar\'")
while True:
    row = cursorDML.fetchone()  #Um por vez
 if row is None: break
    print(row)
```
- **Recuperando por Batch:**
```python
cursorDML.execute("select * from produto")
Lote de 3 em 3 registros (tuplas)
num_rows = 3
while True:
    rows = cursorDML.fetchmany(num_rows) # Muitos por vez
 if not rows: break
 for row in rows:
 print(row)
 
print()
print("Foram recuperadas "+str(cursorDML.rowcount) +" tuplas.")
```

## Lendo dados do banco diretamente para um Pandas Dataframe

Agora trataremos os dados diretamente no Pandas, realizando uma consulta SQL pelo método **read_sql_query()**.


Um dataframe nada mais é do que uma tabela (uma relação) em memória. Muito provavelmente, ler uma tabela inteira em memória vai causar problemas de falta de memória e de processamento. Uma solução é ler pedaços **(chunks)** da tabela em um objeto do tipo generator;

```python
meuDataFrame = pd.read_sql_query('SELECT * FROM produto', con=conexao)
print(meuDataFrame)
```

Pode-se fazer isso usando-se uma variação do read_sql_query() com o parâmetro chunksize fornecido. Neste caso, o resultado não será um DataFrame, mas sim um objeto do tipo generator, o qual fornecerá um DataFrame com chunksize elementos a cada iteração;

```python
dataFrameGenerator = pd.read_sql_query('SELECT * FROM produto', con=conexao, chunksize=3)
type(dataFrameGenerator)
for i, dataFrameChunk in enumerate(dataFrameGenerator):
    print('-'*3)
    print("Chunk "+str(i))
 print(dataFrameChunk)
```

Com o processamento em chunks é possível executar processamento pedaço por pedaço do dataset.

```python
total_precos = 0
dataFrameGenerator = pd.read_sql_query('SELECT * FROM produto', con=conexao, chunksize=3)
for i, dataFrameChunk in enumerate(dataFrameGenerator):
    total_chunk = dataFrameChunk['PRECO'].sum()
 print('Total de precos ' + str(i) + '-esimo chunk: '+str(total_chunk))
    total_precos += total_chunk
print("Total de precos: " + str(total_precos))
```

Lembrando que o processamento de agregações é muito eficiente em SGBDs relacionais. Trazer dados do database para a memória, computar, e depois totalizar só é recomendado para tarefas que não podem ser realizadas em um SGBD, ou que sejam muito complexas. Para o exemplo da totalização, basta um simples SQL:

```python
for row in cursorDML.execute("Select SUM(quantidade) from vendas"): print(row[0])
```


