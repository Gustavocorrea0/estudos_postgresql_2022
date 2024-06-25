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

alter table pessoa add column idade int not null;

---------------------------|1 - Estoque Disponivel|--------------------------------------------------------
select id, nome from produto 
	where id in (select id from estoque where estoque_atual > 0);
---------------------------|2 - Estoque Abaixo do minimo|--------------------------------------------------
select id, nome from produto where id in(
	select id from estoque where estoque_atual < estoque_minimo 
);
---------------------------|3 - Pessoas de 20 anos/Parana|--------------------------------------------------
select id, nome from pessoa(
	where estado = 'parana' and idade >= 20;
---------------------------|4 - Pessoas que compraram em janeiro|--------------------------------------------
select nome_completo from pessoa where id in(
	select id from pedido_compra where data >= '2022-01-31'
);
---------------------------|5 - Cidades Rio grande do norte com A|-------------------------------------------
select * from cidade where estado_fk = (select id from estado 
	where nome = 'Rio Grande do Norte')and nome like 'A%';
---------------------------|6 - Estados que terminam com a letra A|------------------------------------------
select * from estado where nome like '%A';
---------------------------|7 - Pessoas que possuem A no nome|-----------------------------------------------
select * from pessoa where nome_completo like '%A%';
---------------------------|8 - Selecionar os 5 maiores estados|---------------------------------------------
select * from estado order by (select count(*) from cidade 
	where cidade.estado_fk = cidade.id) desc limit 5;
---------------------------|9- Vendas agrupadas por tipo de pagamento|---------------------------------------
alter table pedido_venda add column  preco numeric(10, 2) not null;
select tipo_pagamento, sum(preco) as valor_total_vendas from pedido_venda group by tipo_pagamento;
---------------------------|10 - Estado com mais vendas|-----------------------------------------------------
select estado.nome as nome_estado, count(*) as total_vendas from estado
	join cidade on cidade.estado_fk = estado.id
	join pessoa on pessoa.endereco_fk = cidade.id
	join pedido_venda on pedido_venda.pessoa_fk = pessoa.id
	group by estado.id, estado.nome
	order by count(*) desc
	limit 1;
---------------------------|11 - FALTA ESSA|-----------------------------------------------------	
select extract(month from pc.data) as mes,
       p.nome_completo as fornecedor,
       SUM(pci.quantidade) as quantidade_comprada
from pedido_compra pc
join pedido_compra_item pci on pc.id = pci.compra_fk
join pessoa p on pc.pessoa_fk = p.id
where pc.data >= DATE_TRUNC('YEAR', CURRENT_DATE)
      and pc.data < DATE_TRUNC('YEAR', CURRENT_DATE) + INTERVAL '6 months'
group by mes, fornecedor;
---------------------------|12 - Quantidade comprada|--------------------------------------------------------
select
	extract(year_month from pedido_compra.data) as mes_compra,
    extract(year_month from pedido_venda.data) as mes_venda, produto.nome as nome_produto,
    sum(pedido_compra_item.quantidade) as quantidade_comprada,
    sum(pedido_venda_item.quantidade) as quantidade_vendida
FROM produto
	LEFT JOIN pedido_compra_item on pedido_compra_item.produto_fk = produto.id
	LEFT JOIN pedido_compra on pedido_compra.id = pedido_compra_item.compra_fk
	LEFT JOIN pedido_venda_item on pedido_venda_item.produto_fk = produto.id
	LEFT JOIN pedido_venda on pedido_venda.id = pedido_venda_item.venda_fk
group by mes_compra, mes_venda, produto.nome;
---------------------------|13 - Quantidade de comprada/vendida|----------------------------------------------
alter table produto add column  fornecedor varchar(50) not null;
select fornecedor.id as id_fornecedor, fornecedor.nome as nome_fornecedor,
    count(*) as quantidade_produtos_fornecidos
	from fornecedor
	join produto on produto.fornecedor_fk = fornecedor.id
group fornecedor.id, fornecedor.nome;
---------------------------|14 - Maio Passado|-----------------------------------------------------------------
select avg(pessoa.idade) as media_idade from pessoa
join pedido_compra on pedido_compra.pessoa_fk = pessoa.id
where extract(year from pedido_compra.data) = extract(year from current_date) - 1
and extract(month from pedido_compra.data) = 5;
---------------------------|15 - ordenar|----------------------------------------------------------------------
select produto.nome, tabela_preco.preco_unitario_venda, tabela_preco.preco_unitario_compra
from produto join tabela_preco on tabela_preco.id = produto.id order by tabela_preco.preco_unitario_venda
desc, tabela_preco.preco_unitario_compra desc;
---------------------------|16 - ordenar|----------------------------------------------------------------------
select tipo_pagamento , count(*) as total from pedido_compra
group by tipo_pagamento order by total desc limit 1;


