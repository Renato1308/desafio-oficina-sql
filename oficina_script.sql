-- Criação das Tabelas (DDL)

CREATE TABLE Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT
);

CREATE TABLE Veiculos (
    id_veiculo SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES Clientes(id_cliente),
    placa CHAR(7) UNIQUE NOT NULL,
    modelo VARCHAR(50),
    marca VARCHAR(50)
);

CREATE TABLE Mecanicos (
    id_mecanico SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50)
);

CREATE TABLE Ordens_Servico (
    id_os SERIAL PRIMARY KEY,
    id_veiculo INT REFERENCES Veiculos(id_veiculo),
    id_mecanico INT REFERENCES Mecanicos(id_mecanico),
    data_emissao DATE NOT NULL DEFAULT CURRENT_DATE,
    valor_total DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(30) CHECK (status IN ('Aberta', 'Em análise', 'Aguardando Peça', 'Concluída', 'Cancelada')),
    data_conclusao DATE
);

CREATE TABLE Servicos_Itens (
    id_item SERIAL PRIMARY KEY,
    id_os INT REFERENCES Ordens_Servico(id_os) ON DELETE CASCADE,
    descricao_servico VARCHAR(255),
    valor_unitario DECIMAL(10,2) NOT NULL
);

-- Inserindo Dados
INSERT INTO Clientes (nome, telefone) VALUES ('Renato Silva', '11999999999');
INSERT INTO Veiculos (id_cliente, placa, modelo, marca) VALUES (1, 'ABC1234', 'Civic', 'Honda');
INSERT INTO Mecanicos (nome, especialidade) VALUES ('Mestre Kiko', 'Motores');

-- Criando uma Ordem de Serviço
INSERT INTO Ordens_Servico (id_veiculo, id_mecanico, status, valor_total) 
VALUES (1, 1, 'Aberta', 450.00);

-- Detalhando o serviço
INSERT INTO Servicos_Itens (id_os, descricao_servico, valor_unitario) 
VALUES (1, 'Troca de Óleo', 150.00), (1, 'Revisão de Freios', 300.00);

--Qual o valor total de serviços por mecânico? (GROUP BY + JOIN)
SELECT m.nome, SUM(os.valor_total) as total_gerado
FROM Mecanicos m
JOIN Ordens_Servico os ON m.id_mecanico = os.id_mecanico
GROUP BY m.nome;

--Listar veículos e seus donos onde o status da OS é 'Aberta'? (WHERE + JOIN)
SELECT c.nome, v.modelo, os.status
FROM Clientes c
JOIN Veiculos v ON c.id_cliente = v.id_cliente
JOIN Ordens_Servico os ON v.id_veiculo = os.id_veiculo
WHERE os.status = 'Aberta';