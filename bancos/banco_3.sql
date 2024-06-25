create table produto (
	id int not null primary key,
	nome varchar(100) not null,
	modelo varchar(50) null,
	unidade_medida varchar(10) null,
	codigo int not null
);

create table pessoa (
	id int not null primary key,
	codigo int not null,
	nome_completo varchar(100) not null,
	tipo char(1) not null,
	endereco_fk int null,
	telefone varchar(11) not null,
	email varchar(100) not null,
	nome_contato varchar(100) null
);

create table endereco (
	id int not null primary key,
	cidade_fk int not null,
	bairro varchar(100) not null,
	cep char(8) not null,
	logradouro varchar(100) not null,
	complemento varchar(100) null,
	numero varchar(7) not null
);

create table cidade (
	id int not null primary key,
	estado_fk int not null,
	nome varchar(150) not null,
	codigo_ibge int not null
);

create table estado (
	id int not null primary key,
	nome varchar(50) not null,
	uf char(2) not null
);

create table estoque(
	id int not null primary key,
	estoque_minimo numeric(10,3) null,
	estoque_maximo numeric(10,3) null,
	estoque_atual numeric(10,3) not null
);

create table tabela_preco(
	id int not null primary key,
	preco_unitario_compra numeric(10,2) not null,
	preco_unitario_venda numeric(10,2) not null
);

create table pedido_venda (
	id int not null primary key,
	pessoa_fk int not null,
	data date not null,
	tipo_pagamento char(1) not null,
	codigo int not null
);

create table pedido_venda_item (
	venda_fk int not null,
	produto_fk int not null,
	quantidade numeric(10,3) not null,
	preco numeric(10,2) not null,
	constraint pedido_venda_item_pkey primary key (venda_fk, produto_fk)
);

create table pedido_compra (
	id int not null primary key,
	pessoa_fk int not null,
	data date not null,
	tipo_pagamento char(1) not null,
	codigo int not null
);

create table pedido_compra_item (
	compra_fk int not null,
	produto_fk int not null,
	quantidade numeric(10,3) not null,
	preco numeric(10,2) not null,
	constraint pedido_compra_item_pkey primary key (compra_fk, produto_fk)
);


alter table cidade 
	add constraint cidade_estado_fk foreign key (estado_fk)
	 	references estado (id);
		
alter table endereco 
	add constraint endereco_cidade_fk foreign key (cidade_fk)
	 	references cidade (id);
		
alter table pessoa
	add constraint pessoa_endereco_fk foreign key (endereco_fk)
		references endereco (id);
		
alter table pedido_venda
	add constraint pedido_venda_pessoa_fk foreign key (pessoa_fk)
		references pessoa (id);
		
alter table pedido_compra
	add constraint pedido_compra_pessoa_fk foreign key (pessoa_fk)
		references pessoa (id);
		
alter table pedido_compra_item
	add constraint pedido_compra_item_compra_fk foreign key (compra_fk)
		references pedido_compra (id);	
		
alter table pedido_compra_item
	add constraint pedido_compra_item_produto_fk foreign key (produto_fk)
		references produto (id);

alter table pedido_venda_item
	add constraint pedido_venda_item_venda_fk foreign key (venda_fk)
		references pedido_venda (id);	
		
alter table pedido_venda_item
	add constraint pedido_venda_item_produto_fk foreign key (produto_fk)
		references produto (id);
		
alter table tabela_preco
	add constraint tabela_preco_produto_fk foreign key (id)
		references produto (id);		
		
alter table estoque
	add constraint estoque_produto_fk foreign key (id)
		references produto (id);		

alter table produto
	add constraint produto_codigo_uk unique (codigo);
	
alter table pessoa
	add constraint pessoa_codigo_uk unique (codigo);
	
alter table cidade
	add constraint cidade_codigo_ibge_uk unique (codigo_ibge);	

alter table estado
	add constraint estado_uf_uk unique (uf);

alter table estado
	add constraint estado_nome_uk unique (nome);
	
alter table pedido_compra
	add constraint pedido_compra_codigo_uk unique (codigo);	

alter table pedido_venda
	add constraint pedido_venda_codigo_uk unique (codigo);	

alter table produto
	add constraint codigo_produto_positivo 
		check (codigo > 0);
		
alter table pessoa
	add constraint checa_pessoa 
		check (codigo > 0 and tipo in ('F', 'J') );	
		
alter table cidade
	add constraint codigo_ibge_positivo 
		check (codigo_ibge > 0);
		
alter table pedido_compra
	add constraint checa_compra 
		check (codigo > 0 and tipo_pagamento in ('M', 'C', 'D', 'P') );	
		
alter table pedido_venda
	add constraint checa_venda 
		check (codigo > 0 and tipo_pagamento in ('M', 'C', 'D', 'P') );
		
alter table pedido_venda_item
	add constraint checa_venda_item
		check (quantidade > 0 and preco > 0);
		
alter table pedido_compra_item
	add constraint checa_compra_item 
		check (quantidade > 0 and preco > 0 );
		
alter table estoque
	add constraint checa_estoque 
		check (estoque_minimo >= 0 and estoque_maximo > 0 and estoque_atual >= 0);
		
alter table tabela_preco
	add constraint checa_tabela_preco
		check (preco_unitario_venda > 0 and preco_unitario_compra > 0);


create index codigo_produto_idx on produto (codigo);
create index codigo_pessoa_idx on pessoa (codigo);
create index nome_pessoa_idx on pessoa (nome_completo);
create index cep_idx on endereco (cep);
create index nome_cidade_idx on cidade (nome);
create index codigo_ibge_idx on cidade (codigo_ibge);
create index codigo_pedido_compra_idx on pedido_compra (codigo);
create index codigo_pedido_venda_idx on pedido_venda (codigo);
create index cidade_estado_idx on cidade (estado_fk);
create index pedido_compra_pessoa_idx on pedido_compra (pessoa_fk);
create index pedido_venda_pessoa_idx on pedido_venda (pessoa_fk);
create index endereco_cidade_idx on endereco (cidade_fk);
create index pessoa_endereco_idx on pessoa (endereco_fk);

-----------------------|1 - Criar Novo usuario|-------------------------------
create user gustavo1379 with password 'senhaextremamentedificil';
-----------------------|2 - Permissão de Select|------------------------------
grant select on pessoa to "gustavo1379";
-----------------------|3 - Remover de Select|--------------------------------
revoke select on pessoa from "gustavo1379";
-----------------------|4 - Criar novo usuario|-------------------------------
create user felisberto with password 'senhaextremamentedificil2'
	valid until '2023-06-10';
-----------------------|5 - Permissão Select|---------------------------------
grant select on all tables in schema public to "felisberto";
-----------------------|6 - Criar novo usuario|-------------------------------
create user gumercindo with password 'senhaextremamentedificil9';
-----------------------|7 - Permissão Select|---------------------------------
grant select on all tables in schema public to "gumercindo";
grant update on all tables in schema public to "gumercindo";
-----------------------|8 - Criar novo usuario|-------------------------------
create user rasso_rafael with password 'senhadificil4';
-----------------------|9 - Permissão|----------------------------------------
grant insert(codigo, nome_completo) on table pessoa to "rasso_rafael";
-----------------------|10 - Revogar Permissão|-------------------------------
revoke all privileges on all tables in schema public from "rasso_rafael";
revoke all privileges on all tables in schema public from "felisberto";
revoke all privileges on all tables in schema public from "gumercindo";
-----------------------|11 - Revogar Permissão|-------------------------------
alter user rasso_rafael rename to pelissari_william;
alter user pelissari_william with password 'novasenhadificil';
-----------------------|12 - Excluir Todos|-----------------------------------
drop user felisberto;
drop user gumercindo;
drop user pelissari_william;
drop user gustavo1379;

