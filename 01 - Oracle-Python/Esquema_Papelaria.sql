Drop table produto cascade constraints;
Drop table vendas cascade constraints;
Drop table funcionario cascade constraints;

CREATE TABLE produto (
      idproduto INTEGER NOT NULL,
      nome       VARCHAR2(40) NOT NULL,
      categoria     CHAR(15),
      preco DECIMAL(6, 2),
            
      CONSTRAINT pk_produto PRIMARY KEY (idproduto)
);

CREATE TABLE vendas (
      numpedido      INTEGER NOT NULL,
      codvendedor    INTEGER,
      idproduto      INTEGER,
      quantidade     INTEGER,

      CONSTRAINT pk_vendas PRIMARY KEY (numpedido)
);


CREATE TABLE funcionario (
      codvendedor     INTEGER,
      nome            VARCHAR2(40) NOT NULL,
           
      CONSTRAINT pk_jogador PRIMARY KEY (codvendedor));




















