-- Cliente base (abstrato)
CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT
);

-- Pessoa Física
CREATE TABLE ClientePF (
    idCliente INT PRIMARY KEY,
    Nome VARCHAR(45),
    Contato VARCHAR(45),
    Endereco VARCHAR(45),
    CPF VARCHAR(14),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Pessoa Jurídica
CREATE TABLE ClientePJ (
    idCliente INT PRIMARY KEY,
    RazaoSocial VARCHAR(45),
    Contato VARCHAR(45),
    CNPJ VARCHAR(18),
    Endereco VARCHAR(45),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Veículo
CREATE TABLE Veiculo (
    idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
    PlacaVeiculo VARCHAR(45),
    Conserto VARCHAR(45),
    Revisao VARCHAR(45),
    idEquipeMecanicos INT,
    FOREIGN KEY (idEquipeMecanicos) REFERENCES EquipeMecanicos(idEquipeMecanicos)
);

-- Mecânico
CREATE TABLE Mecanico (
    idMecanico INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(45),
    Endereco VARCHAR(45),
    Especialidade VARCHAR(45)
);

-- Equipe de mecânicos
CREATE TABLE EquipeMecanicos (
    idEquipeMecanicos INT PRIMARY KEY AUTO_INCREMENT
);

-- Ligação entre equipe e mecânico (relacionamento N:N)
CREATE TABLE Equipe_Mecanico (
    idEquipeMecanicos INT,
    idMecanico INT,
    PRIMARY KEY (idEquipeMecanicos, idMecanico),
    FOREIGN KEY (idEquipeMecanicos) REFERENCES EquipeMecanicos(idEquipeMecanicos),
    FOREIGN KEY (idMecanico) REFERENCES Mecanico(idMecanico)
);

-- Ordem de serviço
CREATE TABLE OrdemDeServico (
    idOrdemDeServico INT PRIMARY KEY AUTO_INCREMENT,
    DataDeEmissao DATE,
    Valor FLOAT,
    ValorPeca FLOAT,
    Status VARCHAR(45),
    DataDeConclusao DATE,
    idEquipeMecanicos INT,
    FOREIGN KEY (idEquipeMecanicos) REFERENCES EquipeMecanicos(idEquipeMecanicos)
);

-- Inserir Clientes
INSERT INTO Cliente VALUES (1);
INSERT INTO Cliente VALUES (2);

-- Inserir Cliente PF
INSERT INTO ClientePF (idCliente, Nome, Contato, Endereco, CPF)
VALUES (1, 'João da Silva', '11999999999', 'Rua A, 123', '123.456.789-00');

-- Inserir Cliente PJ
INSERT INTO ClientePJ (idCliente, RazaoSocial, Contato, CNPJ, Endereco)
VALUES (2, 'Empresa XYZ Ltda', '1144444444', '12.345.678/0001-00', 'Av. Central, 456');

-- Inserir Equipes de Mecânicos
INSERT INTO EquipeMecanicos (idEquipeMecanicos) VALUES (1);

-- Inserir Mecânicos
INSERT INTO Mecanico (idMecanico, Nome, Endereco, Especialidade)
VALUES (1, 'Carlos Mota', 'Rua B, 321', 'Motor');

INSERT INTO Mecanico (idMecanico, Nome, Endereco, Especialidade)
VALUES (2, 'Ana Torres', 'Rua C, 654', 'Freios');

-- Relacionar mecânicos à equipe
INSERT INTO Equipe_Mecanico (idEquipeMecanicos, idMecanico) VALUES (1, 1);
INSERT INTO Equipe_Mecanico (idEquipeMecanicos, idMecanico) VALUES (1, 2);

-- Inserir Veículos
INSERT INTO Veiculo (idVeiculo, PlacaVeiculo, Conserto, Revisao, idEquipeMecanicos)
VALUES (1, 'ABC-1234', 'Troca de correia', 'Revisão geral', 1);

-- Inserir Ordem de Serviço
INSERT INTO OrdemDeServico (idOrdemDeServico, DataDeEmissao, Valor, ValorPeca, Status, DataDeConclusao, idEquipeMecanicos)
VALUES (1, '2025-03-31', 1200.00, 300.00, 'Em Andamento', NULL, 1);


SELECT * FROM ClientePF;

SELECT * FROM Mecanico WHERE Especialidade = 'Motor';

SELECT Nome, Valor, ValorPeca, (Valor + ValorPeca) AS ValorTotal
FROM OrdemDeServico;

SELECT * FROM OrdemDeServico
ORDER BY DataDeEmissao DESC;

SELECT idEquipeMecanicos, COUNT(*) AS TotalServicos
FROM OrdemDeServico
GROUP BY idEquipeMecanicos
HAVING COUNT(*) > 0;

SELECT 
  o.idOrdemDeServico,
  o.Status,
  v.PlacaVeiculo,
  e.idEquipeMecanicos,
  m.Nome AS NomeMecanico
FROM OrdemDeServico o
JOIN EquipeMecanicos e ON o.idEquipeMecanicos = e.idEquipeMecanicos
JOIN Equipe_Mecanico em ON e.idEquipeMecanicos = em.idEquipeMecanicos
JOIN Mecanico m ON em.idMecanico = m.idMecanico
JOIN Veiculo v ON e.idEquipeMecanicos = v.idEquipeMecanicos;


SELECT 
  o.idOrdemDeServico,
  o.Status,
  v.PlacaVeiculo,
  e.idEquipeMecanicos,
  m.Nome AS NomeMecanico
FROM OrdemDeServico o
JOIN EquipeMecanicos e ON o.idEquipeMecanicos = e.idEquipeMecanicos
JOIN Equipe_Mecanico em ON e.idEquipeMecanicos = em.idEquipeMecanicos
JOIN Mecanico m ON em.idMecanico = m.idMecanico
JOIN Veiculo v ON e.idEquipeMecanicos = v.idEquipeMecanicos;
