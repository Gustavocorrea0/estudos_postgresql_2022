-----------------1--------------------------------------------
create table cliente (
	id int,
	cpf char(11),
	nome varchar(100),
	numero_conta int,
	telefone char(9),
	cidade varchar(20)
);

create table carro (
	id int,
	chassi char(17),
	modelo varchar(15),
	cor varchar(15),
	ano int,
	valor numeric(10, 3)
);

create table aluguel(
	cliente_id int,
	carro_id int,
	data_entrada date,
	data_saida date,
	total numeric(10, 3)
);
alter table aluguel add column id int;

-----------------2 | Not Null--------------------------------------------
alter table cliente alter column id set not null
alter table cliente alter column cpf set not null
alter table cliente alter column nome set not null
alter table cliente alter column numero_conta set not null

alter table carro alter column id set not null
alter table carro alter column chassi set not null
alter table carro alter column modelo set not null
alter table carro alter column cor set not null
alter table carro alter column ano set not null

alter table aluguel alter column cliente_id set not null
alter table aluguel alter column carro_id set not null
alter table aluguel alter column data_entrada set not null
alter table aluguel alter column id set not null
-----------------3 | PK--------------------------------------------
alter table cliente add constraint id primary key (id);
alter table carro add constraint id_carro primary key (id);
alter table aluguel add constraint id_aluguel primary key (id);
-----------------FK-------------------------------------------------
alter table aluguel add constraint cliente_id foreign key (cliente_id) 
	references cliente (id);
alter table aluguel add constraint carro_id foreign key (carro_id) 
	references carro (id);
-----------------4 | UNIQUE CPF-------------------------------------------------
alter table cliente add constraint cpfUnico unique(cpf);
-----------------5 | UNIQUE NUMERO----------------------------------------------
alter table cliente add constraint numero_conta_unica unique(numero_conta);
-----------------6 | CHECK VALOR POSITIVO---------------------------------------
alter table aluguel add constraint valorPositivo check (total >= 0);
-----------------7 | UNIQUE CHASSI----------------------------------------------
alter table carro add constraint chassi_unico unique(chassi);
-----------------8 | UNIQUE VALOR-----------------------------------------------
alter table carro add constraint valor_positivo check (valor >= 0);



-----------------9 | INSERCAO CLIENTE-------------------------------------------

insert into cliente (id, cpf, nome, numero_conta, telefone, cidade)
values(1, '65279441872', 'ana', 2317, '607014090', 'campinas');

insert into cliente (id, cpf, nome, numero_conta, telefone, cidade)
values(2, '81044016884', 'fábio', 1711, '556143136', 'jundiaí');

insert into cliente (id, cpf, nome, numero_conta, telefone, cidade)
values(3, '23051353868', 'maria', 7121, '319003817', 'são paulo');

insert into cliente (id, cpf, nome, numero_conta, telefone, cidade)
values(4, '80348144822', 'flávio', 2211, '877806249', 'campinas');

insert into cliente (id, cpf, nome, numero_conta, telefone, cidade)
values(5, '73259017712', 'fernando', 1123, '751729316', 'rio de janeiro');

insert into cliente (id, cpf, nome, numero_conta, telefone, cidade)
values(6, '48073859688', 'marta', 3211, '795527302', 'belo horizonte');

-----------------10 | INSERCAO CARRO---------------------------------------------------

insert into carro (id, chassi, modelo, cor, ano)
values
(1, '3Bl8AhKA66KzT9272', 'uno', 'Prata', 2003),
(2, '46AFmvW586a7w1625', 'gol', 'Preto', 2004),
(3, '4AHgN2McAFAvD5971', 'corsa', 'Branco', 2005),
(4, '2L4NbAMrZddCA1692', 'uno', 'Verde', 2001),
(5, '522ju7tn3CwA41672', 'astra', 'Prata', 2005),
(6, '87P4t1KAhKh0z6577', 'gol', 'Prata', 2005);

-----------------11 | INSERCAO ALUGUEL---------------------------------------------------
--                       1          2           3			4         5    6
-- ano/mes/dia
insert into aluguel(cliente_id, carro_id, data_entrada, data_saida, total, id)
values(1, 1, '2022-07-21', '2022-08-05', 0, 1);

insert into aluguel(cliente_id, carro_id, data_entrada, total, id)
values(2, 2, '2022-07-21', 0, 2);

insert into aluguel(cliente_id, carro_id, data_entrada, data_saida, total, id)
values(2, 3, '2022-07-23', '2022-08-06', 0, 3);  

insert into aluguel(cliente_id, carro_id, data_entrada, total, id)
values(2, 4, '2006-07-24', 0, 4);  

-----------------12 | Alterar Cliente----------------------------------------------------
update cliente set telefone = '12345678' where id = 4;
-----------------13 | Alterar Cliente---------------------------------------------------
update cliente set nome = 'Gustavo' where nome = 'fábio';
-----------------14 | Alterar Cliente---------------------------------------------------
update cliente set cidade = 'brasilia' where numero_conta = 2000
-----------------15 | Alterar Carro---------------------------------------------------
update carro set valor = 20000 where valor = 0;
-----------------16 | Alterar Carro---------------------------------------------------
update carro set cor = 'azul' where modelo = 'uno' and modelo = 'corsa';
-----------------17 | Alterar Carro---------------------------------------------------
update aluguel set data_saida = null;
-----------------18 | Excluir Cliente---------------------------------------------------
delete from cliente where cidade = 'campinas';
-----------------19 | Excluir Carro---------------------------------------------------
delete from carro where ano = 2003 and ano = 2004;
-----------------20 | Excluir Carro---------------------------------------------------
delete from carro where chassi = '4AHgN2McAFAvD5971';
-----------------21 | Excluir Carro---------------------------------------------------
delete from carro where modelo = 'gol' and cor = 'prata';
-----------------22 | Alterar Carro---------------------------------------------------
update carro set valor = 2000 where modelo = 'gol';
update carro set valor = 2000 where modelo = 'astra';
update carro set valor = 2000 where modelo = 'uno';
-----------------23 | Alterar Carro---------------------------------------------------
update carro set valor = 1000 where modelo = 'uno';
update carro set valor = 1000 where modelo = 'astra';
-----------------24 | Excluir Carro---------------------------------------------------	  
delete from carro where valor < 2000;
-----------------25 | Excluir Carro---------------------------------------------------	  
delete from aluguel;