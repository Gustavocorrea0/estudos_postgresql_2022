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



-----------------| 17 - Selecionar codigos |-----------------------------------------------------

create view selecionar_produtos_disponiveis

	as select produto.codigo, produto.nome

	from produto

	inner join estoque on produto.id = estoque.id

	where estoque.estoque_atual > 0;

-----------------| 18 - Selecionar produtos |-----------------------------------------------------

create view view_estoque_abaixo_do_estoque_minimo

	as select produto.id, produto.nome

	from produto

	inner join estoque on produto.id = estoque.id

	where estoque.estoque_atual < estoque.estoque_minimo;

-----------------| 19 - Pessoas com 20 anos |-----------------------------------------------

create view view_pessoa_20_anos_no_parana

	as select pessoa.*

	from pessoa 

	inner join endereco on pessoa.endereco_fk = endereco.id

	inner join cidade on endereco.cidade_fk = cidade.id

	inner join estado on cidade.estado_fk = estado.id

	where estado.nome = 'paraná' and pessoa.data_nascimento <= DATE_SUB(CURDATE(), INTERVAL 20 YEAR);

-----------------| 20 - compras em janeiro|-----------------------------------------------------

create view view_compra_em_janeiro 

	as select  pessoa.*

	from pessoa

	inner join pedido_compra on pessoa.id = pedido_compra.pessoa_fk

	where extract(month from pedido_compra.data) = 1;

-----------------| 21 - Cidades com a RN |-----------------------------------------------------

create view view_cidades_rn_com_a

	as select *

	from cidade

	where estado_fk = (

		select id from estado where nome = 'rio grande do normte'

	) and nome like 'a%';

-----------------| 22 - Estados que terminan A |-----------------------------------------------

create view view_estados_terminados_a

	as select *

	from estado

	where nome like '%a';

-----------------| 23 - Pessoas com a |--------------------------------------------------------

create view view_pessoas_com_a_no_nome

	as select *

	from pessoa

	where nome_completo like '%a%';

-----------------| 24 - 5 Estados mais grandes |--------------------------------------------------

create view view_5_estados_mais_grandes

	as select *

	from (

		select estado.*, count(cidade.id) as quantidade_cidades

		from estado

		inner join cidade on estado.id = cidade.estado_fk

		group by estado.id

		order by quantidade_cidades desc

		limit 5

	) as subquery

-----------------| 25 - Vendas agrupadas por tipo de pagamento |--------------------------------

create view view_valor_tipo_de_pagamento 

	as select tipo_pagamento, sum(preco) as valor_total

	from pedido_venda

	join pedido_venda_item on pedido_venda.id = pedido_venda_item.venda_fk

	group by tipo_pagamento;

-----------------| 26 - Estados com mais vendas |-----------------------------------------------

create view view_estado_com_mais_vendas

	as select estado.nome as nome_estado, count(*) as total_vendas from estado

	join cidade on cidade.estado_fk = estado.id

	join pessoa on pessoa.endereco_fk = cidade.id

	join pedido_venda on pedido_venda.pessoa_fk = pessoa.id

	group by estado.id, estado.nome

	order by count(*) desc

	limit 1;

-----------------| 27 - Comprados por mes e por fornecedor |-----------------------------------------------

create view vw_quantidade_produtos_comprados 

 as

 select

    extract(month from pc.data) as mes,

    pc.pessoa_fk as fornecedor,

    count(*) as quantidade

	from

    	pedido_compra pc

	where

    	pc.data >= DATE_TRUNC('year', current_date) 

   		and pc.data < DATE_TRUNC('year', current_date) + INTERVAL '6 months'

	group by

    	mes, fornecedor;



-----------------| 28 - Produtos comprados e vendidosA |------------------------------------------------

create view view_produtos_comprados_e_vendidos

	as select

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

-----------------| 29 - Quantidade de Fornecedores |------------------------------------------------

create view view_quatidade_de_produtos_fornecedores

	as select pessoa.nome_completo as nome_fornecedor, count(*) as quantidade_produtos

	from pessoa

	join produto on pessoa.id = produto.fornecedor_id

	group by pessoa.id, pessoa.nome_completo;

-----------------| 30 - media de idade maio passado |------------------------------------------------

alter table pessoa add column data_nascimento not null;

	create view view_media_idade_maio_anterior 

		as select avg(extract(year from age(current_date, pessoa.data_nascimento))) as media_idade

		from pessoa

		join pedido_compra on pessoa.id = pedido_compra.pessoa_fk

		where extract(month from pedido_compra.data) = 5

 			 and extract(year from pedido_compra.data) = extract(year from current_date) - 1;

-----------------| 31 - Ordenados por preco |------------------------------------------------

	create view view_produtos_ordenados_por_preco 

	as select from pedido_compra_item

	order by preco desc, preco desc;

-----------------| 32 - Meio de pagamento mais utilizado |------------------------------------------------

	create view vw_meio_pagamento_mais_utilizado as

	select pessoa_fk, tipo_pagamento, COUNT(*) AS total_compras

	from pedido_compra

	group by pessoa_fk, tipo_pagamento

	having count(*) = (

		select max(total_compras)

		from (

			select pessoa_fk, count(*) as total_compras

			from pedido_compra

			group by pessoa_fk

		) as subquery

	)