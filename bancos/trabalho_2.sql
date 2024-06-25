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

------------------------------------------------------------------------

create table produto_log (
	id int not null primary key,
	nome varchar(100) not null,
	modelo varchar(50) null,
	unidade_medida varchar(10) null,
	codigo int not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table pessoa_log (
	id int not null primary key,
	codigo int not null,
	nome_completo varchar(100) not null,
	tipo char(1) not null,
	endereco_fk int null,
	telefone varchar(11) not null,
	email varchar(100) not null,
	nome_contato varchar(100) null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table endereco_log (
	id int not null primary key,
	cidade_fk int not null,
	bairro varchar(100) not null,
	cep char(8) not null,
	logradouro varchar(100) not null,
	complemento varchar(100) null,
	numero varchar(7) not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table cidade_log (
	id int not null primary key,
	estado_fk int not null,
	nome varchar(150) not null,
	codigo_ibge int not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table estado_log (
	id int not null primary key,
	nome varchar(50) not null,
	uf char(2) not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table estoque_log(
	id int not null primary key,
	estoque_minimo numeric(10,3) null,
	estoque_maximo numeric(10,3) null,
	estoque_atual numeric(10,3) not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table tabela_preco_log(
	id int not null primary key,
	preco_unitario_compra numeric(10,2) not null,
	preco_unitario_venda numeric(10,2) not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table pedido_venda_log (
	id int not null primary key,
	pessoa_fk int not null,
	data date not null,
	tipo_pagamento char(1) not null,
	codigo int not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table pedido_venda_item_log (
	venda_fk int not null,
	produto_fk int not null,
	quantidade numeric(10,3) not null,
	preco numeric(10,2) not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table pedido_compra_log (
	id int not null primary key,
	pessoa_fk int not null,
	data date not null,
	tipo_pagamento char(1) not null,
	codigo int not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);

create table pedido_compra_item_log (
	compra_fk int not null,
	produto_fk int not null,
	quantidade numeric(10,3) not null,
	preco numeric(10,2) not null,
	data_modificacao date not null,
	operacao_realizada varchar(6) not null
);
------------------------| Ok |----------------------------

create function auditoria_pedido_compra_item () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into pedido_compra_item_log (compra_fk, produto_fk, quantidade, preco, data_modificacao, operacao_realizada)
		values (new.compra_fk, new.produto_fk, new.quantidade, new.preco, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into pedido_compra_item_log (compra_fk, produto_fk, quantidade, preco, data_modificacao, operacao_realizada)
		values (new.compra_fk, new.produto_fk, new.quantidade, new.preco, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into pedido_compra_item_log (compra_fk, produto_fk, quantidade, preco, data_modificacao, operacao_realizada)
		values (old.compra_fk, old.produto_fk, old.quantidade, old.preco, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------
create function auditoria_pedido_compra () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into pedido_compra_log (pessoa_fk, data, tipo_pagamento, codigo, data_modificacao, operacao_realizada)
		values (new.pessoa_fk, new.data, new.tipo_pagamento, new.codigo, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into pedido_compra_log (pessoa_fk, data, tipo_pagamento, codigo, data_modificacao, operacao_realizada)
		values (new.pessoa_fk, new.data, new.tipo_pagamento, new.codigo, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into pedido_compra_log (pessoa_fk, data, tipo_pagamento, codigo, data_modificacao, operacao_realizada)
		values (old.pessoa_fk, old.data, old.tipo_pagamento, old.codigo, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------
create function auditoria_pedido_venda_item () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into pedido_venda_item_log (venda_fk, produto_fk, quantidade, preco, data_modificacao, operacao_realizada)
		values (new.venda_fk, new.produto_fk, new.quantidade, new.preco, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into pedido_venda_item_log (venda_fk, produto_fk, quantidade, preco, data_modificacao, operacao_realizada)
		values (new.venda_fk, new.produto_fk, new.quantidade, new.preco, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into pedido_venda_item_log (venda_fk, produto_fk, quantidade, preco, data_modificacao, operacao_realizada)
		values (old.venda_fk, old.produto_fk, old.quantidade, old.preco, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------
create function auditoria_pedido_venda () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into pedido_venda_log (pessoa_fk, data, tipo_pagamento, codigo, data_modificacao, operacao_realizada)
		values (new.pessoa_fk, new.data, new.tipo_pagamento, new.codigo, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into pedido_venda_log (pessoa_fk, data, tipo_pagamento, codigo, data_modificacao, operacao_realizada)
		values (new.pessoa_fk, new.data, new.tipo_pagamento, new.codigo, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into pedido_venda_log (pessoa_fk, data, tipo_pagamento, codigo, data_modificacao, operacao_realizada)
		values (old.pessoa_fk, old.data, old.tipo_pagamento, old.codigo, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------
create function auditoria_tabela_preco () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into tabela_preco_log (preco_unitario_compra, preco_unitario_venda, data_modificacao, operacao_realizada)
		values (new.preco_unitario_compra, new.preco_unitario_venda, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into tabela_preco_log (preco_unitario_compra, preco_unitario_venda, data_modificacao, operacao_realizada)
		values (new.preco_unitario_compra, new.preco_unitario_venda, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into tabela_preco_log (preco_unitario_compra, preco_unitario_venda, data_modificacao, operacao_realizada)
		values (old.preco_unitario_compra, old.preco_unitario_venda, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------
create function auditoria_estado () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into estado_log (nome, uf, data_modificacao, operacao_realizada)
		values (new.nome, new.uf, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into estado_log (nome, uf, data_modificacao, operacao_realizada)
		values (new.nome, new.uf, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into estado_log (nome, uf, data_modificacao, operacao_realizada)
		values (old.nome, old.uf, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------

create function auditoria_cidade () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into cidade_log (estado_fk, nome, codigo_ibge, data_modificacao, operacao_realizada)
		values (new.estado_fk, new.nome, new.codigo_ibge, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into cidade_log (estado_fk, nome, codigo_ibge, data_modificacao, operacao_realizada)
		values (new.estado_fk, new.nome, new.codigo_ibge, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into cidade_log (estado_fk, nome, codigo_ibge, data_modificacao, operacao_realizada)
		values (old.estado_fk, old.nome, old.codigo_ibge, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------

create function auditoria_endereco () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into endereco_log (cidade_fk, bairro, cep, logradouro, complemento, numero, data_modificacao, operacao_realizada)
		values (new.cidade_fk, new.bairro, new.cep, new.logradouro, new.complemento, new.numero, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into endereco_log (cidade_fk, bairro, cep, logradouro, complemento, numero, data_modificacao, operacao_realizada)
		values (new.cidade_fk, new.bairro, new.cep, new.logradouro, new.complemento, new.numero, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into endereco_log (cidade_fk, bairro, cep, logradouro, complemento, numero, data_modificacao, operacao_realizada)
		values (old.cidade_fk, old.bairro, old.cep, old.logradouro, old.complemento, old.numero, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------
create function auditoria_pessoa () returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into pessoa_log (codigo, nome_completo, tipo, endereco_fk, telefone, email, nome_contato, data_modificacao, operacao_realizada)
		values (new.codigo, new.nome_completo, new.tipo, endereco_fk, new.telefone, new.email, new.nome_contato, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into pessoa_log (codigo, nome_completo, tipo, endereco_fk, telefone, email, nome_contato, data_modificacao, operacao_realizada)
		values (new.codigo, new.nome_completo, new.tipo, endereco_fk, new.telefone, new.email, new.nome_contato, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into pessoa_log (codigo, nome_completo, tipo, endereco_fk, telefone, email, nome_contato, data_modificacao, operacao_realizada)
		values (old.codigo, old.nome_completo, old.tipo, endereco_fk, old.telefone, old.email, old.nome_contato, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;

------------------------| Ok |----------------------------
create function auditoria_produto() returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into produto_log (nome, modelo, unidade_medida, codigo, data_modificacao, operacao_realizada)
		values (new.nome, new.modelo, new.unidade_medida, new.codigo, new.data_modificacao, new.operacao_realizada, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into produto_log (nome, modelo, unidade_medida, codigo, data_modificacao, operacao_realizada)
		values (new.nome, new.modelo, new.unidade_medida, new.codigo, new.data_modificacao, new.operacao_realizada, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into produto_log (nome, modelo, unidade_medida, codigo, data_modificacao, operacao_realizada)
		values (old.nome, old.modelo, old.unidade_medida, old.codigo, old.data_modificacao, old.operacao_realizada, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;
------------------------| Ok |----------------------------
create function auditoria_estoque() returns trigger as $$
begin
	if (tg_op = 'insert') then 
		insert into estoque_log (produto_fk, estoque_minimo, estoque_maximo, estoque_atual, data_hora, operacao)
		values (new.produto_fk, new.estoque_minimo, new.estoque_maximo, new.estoque_atual, current_timestamp, 'I');
	elseif (tg_op = 'update') then 
		insert into estoque_log (produto_fk, estoque_minimo, estoque_maximo, estoque_atual, data_hora, operacao)
		values (new.produto_fk, new.estoque_minimo, new.estoque_maximo, new.estoque_atual, current_timestamp, 'U');
	elseif (tg_op = 'delete') then
		insert into estoque_log (produto_fk, estoque_minimo, estoque_maximo, estoque_atual, data_hora, operacao)
		values (old.produto_fk, old.estoque_minimo, old.estoque_maximo, old.estoque_atual, current_timestamp, 'D');
	end if;
	return new;
end;
$$ language plpgsql;