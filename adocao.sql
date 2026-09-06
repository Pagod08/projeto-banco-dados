-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS centro_adocao;
USE centro_adocao;-- 1. CRIAÇÃO DAS TABELAS

CREATE TABLE Cliente (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    rua VARCHAR(100), 
    numero VARCHAR(10), 
    bairro VARCHAR(50), 
    cidade VARCHAR(50), 
    cep VARCHAR(8)
);

CREATE TABLE Telefone_Cliente (
    cpf_cliente VARCHAR(11), 
    numero_telefone VARCHAR(15),
    PRIMARY KEY (cpf_cliente, numero_telefone),
    FOREIGN KEY (cpf_cliente) REFERENCES Cliente(cpf) ON DELETE CASCADE
);

CREATE TABLE Funcionario (
    cpf_funcionario VARCHAR(11) PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL, 
    data_admissao DATE NOT NULL
);

CREATE TABLE Veterinario (
    cpf_veterinario VARCHAR(11) PRIMARY KEY, 
    crmv VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (cpf_veterinario) REFERENCES Funcionario(cpf_funcionario) ON DELETE CASCADE
);

CREATE TABLE Atendente (
    cpf_atendente VARCHAR(11) PRIMARY KEY, 
    turno VARCHAR(20),
    FOREIGN KEY (cpf_atendente) REFERENCES Funcionario(cpf_funcionario) ON DELETE CASCADE
);

CREATE TABLE Ficha_Medica (
    id_ficha INT AUTO_INCREMENT PRIMARY KEY, 
    historico_geral TEXT
);

CREATE TABLE Animal (
    id_animal INT AUTO_INCREMENT PRIMARY KEY, 
    nome VARCHAR(50) NOT NULL,
    especie VARCHAR(50) NOT NULL, 
    raca VARCHAR(50), 
    id_ficha INT UNIQUE,
    FOREIGN KEY (id_ficha) REFERENCES Ficha_Medica(id_ficha) ON DELETE SET NULL
);

CREATE TABLE Registro_Vacina (
    id_vacina INT AUTO_INCREMENT PRIMARY KEY, 
    id_animal INT NOT NULL,
    nome_vacina VARCHAR(50) NOT NULL, 
    data_aplicacao DATE NOT NULL,
    FOREIGN KEY (id_animal) REFERENCES Animal(id_animal) ON DELETE CASCADE
);

CREATE TABLE Consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY, 
    id_animal INT NOT NULL, 
    cpf_veterinario VARCHAR(11) NOT NULL,
    data_consulta DATETIME NOT NULL, 
    diagnostico TEXT, 
    peso_atual DECIMAL(5,2),
    FOREIGN KEY (id_animal) REFERENCES Animal(id_animal) ON DELETE CASCADE,
    FOREIGN KEY (cpf_veterinario) REFERENCES Veterinario(cpf_veterinario)
);

CREATE TABLE Adocao (
    id_adocao INT AUTO_INCREMENT PRIMARY KEY, 
    cpf_cliente VARCHAR(11) NOT NULL,
    cpf_atendente VARCHAR(11) NOT NULL, 
    id_animal INT UNIQUE NOT NULL,
    data_adocao DATE NOT NULL, 
    termo_assinado BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (cpf_cliente) REFERENCES Cliente(cpf),
    FOREIGN KEY (cpf_atendente) REFERENCES Atendente(cpf_atendente),
    FOREIGN KEY (id_animal) REFERENCES Animal(id_animal)
);



-- 2. INSERÇÃO DE DADOS
INSERT INTO Cliente VALUES 
('11122233344', 'João Silva', 'Rua A', '12', 'Centro', 'SP', '01001000');

INSERT INTO Telefone_Cliente VALUES 
('11122233344', '11999998888');

INSERT INTO Funcionario VALUES 
('12312312312', 'Dr. Carlos', '2020-01-15'), ('32132132132', 'Ana Souza', '2023-05-10');

INSERT INTO Veterinario VALUES 
('12312312312', 'CRMV-SP 12345');

INSERT INTO Atendente VALUES 
('32132132132', 'Manhã');

INSERT INTO Ficha_Medica (historico_geral) VALUES 
('Resgatado desnutrido.');

INSERT INTO Animal (nome, especie, raca, id_ficha) VALUES 
('Rex', 'Cachorro', 'Vira-lata', 1);

INSERT INTO Registro_Vacina (id_animal, nome_vacina, data_aplicacao) VALUES 
(1, 'V10', '2024-01-10');

INSERT INTO Consulta (id_animal, cpf_veterinario, data_consulta, diagnostico, peso_atual) VALUES 
(1, '12312312312', '2024-01-10 10:30:00', 'Checkup inicial', 12.5);

INSERT INTO Adocao (cpf_cliente, cpf_atendente, id_animal, data_adocao, termo_assinado) VALUES 
('11122233344', '32132132132', 1, '2024-04-20', 1);

-- 3. CONSULTAS E ATUALIZAÇÕES
SELECT Animal.nome, Cliente.nome AS Adotante FROM Adocao
JOIN Animal ON Adocao.id_animal = Animal.id_animal
JOIN Cliente ON Adocao.cpf_cliente = Cliente.cpf;

UPDATE Consulta SET peso_atual = 13.8 WHERE id_consulta = 1;

UPDATE Cliente SET bairro = 'Bela Vista' WHERE cpf = '11122233344';