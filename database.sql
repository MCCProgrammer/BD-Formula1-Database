drop table arbitros CASCADE CONSTRAINTS;
drop table carros CASCADE CONSTRAINTS;
drop table circuitos CASCADE CONSTRAINTS;
drop table compete CASCADE CONSTRAINTS;
drop table competidores CASCADE CONSTRAINTS;
drop table corridas CASCADE CONSTRAINTS;
drop table engenheiros CASCADE CONSTRAINTS;
drop table equipas CASCADE CONSTRAINTS;
drop table ingressos CASCADE CONSTRAINTS;
drop table juri CASCADE CONSTRAINTS;
drop table modelos CASCADE CONSTRAINTS;
drop table pertence CASCADE CONSTRAINTS;
drop table pessoas CASCADE CONSTRAINTS;
drop table pilota CASCADE CONSTRAINTS;
drop table pilotos CASCADE CONSTRAINTS;
drop table tabeladepontos CASCADE CONSTRAINTS;
drop table trabalham CASCADE CONSTRAINTS;


--cria a tabelas Pessoas
CREATE TABLE Pessoas (
	idPessoa number(11,0),
	nomePessoa varchar2(100) NOT NULL,
	dataNascimento DATE NOT NULL,
	nacionalidade VARCHAR2(30) NOT NULL
);
alter table Pessoas add constraint pk_pessoas primary key (idPessoa);

--cria a tabela Equipas
CREATE TABLE Equipas (
	nomeEquipa VARCHAR2(30),
	headQuarters VARCHAR2(30) NOT NULL
);
alter table Equipas add constraint pk_equipas primary key (nomeEquipa);

--cria a tabela competidores
CREATE TABLE Competidores (
	idPessoa number(11,0),
	nomeEquipa VARCHAR2(30) NOT NULL,
	salario NUMBER(11,2) NOT NULL
);
alter table Competidores add constraint pk_competidores primary key (idPessoa);
alter table Competidores add constraint non_negative_salary check (salario >= 0);
alter table Competidores add constraint fk_comp_pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoas(idPessoa) ON DELETE CASCADE;
alter table Competidores add constraint fk_comp_equipa FOREIGN KEY (nomeEquipa) REFERENCES Equipas(nomeEquipa) ON DELETE CASCADE;

-- tabela dos Engenheiros
CREATE TABLE Engenheiros (
	idPessoa number(11,0)
);
alter table Engenheiros add constraint pk_engenheiros primary key (idPessoa);
alter table Engenheiros add constraint fk_eng_comp FOREIGN KEY (idPessoa) REFERENCES Competidores(idPessoa) ON DELETE CASCADE;

-- tabela dos Pilotos
CREATE TABLE Pilotos (
	idPessoa number(11,0),
	altura NUMBER(4,2) NOT NULL,
	peso NUMBER(5,2) NOT NULL
);
alter table Pilotos add constraint pk_piloto primary key (idPessoa);
alter table Pilotos add constraint fk_pil_comp FOREIGN KEY (idPessoa) REFERENCES Competidores(idPessoa) ON DELETE CASCADE;

-- tabela dos Arbitros
CREATE TABLE Arbitros (
	idPessoa number(11,0),
	nLicensa VARCHAR2(50) NOT NULL
);
alter table Arbitros add constraint pk_arb primary key (idPessoa);
alter table Arbitros add constraint fk_arb_pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoas(idPessoa) ON DELETE CASCADE;
alter table Arbitros add constraint un_nLic unique (nLicensa);


--tabela dos Circuitos
CREATE TABLE Circuitos (
	nomeCircuito VARCHAR2(100),
	distancia NUMBER(6,3),
	capacidade NUMBER (7,0)
);
alter table Circuitos add constraint pk_circ primary key (nomeCircuito);
alter table Circuitos add constraint positive_capacity CHECK (capacidade > 0);

-- tabela dos Modelos
CREATE TABLE Modelos (
	nomeEquipa VARCHAR2(30),
	nomeModelo VARCHAR2(30),
	peso NUMBER(6,2),
	autonomia NUMBER(6,2),
	horsepower NUMBER,
	motor VARCHAR2(60)
);
alter table Modelos add constraint pk_model PRIMARY KEY (nomeEquipa, nomeModelo);
alter table Modelos add constraint fk_model_equip FOREIGN KEY (nomeEquipa) REFERENCES Equipas(nomeEquipa) ON DELETE CASCADE;

--tabelas dos carros
CREATE TABLE Carros (
	idCarro number(11,0),
	cor VARCHAR2(30) not null,
	nomeEquipa VARCHAR2(30) not null,
	nomeModelo VARCHAR2(30) not null
);
alter table Carros add constraint pk_car PRIMARY KEY (idCarro);
alter table Carros add constraint fk_car_model FOREIGN KEY (nomeEquipa, nomeModelo)
                                                                    	REFERENCES Modelos(nomeEquipa, nomeModelo) ON DELETE CASCADE;

-- tabeladospontos
CREATE TABLE TabelaDePontos (
	posicao NUMBER(3,0),
	pontos NUMBER(4,0) NOT NULL
);
alter table TabelaDePontos add constraint pk_tdp PRIMARY KEY (posicao);
alter table TabelaDePontos add constraint tdp_positive_gt CHECK (posicao > 0);
alter table TabelaDePontos add constraint tdp_posicao_lweq CHECK (posicao <= 20);
alter table TabelaDePontos add constraint tdp_positive_points CHECK (pontos >= 0);

-- tabelas das corridas
CREATE TABLE Corridas (
	nomeCircuito VARCHAR2(100),
	dataCorrida DATE not null,
	voltas NUMBER(2,0) not null,
	chefeArbitragem NUMBER(11,0) not null
);
alter table corridas add constraint pk_corridas PRIMARY KEY (nomeCircuito, dataCorrida);
alter table corridas add constraint fk_corridas_circ FOREIGN KEY (nomeCircuito) REFERENCES Circuitos(nomeCircuito) ON DELETE CASCADE;
alter table corridas add constraint fk_chefe_arb FOREIGN KEY (chefeArbitragem) REFERENCES Arbitros(idPessoa);

-- tabela dos ingressos
CREATE TABLE Ingressos (
	nomeCircuito VARCHAR2(100),
	dataCorrida DATE not null,
	numeroBilhete NUMBER(5,0) not null,
	preco NUMBER(8,2) not null
);
alter table ingressos add constraint pk_ingr PRIMARY KEY (nomeCircuito, dataCorrida, numeroBilhete);
alter table ingressos add constraint fk_ingr_corridas FOREIGN KEY (nomeCircuito, dataCorrida)
                                        	REFERENCES Corridas(nomeCircuito, dataCorrida) ON DELETE CASCADE;
alter table ingressos add constraint ingr_positve_preco CHECK (preco >= 0);

-- tabela dos trabalham
CREATE TABLE Trabalham (
	idPessoa number(11,0),
	nomeCircuito VARCHAR2(100),
	dataCorrida DATE
);
alter table trabalham add constraint pk_trabalham PRIMARY KEY (idPessoa, nomeCircuito, dataCorrida);
alter table trabalham add constraint fk_trabalha_eng FOREIGN KEY (idPessoa) REFERENCES Engenheiros(idPessoa) ON DELETE CASCADE;
alter table trabalham add constraint fk_trabalha_corridas FOREIGN KEY (nomeCircuito, dataCorrida) REFERENCES Corridas(nomeCircuito, dataCorrida) ON DELETE CASCADE;

--tabela Pilota
CREATE TABLE Pilota (
	idPessoa number(11,0),
	idCarro NUMBER(11,0)
);
alter table Pilota add constraint pk_pilota PRIMARY KEY (idPessoa, idCarro);
alter table Pilota add constraint fk_pilota_piloto FOREIGN KEY (idPessoa) REFERENCES Pilotos(idPessoa) ON DELETE CASCADE;
alter table Pilota add constraint fk_pilota_car FOREIGN KEY (idCarro) REFERENCES Carros(idCarro) ON DELETE CASCADE;

--tabela compete
CREATE TABLE Compete (
	idPessoa number(11,0),
	idCarro NUMBER(11,0),
	nomeCircuito VARCHAR2(100),
	dataCorrida DATE,
	posicao NUMBER(3,0),
	tempoConclusao INTERVAL DAY(2) TO SECOND(3)
);
alter table Compete add constraint pk_compete PRIMARY KEY (idPessoa, idCarro, nomeCircuito, dataCorrida);
alter table Compete add constraint fk_compete_pilota FOREIGN KEY (idPessoa, idCarro) REFERENCES Pilota(idPessoa, idCarro) ON DELETE CASCADE;
alter table Compete add constraint fk_compete_corrida FOREIGN KEY (nomeCircuito, dataCorrida) REFERENCES Corridas(nomeCircuito, dataCorrida) ON DELETE CASCADE;
alter table Compete add constraint fk_compete_pontos FOREIGN KEY (posicao) REFERENCES TabelaDePontos(posicao);

--tabela juri
CREATE TABLE Juri (
	nomeCircuito VARCHAR2(100),
	dataCorrida DATE,
	idPessoa number(11,0)
);
alter table Juri add constraint pk_juri PRIMARY KEY (nomeCircuito, dataCorrida, idPessoa);
alter table Juri add constraint fk_juri_corrida FOREIGN KEY (nomeCircuito, dataCorrida) REFERENCES Corridas(nomeCircuito, dataCorrida) ON DELETE CASCADE;
alter table Juri add constraint fk_juri_arbitr FOREIGN KEY (idPessoa) REFERENCES Arbitros(idPessoa) ON DELETE CASCADE;

--tabela Pertence
CREATE TABLE Pertence (
	nomeCircuito VARCHAR2(100),
	dataCorrida DATE,
	numeroBilhete NUMBER(5,0),
	idPessoa number(11,0)
);
alter table Pertence add constraint pk_pertence PRIMARY KEY (nomeCircuito, dataCorrida, numeroBilhete, idPessoa);
alter table Pertence add constraint fk_pertence_ingresso FOREIGN KEY (nomeCircuito, dataCorrida, numeroBilhete)
            	REFERENCES Ingressos(nomeCircuito, dataCorrida, numeroBilhete) ON DELETE CASCADE;
alter table Pertence add constraint fk_pertence_pessoa FOREIGN KEY (idPessoa)
            	REFERENCES Pessoas(idPessoa) ON DELETE CASCADE;
alter table Pertence add constraint un_pessoa unique (idPessoa, nomeCircuito, dataCorrida);

--ajuda na criação do próximo valor dos ids
CREATE SEQUENCE seq_idPessoa START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_idCarro START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE VIEW all_employees AS
SELECT idPessoa, nomeCircuito , dataCorrida FROM Compete
UNION
SELECT idPessoa, nomeCircuito, dataCorrida FROM Trabalham
UNION
SELECT idPessoa, nomeCircuito, dataCorrida FROM Juri;



create or replace view compete_em as 
	select idPessoa, Competidores.nomeEquipa as nomeEquipa, Compete.nomeCircuito as nomeCircuito,
        	Compete.dataCorrida as dataCorrida
	from Pilotos inner join Competidores using (idPessoa)
                    	inner join Pilota using (idPessoa)
                    	inner join Compete using (idPessoa, idCarro);
                        
    

create or replace view ingressos_nao_comprados as
    with A as
    (select nomeCircuito, dataCorrida, count(distinct numeroBilhete) as comprados
    from pertence inner join circuitos using (nomeCircuito)
    group by nomeCircuito, dataCorrida)
    select nomeCircuito, dataCorrida, (circuitos.capacidade - A.comprados) as disponiveis
    from A inner join circuitos using (nomeCircuito);

--trigger para gerrar proximo id da Pessoa
CREATE OR REPLACE TRIGGER trg_Pessoas_id
BEFORE INSERT ON Pessoas
FOR EACH ROW
WHEN (NEW.idPessoa IS NULL)
BEGIN
  :NEW.idPessoa := seq_idPessoa.NEXTVAL;
END;
/

--trigger para gerar o proximo id de carro
CREATE OR REPLACE TRIGGER trg_Carros_id
BEFORE INSERT ON Carros
FOR EACH ROW
WHEN (NEW.idCarro IS NULL)
BEGIN
  :NEW.idCarro := seq_idCarro.NEXTVAL;
END;
/

--trigger para ver se a data de nascimento é valida
CREATE OR REPLACE TRIGGER trg_pessoas_dataNascimento_valida
BEFORE INSERT OR UPDATE ON Pessoas
FOR EACH ROW
BEGIN
  IF :NEW.dataNascimento IS NOT NULL AND :NEW.dataNascimento > SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20010, 'Data de nascimento nao pode ser no futuro.');
  END IF;
END;
/

-- ao adicionar um arbitro, temos que nos certificar de que ele não é um competidor
CREATE OR REPLACE TRIGGER disjoint_arbitros
BEFORE INSERT OR UPDATE ON Arbitros
FOR EACH ROW
DECLARE v_count_comp NUMBER;
BEGIN
    -- Verificar se já é Piloto
    SELECT COUNT(*) INTO v_count_comp FROM Competidores WHERE idPessoa = :NEW.idPessoa;
    IF v_count_comp > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Pessoa ' ||  :NEW.idPessoa ||  ' já é um Competidor. Não pode ser Árbitro.');
    END IF;
END;
/

--ao adicionar um competidor, temos que nos certificar de que ele não é um arbitro
CREATE OR REPLACE TRIGGER disjoint_competidores
BEFORE INSERT OR UPDATE ON Competidores
FOR EACH ROW
DECLARE
  v_count_arb NUMBER;
BEGIN
    -- Verificar se já é Árbitro
    SELECT COUNT(*) INTO v_count_arb FROM Arbitros WHERE idPessoa = :NEW.idPessoa;
    IF v_count_arb > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Pessoa ' || :NEW.idPessoa || ' já é um Árbitro. Não pode ser Competidor.');
    END IF;
END;
/


--ao adicionar nos pilotos ver se ele já não é engenheiro
CREATE OR REPLACE TRIGGER trg_piloto_nao_pode_ser_engenheiro
BEFORE INSERT ON Pilotos
FOR EACH ROW
DECLARE
    v_is_engenheiro NUMBER;
BEGIN
    -- Verifica se a pessoa já está registrada como engenheiro
    SELECT COUNT(*)
    INTO v_is_engenheiro
    FROM Engenheiros e
    WHERE e.idPessoa = :NEW.idPessoa;
    IF v_is_engenheiro > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Esta pessoa (ID: ' || :NEW.idPessoa || ') já está registrada como Engenheiro e não pode ser adicionada como Piloto.');
    END IF;
END;
/

--ao adicionar nos engenheiros ver se ele já não é piloto
CREATE OR REPLACE TRIGGER trg_engenheiro_nao_pode_ser_piloto
BEFORE INSERT ON Engenheiros
FOR EACH ROW
DECLARE
    v_is_piloto NUMBER;
BEGIN
    -- Verifica se a pessoa já está registrada como piloto
    SELECT COUNT(*)
    INTO v_is_piloto
    FROM Pilotos p
    WHERE p.idPessoa = :NEW.idPessoa;
    IF v_is_piloto > 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Esta pessoa (ID: ' || :NEW.idPessoa || ') já está registrada como Piloto e não pode ser adicionada como Engenheiro.');
    END IF;
END;
/

----Inserir chefeArbitragem automaticamente no Juri após inserção em Corridas
CREATE OR REPLACE TRIGGER trg_corridas_ins
AFTER INSERT ON Corridas
FOR EACH ROW
BEGIN
  BEGIN
    INSERT INTO Juri (nomeCircuito, dataCorrida, idPessoa)
    VALUES (:NEW.nomeCircuito, :NEW.dataCorrida, :NEW.chefeArbitragem);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      NULL; 
  END;
END;
/

--no máximo so pode ter 10 entradas em equipas
CREATE OR REPLACE TRIGGER trg_limite_max_equipas
AFTER INSERT ON Equipas
DECLARE
    v_total_equipas NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total_equipas
    FROM Equipas;
    IF v_total_equipas > 10 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não é possível adicionar mais equipas. O limite máximo de 10 equipas foi atingido.');
    END IF;
END;
/


-- Verificar se a corrida tem no máximo 20 pilotos
CREATE OR REPLACE TRIGGER trg_limite_competidores
BEFORE INSERT ON Compete
FOR EACH ROW
DECLARE
    total_competidores NUMBER;
BEGIN
    SELECT COUNT(*) INTO total_competidores
    FROM Compete
    WHERE nomeCircuito = :NEW.nomeCircuito
      AND dataCorrida = :NEW.dataCorrida;
    IF total_competidores >= 20 THEN
        RAISE_APPLICATION_ERROR(-20001,'A corrida em ' || :NEW.nomeCircuito || ' no dia ' 
        || TO_CHAR(:NEW.dataCorrida, 'DD/MM/YYYY') ||' já possui o limite de 20 competidores.'
        );
    END IF;
END;
/


CREATE OR REPLACE TRIGGER no_more_than_two
BEFORE INSERT ON Compete
FOR EACH ROW
DECLARE
    new_team VARCHAR2(30);
    how_many_compete NUMBER;
BEGIN
    SELECT nomeEquipa INTO new_team
    FROM Competidores
    WHERE idPessoa = :NEW.idPessoa;

    SELECT COUNT(*) INTO how_many_compete
    FROM Compete C
    JOIN Competidores CP ON C.idPessoa = CP.idPessoa
    WHERE CP.nomeEquipa = new_team
      AND C.nomeCircuito = :NEW.nomeCircuito
      AND C.dataCorrida = :NEW.dataCorrida;

    IF how_many_compete >= 2 THEN
        RAISE_APPLICATION_ERROR(-20001, 'A equipe "' || new_team || '" já tem 2 pilotos nesta corrida.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER tabelaDePontos_must_be_full
BEFORE INSERT ON compete
FOR EACH ROW
DECLARE
    	total_positions NUMBER;
BEGIN
	SELECT COUNT(distinct posicao) INTO total_positions FROM TabelaDePontos;
	IF (total_positions) < 20 THEN
    	RAISE_APPLICATION_ERROR(
        	-20001,
        	'Não é possível adicionar a relação compete. Já que a tabela de pontos está incompleta.'
    	);
	END IF;
END;
/


create or replace trigger employees_cant_hold
    before insert or update of idPessoa on Pertence
    for each row
    declare
        employee number;
    begin
        select count(*) into employee from all_employees
            where idPessoa = :new.idPessoa and 
                      nomeCircuito  = :new.nomeCircuito  and 
                      dataCorrida = :new.dataCorrida;
        if employee > 0 then
            RAISE_APPLICATION_ERROR(-20010, 'O empregado ' || :new.idPessoa || ' trabalha nessa corrida e não pode ter um ingresso');
        end if;
    end;
/


create or replace trigger less_or_same_tickets_than_capacity
    before insert on ingressos
    for each row
    declare
        amount_of_tickets number;
        circuit_capacity number;
    begin
        select count(distinct numeroBilhete) into amount_of_tickets from ingressos
        where nomeCircuito = :new.nomeCircuito and dataCorrida = :new.dataCorrida;
        select capacidade into circuit_capacity from circuitos
        where nomeCircuito = :new.nomeCircuito;
        if (amount_of_tickets >= circuit_capacity) then
            RAISE_APPLICATION_ERROR(-20010, 'Não há mais espaços disponíveis para essa corrida');
        end if;
        if (amount_of_tickets < circuit_capacity) then
            :new.numeroBilhete := (amount_of_tickets + 1);
        end if;
    end;
/


create or replace trigger must_be_on_same_team
    before insert or update on pilota
    for each row
    declare
        pil_team VARCHAR2(30);
        car_team VARCHAR2(30);
    begin
        select nomeequipa into pil_team from competidores where idPessoa = :new.idPessoa;
        select nomeequipa into car_team from carros where idCarro = :new.idCarro;
        if (pil_team != car_team) then
            RAISE_APPLICATION_ERROR(-20001, 'Erro de tipo 1');
        end if;
    end;
/

create or replace trigger trg_remove_not_chefearbitragem
before delete or update of idpessoa on juri
for each row
declare
    chefe_arb NUMBER(11,0);
begin
    select chefeArbitragem into chefe_arb from corridas
    where corridas.nomeCircuito = :old.nomeCircuito and corridas.dataCorrida = :old.dataCorrida;
    if  (:old.idPessoa = chefe_arb) then
        RAISE_APPLICATION_ERROR(-20001, 'Arbitro ' ||  :old.idPessoa || '  é chefe de arbitragem dessa corrida. Não se pode remover');
    end if;
end;
/


CREATE OR REPLACE PROCEDURE prc_ingressos_corridas(
    p_nomeCircuito VARCHAR2,
    p_dataCorrida DATE,
    p_preco INT
) AS
    v_capacidade NUMBER;
BEGIN
    -- Obtemos a capacidade do circuito
    SELECT capacidade INTO v_capacidade
    FROM Circuitos
    WHERE nomeCircuito = p_nomeCircuito;
    -- Criamos ingressos de 1 até à capacidade
    FOR i IN 1..v_capacidade LOOP
        INSERT INTO Ingressos (
            nomeCircuito, dataCorrida, numeroBilhete, preco
        )
        VALUES (
            p_nomeCircuito, p_dataCorrida, i, p_preco
        );
    END LOOP;
END;
/


commit;
