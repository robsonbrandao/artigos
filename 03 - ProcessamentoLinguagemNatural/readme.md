# Processamento de Linguagem Natural
---------------------------------------------
## Instalando o pacote spacy e modelos de linguagem

```python
import spacy
```

## Atualizando o spacy

```python
!pip install --upgrade spacy
```


### Chamar o spacy com a nova versão
```python
import spacy
```
```python
!pip install -U spacy-lookups-data
```


## Baixar os modelos de Linguagem
**pt_core_news_lg** é mais completo, porém mais lento

**pt_core_news_st** é a outra opção

```python
!python -m spacy download pt_core_news_lg
```

## Trabalhar com o primeiro texto

```python
texto = 'Inovações na área financeira passam pela análise de dados e pela proteção de dados pessoais. 
O uso da “big data” permitiu gerenciar grande volume de dados — coletados em vários formatos e fontes —, e processá-los rapidamente. 
Um processo de análise, complexo e dispendioso, se destinado a uma reduzida equipe de pessoas, pode facilmente ser aprendido e processado por máquinas, 
com o uso de técnicas de inteligência artificial. Este trabalho focou em levantar dados de uma “fintech” e demonstrar um processo anti-fraude alcançado 
por aprendizado de máquina. Houve toda uma preocupação com a privacidade de dados, conforme a Lei Geral de Proteção de Dados, 
utilizando-se de técnicas para produzir ruídos de dados sem prejudicar os dados estatisticamente. 
Após a coleta de dados, foram aplicadas as técnicas estatísticas para pré-processamento, normalização e padronização. 
Todo o estudo foi feito em linguagem de programação e o modelo foi testado até chegar ao que consideramos ideal por conseguir 
atingir um percentual alto de acerto ao detectar fraudes em dados financeiros usando inteligência artificial'


# Carregar o modelo de linguagem

nlp = spacy.load('pt_core_news_lg')
doc = nlp(texto)
```
--------------------------
# Arquivos, segmentação, tokenização e lematização

```python
arquivo1 = open('texto1.txt','r')
conteudo = arquivo1.read()
conteudo
```
```python
nlp = spacy.load('pt_core_news_lg')
doc = nlp(conteudo)
```

## Segmentação

Separar o texto conforme um separador indicado
```python
sentencas = conteudo.split(".")
sentencas
```
```python
#Quantas sentenças ?
num_sentencas = len(sentencas)
num_sentencas
```

## Tokenização

Separar o textos em unidades

```python
#.orth_ tokens strings
tokens = [token.orth_ for token in doc]
tokens
```


## Lematização

Forma básica da palavra. Sem conjulgação

```python
lemas = [token.lemma_ for token in doc]
lemas
```

## Frequencia, Lei de Zipf e TTR

```python
tokens = [token.orth_ for token in doc]
tokens
```
```python
from collections import Counter

# Saber quantos Tokens (palavras)
Counter(tokens)

# Contagem de tokens.
# Ex: artigos
```

```python
#Ordem decrescente dos tokens

#Tem diferença de CASE

Counter(tokens).most_common()
```


### Os tokens que mais aparecem

```python
Counter(tokens).most_common(5)
```


## Lei de Zift

```python
# transformar as palavras em minúsculo
tokens_pre_processados = [token.orth_.lower for token in doc]

# Eliminar as pontuações
tokens_pre_processados = [token.orth_.lower() for token in doc if token.is_alpha]
```

```python
import matplotlib.pyplot as plt

x=[]
y=[]


for i in Counter(tokens_pre_processados).most_common():
  x.append(i[0])
  y.append(i[1])

plt.xticks(rotation=90)
plt.xticks(range(len(x)),x)
plt.plot(y)

plt.show()
tokens_pre_processados
```
![LeiZipf](https://user-images.githubusercontent.com/12257852/158044197-6efe7a23-bd95-4d08-b4e6-a7c9ae51c283.png)



## TTR - Palavras únicas (mais ricas lexicamente)

```python
# função set() corta repetições
types = list(set(tokens_pre_processados))
types
```
```python
# Quanto mais próximo de 1, maisrico é o texto
ttr = len(types) / len(tokens_pre_processados)
ttr
```

## Tagger - Etiquetador
Classes Gramaticais

```python
#pos = part of speech
# Se não encontrar a classe gramatical, ele usa X
etiquetas = [(token.orth_,token.pos_) for token in doc]
etiquetas
```

```python
classes_gramaticais = []

for i in etiquetas:
  classes_gramaticais.append(i[1])

Counter(classes_gramaticais).most_common()
```

## Parser Sintático
Análise de dependência

```python
analise_dependencia = [(token.orth_,token.dep_) for token in doc]
analise_dependencia
```
```python
from pathlib import Path
```
## Mostra a análise de dependencia gráfica
```python
svg = spacy.displacy.render(doc, style= "dep")
output_path = Path('analisedependencia.svg')
output_path.open('w',encoding="utf-8").write(svg)
```
```python
from IPython.display import SVG
SVG('analisedependencia.svg')
```



## Identificar as entidades nomeadas no texto

```python
entidades = list(doc.ents)
entidades
```

```python
entidades_detalhes = [(entidades, entidades.label_) for entidades in doc.ents]
entidades_detalhes
```
