-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: 29-Mar-2018 às 20:21
-- Versão do servidor: 10.1.26-MariaDB-0+deb9u1
-- PHP Version: 7.0.27-0+deb9u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ifsup`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `configuracao`
--

CREATE TABLE `configuracao` (
  `idconfiguracao` int(11) NOT NULL,
  `AUTH_TIMEOUT` int(11) NOT NULL COMMENT 'Tempo de espera por resposta do cliente em segundos.',
  `TIME_ACK` int(11) NOT NULL COMMENT 'Tempo de espera após a confirmação de entrega da mensagem ao cliente em segundos.',
  `SERVER_IPv4` text NOT NULL COMMENT 'IP do servidor onde receberá as conexões.',
  `SERVER_IPv6` text NOT NULL,
  `SERVER_PORT` int(11) NOT NULL COMMENT 'Porta inicial que o servidor irá usar para a conexão com os clientes, caso esteja ocupada, usará a próxima disponível.',
  `CLIENT_PORT` int(11) NOT NULL COMMENT 'Número da porta dos clientes.',
  `QUOTA_DEFAULT` int(11) NOT NULL,
  `ROOT_PATH` text NOT NULL,
  `LOG_LEVEL` int(11) NOT NULL COMMENT '0=debug, 1=low, 2=normal',
  `LOG_PATH` text NOT NULL COMMENT 'Localização dos arquivos de log.',
  `LOG_FILENAME` text NOT NULL COMMENT 'Nome do arquivo de log.',
  `ALERT_TIMEOUT` int(11) NOT NULL COMMENT 'Tempo que a janela de aviso ficará visível ao usuário.',
  `AUTH_METHOD` int(11) NOT NULL COMMENT '1=MySQL; 2=LDAP; 3=LDAP-MySQL; 4=MySQL+LDAP; 5=MySQL+LDAP(With auto-creation of account from LDAP).',
  `SPOOL_PATH` text NOT NULL COMMENT 'Local do spool da impressora virtual.',
  `DOMAIN` text NOT NULL COMMENT 'Dominio a ser resolvido para o endereço completo das impressoras',
  `LDAP_USER` text NOT NULL COMMENT 'User Full Qualified for access to base',
  `LDAP_PASSWORD` text NOT NULL COMMENT 'Password of LDAP user for auth',
  `LDAP _ADDRESS` text NOT NULL COMMENT 'Address of LDAP server',
  `LDAP_BASE` text NOT NULL COMMENT 'LDAP base DN for search',
  `LDAP _OUTPUT` text NOT NULL COMMENT 'Empty for all output searches',
  `LDAP_FILTER` text NOT NULL COMMENT 'Filtro para pesquisa no LDAP',
  `OS_TYPE` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `configuracao`
--

INSERT INTO `configuracao` (`idconfiguracao`, `AUTH_TIMEOUT`, `TIME_ACK`, `SERVER_IPv4`, `SERVER_IPv6`, `SERVER_PORT`, `CLIENT_PORT`, `QUOTA_DEFAULT`, `ROOT_PATH`, `LOG_LEVEL`, `LOG_PATH`, `LOG_FILENAME`, `ALERT_TIMEOUT`, `AUTH_METHOD`, `SPOOL_PATH`, `DOMAIN`, `LDAP_USER`, `LDAP_PASSWORD`, `LDAP _ADDRESS`, `LDAP_BASE`, `LDAP _OUTPUT`, `LDAP_FILTER`, `OS_TYPE`) VALUES
(1, 80, 1, '10.0.0.90', '::1', 5000, 8888, 10, '/opt/ifsup/Server', 0, '/opt/ifsup/Server/logs', 'default.log', 8, 1, '/opt/ifsup/Server/bin/spool', 'pizza.sytes.net', 'cn=Manager,dc=ifsuldeminas,dc=edu,dc=br', 'SENHA_DO_LDAP', '10.0.0.90', 'ou=pessoas,ou=inconfidentes,dc=ifsuldeminas,dc=edu,dc=br', 'cn userPassword', 'uid', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `grupo`
--

CREATE TABLE `grupo` (
  `idgrupo` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `quota_tipo` varchar(10) NOT NULL,
  `quota` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `grupo`
--

INSERT INTO `grupo` (`idgrupo`, `nome`, `quota_tipo`, `quota`) VALUES
(1, 'padrao', 'mensal', -1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `impressora`
--

CREATE TABLE `impressora` (
  `idimpressora` int(11) NOT NULL,
  `nome` varchar(25) NOT NULL,
  `descricao` varchar(100) NOT NULL,
  `local` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `impressora`
--

INSERT INTO `impressora` (`idimpressora`, `nome`, `descricao`, `local`) VALUES
(1, 'PDF', 'Impressora PDF Virtual', 'ItSelf'),
(3, 'printer01', 'Kyocera Ecosys M2035dn/L', 'Recepção do Prédio Principal');

-- --------------------------------------------------------

--
-- Estrutura da tabela `log`
--

CREATE TABLE `log` (
  `idlog` int(11) NOT NULL,
  `data` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `codigoerro` int(11) NOT NULL,
  `ip` text NOT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `idimpressora` int(11) NOT NULL,
  `mensagem` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `relatorio`
--

CREATE TABLE `relatorio` (
  `idrelatorio` int(11) NOT NULL,
  `dia` int(11) NOT NULL,
  `mes` int(11) NOT NULL,
  `ano` int(11) NOT NULL,
  `horario` time NOT NULL,
  `data` date NOT NULL,
  `numero_paginas` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idimpressora` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `relatorio`
--

INSERT INTO `relatorio` (`idrelatorio`, `dia`, `mes`, `ano`, `horario`, `data`, `numero_paginas`, `idusuario`, `idimpressora`) VALUES
(2, 29, 3, 2018, '20:19:27', '2018-03-29', 1, 7, 3);

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `senha` text NOT NULL,
  `quota` int(11) NOT NULL,
  `idgrupo` int(11) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`idusuario`, `nome`, `usuario`, `senha`, `quota`, `idgrupo`, `admin`) VALUES
(7, 'Test user Default', 'ifsup', '{md5}/v9RALtk0201cyy+q4K1MA==', 5, 1, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `configuracao`
--
ALTER TABLE `configuracao`
  ADD PRIMARY KEY (`idconfiguracao`);

--
-- Indexes for table `grupo`
--
ALTER TABLE `grupo`
  ADD PRIMARY KEY (`idgrupo`);

--
-- Indexes for table `impressora`
--
ALTER TABLE `impressora`
  ADD PRIMARY KEY (`idimpressora`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `idimpressora` (`idimpressora`),
  ADD KEY `idusuario` (`idusuario`);

--
-- Indexes for table `relatorio`
--
ALTER TABLE `relatorio`
  ADD PRIMARY KEY (`idrelatorio`),
  ADD KEY `fk_relatorio_usuario1_idx` (`idusuario`),
  ADD KEY `fk_relatorio_impressora1_idx` (`idimpressora`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idusuario`),
  ADD KEY `fk_usuario_grupo_idx` (`idgrupo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `configuracao`
--
ALTER TABLE `configuracao`
  MODIFY `idconfiguracao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `grupo`
--
ALTER TABLE `grupo`
  MODIFY `idgrupo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `impressora`
--
ALTER TABLE `impressora`
  MODIFY `idimpressora` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `relatorio`
--
ALTER TABLE `relatorio`
  MODIFY `idrelatorio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `log`
--
ALTER TABLE `log`
  ADD CONSTRAINT `fk_log_impressora2` FOREIGN KEY (`idimpressora`) REFERENCES `impressora` (`idimpressora`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_log_usuario2` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `relatorio`
--
ALTER TABLE `relatorio`
  ADD CONSTRAINT `fk_relatorio_impressora1` FOREIGN KEY (`idimpressora`) REFERENCES `impressora` (`idimpressora`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_relatorio_usuario1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_grupo` FOREIGN KEY (`idgrupo`) REFERENCES `grupo` (`idgrupo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
