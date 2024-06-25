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

-----------------------------| 1 - Criar sequencia|-----------------------------------------------------
create sequence seq_produto_id;
-----------------------------| 2 - Alterar a tabela produto|--------------------------------------------
alter table produto alter column id set default nextval('seq_produto_id');
-----------------------------| 3 - Inserir 3 registro no produto|---------------------------------------
insert into produto(nome, modelo, unidade_medida, codigo)
	values ('civic','g10','321', 1);
insert into produto(nome, modelo, unidade_medida, codigo)
	values ('Bmw 320i','2019','212', 2);
insert into produto(nome, modelo, unidade_medida, codigo)
	values ('uno','mille','554', 3);
-----------------------------|4 - Exibir valor atual|----------------------------------------
select currval('seq_produto_id');
-----------------------------| 5 - Criar sequencia 2 em 2|----------------------------------------------
create sequence seq_pessoa_id start with 2 increment by 2;
-----------------------------| 6 - Alter tabela pessoa|-------------------------------------------------
alter table pessoa alter column id set default nextval('seq_pessoa_id');
-----------------------------| 7 - Inserir 2 registros|-------------------------------------------------
insert into pessoa(codigo, nome_completo, tipo, telefone, email, nome_contato)
	values(102,'Gustavo Alfredo Correa Da Silva', 'F',55449999999,'sememail32@gmail.com','gu');
insert into pessoa(codigo, nome_completo, tipo, telefone, email, nome_contato)
	values(103,'Arthur Felipe', 'F', 55441111111,'sememail900@gmail.com','tu');
-----------------------------| 8 - Começar sequencia em 100|--------------------------------------------
alter sequence seq_produto_id increment by 100;
-----------------------------| 9 - Começar sequencia em 4|----------------------------------------------
alter sequence seq_pessoa_id increment by 4;
-----------------------------| 10 - Remover e Rever|----------------------------------------------------
delete from pessoa where id = 2;
select lastval(); -- 4
-----------------------------| 11 - Começa em 100 e diminui 1|------------------------------------------
create sequence seq_decrescente_id start with 100 increment by -1 minvalue 0 maxvalue 100 cache 1;
-----------------------------| 12 - Criar tabela decrescente|-------------------------------------------
create table decrescente(
	id_decrescente int not null primary key,
	valor varchar(10) not null
);
alter table decrescente alter column id_decrescente set default nextval('seq_decrescente_id');
-----------------------------| 13 - Inserir Valores em decrescente|-------------------------------------
do $$
	begin for i in 100..0 loop
	insert into decrecente(valor)
		values(contador, 'Valor ' || i);
	end loop;
end $$;
-----------------------------| 14 - Sequencia cidade|----------------------------------------------------
create sequence seq_cidade_id cache 5;
alter table cidade alter column id set default nextval('seq_cidade_id');
-----------------------------| 15 - Cidades|-------------------------------------------------------------
insert into estado(id, nome, uf)
	values(1, 'parana','pr');
-----------------------------| Query Tool 1|-------------------------------------------------------------	
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Terra Boa', 1, 4127205);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Cianorte', 1, 4105508);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Maringa', 1, 4115200);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Jussara', 1, 4113007);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Japura', 1, 4112405);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Indianopolis', 1, 4110409);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Campo Mourao', 1, 4104303);
	
-----------------------------| Query Tool 2|-------------------------------------------------------------

insert into cidade(nome, estado_fk,codigo_ibge)
	values('Curitiba', 1, 4106902);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Foz do Iguaçu', 1, 4108304);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Engenheiro Beltrão', 1, 4107504);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Dr Camargo', 1, 4107306);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Ivaiporã', 1, 4111506)
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Araruna', 1, 4101705);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Umuarama', 1, 4128104);
insert into cidade(nome, estado_fk,codigo_ibge)
	values('Tapejara', 1, 4126801);





