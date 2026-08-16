CREATE DATABASE [DB_EcommerceAgent]
GO

USE [DB_EcommerceAgent]
GO

CREATE TABLE ReglasChatbot (
    ReglaID INT PRIMARY KEY IDENTITY(1,1),
    NombreRegla VARCHAR(100) NOT NULL,
    AccionDinamica BIT NOT NULL,     
    AccionPython VARCHAR(100) NULL,         
    Activo BIT
);

CREATE TABLE PalabrasClaveRegla (
    PalabraClaveID INT PRIMARY KEY IDENTITY(1,1),
    ReglaID INT NOT NULL REFERENCES ReglasChatbot(ReglaID),
    PalabraClave VARCHAR(100) NOT NULL,
	Activo BIT
);

CREATE TABLE PlantillasRespuesta (
    PlantillaID INT IDENTITY(1,1) PRIMARY KEY,
    ReglaID INT NOT NULL REFERENCES ReglasChatbot(ReglaID),
    TextoRespuesta NVARCHAR(MAX) NOT NULL, 
    Activo BIT
);

CREATE TABLE Conversaciones (
    ConversacionID VARCHAR(50) PRIMARY KEY,
    UsuarioID VARCHAR(100) NULL,
    Idioma VARCHAR(10) NULL,
    UltimaIntencion VARCHAR(50) NULL,
    CarritoID VARCHAR(50) NULL,
    PedidoID VARCHAR(50) NULL,
    FechaInicio DATETIME NOT NULL DEFAULT GETDATE(),
    FechaFin DATETIME NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Mensajes (
    MensajeID BIGINT IDENTITY(1,1) PRIMARY KEY,
    ConversacionID VARCHAR(50) REFERENCES Conversaciones(ConversacionID) NOT NULL,
    Rol VARCHAR(20) NOT NULL,
    ChatBot BIT NOT NULL DEFAULT 0,
    Contenido NVARCHAR(MAX) NOT NULL,
    FechaHora DATETIME NOT NULL DEFAULT GETDATE(),
    ReglaActivadaID INT REFERENCES ReglasChatbot(ReglaID) NULL,
    Intencion VARCHAR(50) NULL,
    Metadata NVARCHAR(MAX) NULL
);
GO

select * from Mensajes
select * from  Conversaciones