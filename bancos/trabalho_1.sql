-----------------| Criacao de Tabelas |--------------------------
create table cliente (
	id int,
	nome varchar(100),
	endereco varchar(255), --nao not null
	credito numeric(10, 2),
	tipo char(1),
	cpf char(11)
);

create table fatura (
	id int,
	numero int,
	clienteId int,
	valor numeric(10, 2)
);

create table produto (
	id int not null primary key,
	descricao varchar(100) not null
);

create table fatura_item (
	faturaId int not null,
	produtoId int not null,
	quantidade numeric(10, 2) not null,
	valor numeric(10, 2) not null
);
-----------------| 1A | Not Null |---------------------------------
alter table cliente alter column id set not null
alter table cliente alter column nome set not null
alter table cliente alter column credito set not null
alter table cliente alter column tipo set not null
alter table cliente alter column cpf set not null

alter table fatura alter column id set not null
alter table fatura alter column numero set not null
alter table fatura alter column clienteId set not null
alter table fatura alter column valor set not null
----------------| 1B | Pk |----------------------------------------------------
alter table cliente add constraint id primary key (id);
alter table fatura add constraint idFatura primary key (id);
----------------| 1C | Fk |-----------------------------------------------------
alter table fatura add constraint clienteId foreign key (clienteId) 
	references cliente (idFatura);
alter table fatura_item add constraint faturaId foreign key (faturaId)
	references fatura (id);
alter table fatura_item add constraint produtoId foreign key (produtoId)
	references produto (id);
----------------| 1D | Unique |-------------------------------------------------
alter table cliente add constraint cpfUnico unique(cpf);
----------------| 1E | Check |--------------------------------------------------
alter table fatura add constraint valorPositivo check (valor > 0);
----------------| 1F | Check |--------------------------------------------------
alter table fatura_item add constraint valorItemPositivo check (valor > 0);

----------------| 2A | Criar Historico |----------------------------------------
alter table cliente add column historico varchar(100);
----------------| 2B | Alterar digitos |----------------------------------------
alter table cliente alter column nome type varchar(30);
----------------| 2C | Excluir Campo |------------------------------------------
alter table cliente drop column credito;

----------------| 3A | Alterar nome |-------------------------------------------
alter table fatura rename to pedido;
----------------| 3B | Criar Emissao |------------------------------------------
alter table pedido add column dataEmissao date;

----------------| 4A | Criar preco |--------------------------------------------
alter table produto add column preco_de_compra numeric(10, 2);
----------------| 4B | Alterar Descricao |--------------------------------------
alter table produto alter column descricao type varchar(25);

----------------| 5A | Criar preco |--------------------------------------------
alter table fatura_item add column preco_venda numeric(20, 2);
----------------| 5B | Alterar Variavel Quantidade |----------------------------
alter table fatura_item alter column quantidade type int;
----------------| 5C | Excluir Campo Valor |------------------------------------
alter table fatura_item drop column valor;
----------------| 5D | Alterar nome tabela |------------------------------------
alter table fatura_item rename to pedido_item;
----------------| 5E | Excluir Tabela |-----------------------------------------
drop table pedido_item;