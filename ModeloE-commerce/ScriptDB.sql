-- Elimina as tabelas na ordem correta para evitar conflitos
DROP TABLE IF EXISTS Entrega;
DROP TABLE IF EXISTS Pedido;
DROP TABLE IF EXISTS FormasPagamento;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Vendedor;
DROP TABLE IF EXISTS ClientePF;
DROP TABLE IF EXISTS ClientePJ;

-- Clientes
CREATE TABLE ClientePF (
    idCliente INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45),
    Identificação VARCHAR(45),
    Endereço VARCHAR(45),
    PRIMARY KEY (idCliente)
);

CREATE TABLE ClientePJ (
    idCliente INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45),
    Identificação VARCHAR(45),
    Endereço VARCHAR(45),
    PRIMARY KEY (idCliente)
);

-- Formas de Pagamento
CREATE TABLE FormasPagamento (
    idFormasPagamento INT NOT NULL AUTO_INCREMENT,
    Tipo VARCHAR(45),
    Detalhes VARCHAR(45),
    ClientePF_idCliente INT NULL,
    ClientePJ_idCliente INT NULL,
    PRIMARY KEY (idFormasPagamento),
    FOREIGN KEY (ClientePF_idCliente) REFERENCES ClientePF(idCliente),
    FOREIGN KEY (ClientePJ_idCliente) REFERENCES ClientePJ(idCliente),
    CHECK (
        (ClientePF_idCliente IS NOT NULL AND ClientePJ_idCliente IS NULL) OR
        (ClientePF_idCliente IS NULL AND ClientePJ_idCliente IS NOT NULL)
    )
);

-- Pedido
CREATE TABLE Pedido (
    idPedido INT NOT NULL AUTO_INCREMENT,
    StatusPedido VARCHAR(45),
    Descrição VARCHAR(45),
    Frete FLOAT,
    ClientePF_idCliente INT NULL,
    ClientePJ_idCliente INT NULL,
    PRIMARY KEY (idPedido),
    FOREIGN KEY (ClientePF_idCliente) REFERENCES ClientePF(idCliente),
    FOREIGN KEY (ClientePJ_idCliente) REFERENCES ClientePJ(idCliente),
    CHECK (
        (ClientePF_idCliente IS NOT NULL AND ClientePJ_idCliente IS NULL) OR
        (ClientePF_idCliente IS NULL AND ClientePJ_idCliente IS NOT NULL)
    )
);

-- Entrega
CREATE TABLE Entrega (
    idEntrega INT NOT NULL AUTO_INCREMENT,
    CodigoRastreio VARCHAR(45),
    Status VARCHAR(45),
    Pedido_idPedido INT NOT NULL,
    PRIMARY KEY (idEntrega),
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
);

-- Produto
CREATE TABLE Produto (
    idProduto INT NOT NULL AUTO_INCREMENT,
    Categoria VARCHAR(45),
    Descrição VARCHAR(45),
    Valor DECIMAL(10,2),
    PRIMARY KEY (idProduto)
);

-- Vendedor
CREATE TABLE Vendedor (
    idVendedor INT NOT NULL AUTO_INCREMENT,
    RazaoSocial VARCHAR(100),
    Local VARCHAR(45),
    CNPJ VARCHAR(18),
    PRIMARY KEY (idVendedor)
);

-- Estoque
CREATE TABLE Estoque (
    idEstoque INT NOT NULL AUTO_INCREMENT,
    Local VARCHAR(100),
    PRIMARY KEY (idEstoque)
);

-- ========== INSERINDO DADOS DE TESTE ==========

-- Clientes
INSERT INTO ClientePF (Nome, Identificação, Endereço)
VALUES ('João Silva', '123456789', 'Rua A, 123');

INSERT INTO ClientePJ (Nome, Identificação, Endereço)
VALUES ('Empresa XYZ Ltda', '987654321', 'Avenida B, 456');

-- Formas de Pagamento
INSERT INTO FormasPagamento (Tipo, Detalhes, ClientePF_idCliente)
VALUES ('Cartão de Crédito', 'Visa final 1234', 1);

INSERT INTO FormasPagamento (Tipo, Detalhes, ClientePJ_idCliente)
VALUES ('Pix', 'pix@empresa.com.br', 1);

-- Pedidos
INSERT INTO Pedido (StatusPedido, Descrição, Frete, ClientePF_idCliente)
VALUES ('Aguardando pagamento', 'Pedido de teste para PF', 15.00, 1);

INSERT INTO Pedido (StatusPedido, Descrição, Frete, ClientePJ_idCliente)
VALUES ('Pago', 'Pedido de teste para PJ', 20.00, 1);

-- Entregas
INSERT INTO Entrega (CodigoRastreio, Status, Pedido_idPedido)
VALUES ('BR1234567890', 'Em trânsito', 1);

-- Produtos
INSERT INTO Produto (Categoria, Descrição, Valor)
VALUES ('Eletrônico', 'Fone de ouvido Bluetooth', 199.90),
       ('Vestuário', 'Camisa Polo', 79.90);

-- Vendedor
INSERT INTO Vendedor (RazaoSocial, Local, CNPJ)
VALUES ('TechVendas S.A.', 'Centro - SP', '12.345.678/0001-90');

-- Estoque
INSERT INTO Estoque (Local)
VALUES ('Galpão 1 - Zona Norte');

-- ========== Queries ==========

-- Lista todos os clientes pessoa física
SELECT * FROM ClientePF;

-- Lista todos os produtos disponíveis
SELECT * FROM Produto;

-- Recupera pedidos com frete maior que 18 reais
SELECT * FROM Pedido
WHERE Frete > 18;

-- Lista clientes PJ localizados na "Avenida B, 456"
SELECT * FROM ClientePJ
WHERE Endereço = 'Avenida B, 456';

-- Exibe pedidos e calcula o valor total com frete (simulando produto de R$100 só pra exemplo)
SELECT 
    idPedido,
    Descrição,
    Frete,
    (Frete + 100) AS ValorTotalEstimado
FROM Pedido;

-- Adiciona um campo "NomeCompleto" fictício
SELECT 
    idCliente,
    CONCAT(Nome, ' - ID: ', Identificação) AS NomeCompleto
FROM ClientePF;

-- Lista pedidos ordenados pelo maior frete
SELECT * FROM Pedido
ORDER BY Frete DESC;

-- Lista formas de pagamento ordenadas por tipo (ascendente)
SELECT * FROM FormasPagamento
ORDER BY Tipo ASC;

-- Conta quantos pedidos cada tipo de status tem e filtra só os com mais de 1
SELECT 
    StatusPedido,
    COUNT(*) AS Total
FROM Pedido
GROUP BY StatusPedido
HAVING COUNT(*) > 1;


-- Junta Pedido com ClientePF
SELECT 
    p.idPedido,
    p.Descrição,
    p.Frete,
    c.Nome AS NomeCliente
FROM Pedido p
JOIN ClientePF c ON p.ClientePF_idCliente = c.idCliente;

-- Junta Pedido com Entrega
SELECT 
    p.idPedido,
    p.StatusPedido,
    e.CodigoRastreio,
    e.Status AS StatusEntrega
FROM Pedido p
JOIN Entrega e ON e.Pedido_idPedido = p.idPedido;

-- Junta Pedido com ClientePJ e Formas de Pagamento (PJ)
SELECT 
    pj.Nome AS NomeEmpresa,
    p.idPedido,
    f.Tipo AS FormaPagamento
FROM Pedido p
JOIN ClientePJ pj ON p.ClientePJ_idCliente = pj.idCliente
JOIN FormasPagamento f ON f.ClientePJ_idCliente = pj.idCliente;
