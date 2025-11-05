
CREATE OR ALTER PROCEDURE sp_Carregar_AIH_Hospitalar
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- 1. Primeiro apague se existe
        IF OBJECT_ID('Staging_AIH_Hospitalar', 'U') IS NOT NULL
            DROP TABLE Staging_AIH_Hospitalar;

        -- 2. Crie com TODOS os nomes bonitinhos
        CREATE TABLE Staging_AIH_Hospitalar (
            UF_ZI VARCHAR(10),
            ANO_CMPT VARCHAR(10),
            MES_CMPT VARCHAR(10),
            ESPEC VARCHAR(100),
            CGC_HOSP VARCHAR(50),
            N_AIH VARCHAR(50),
            IDENT VARCHAR(50),
            CEP VARCHAR(20),
            MUNIC_RES VARCHAR(100),
            NASC VARCHAR(20),
            SEXO VARCHAR(10),
            UTI_MES_IN VARCHAR(10),
            UTI_MES_AN VARCHAR(10),
            UTI_MES_AL VARCHAR(10),
            UTI_MES_TO VARCHAR(10),
            MARCA_UTI VARCHAR(10),
            UTI_INT_IN VARCHAR(10),
            UTI_INT_AN VARCHAR(10),
            UTI_INT_AL VARCHAR(10),
            UTI_INT_TO VARCHAR(10),
            DIAR_ACOM VARCHAR(10),
            QT_DIARIAS VARCHAR(10),
            PROC_SOLIC VARCHAR(50),
            PROC_REA VARCHAR(50),
            VAL_SH VARCHAR(20),
            VAL_SP VARCHAR(20),
            VAL_SADT VARCHAR(20),
            VAL_RN VARCHAR(20),
            VAL_ACOMP VARCHAR(20),
            VAL_ORTP VARCHAR(20),
            VAL_SANGUE VARCHAR(20),
            VAL_SADTSR VARCHAR(20),
            VAL_TRANSP VARCHAR(20),
            VAL_OBSANG VARCHAR(20),
            VAL_PED1AC VARCHAR(20),
            VAL_TOT VARCHAR(20),
            VAL_UTI VARCHAR(20),
            US_TOT VARCHAR(20),
            DT_INTER VARCHAR(20),
            DT_SAIDA VARCHAR(20),
            DIAG_PRINC VARCHAR(50),
            DIAG_SECUN VARCHAR(50),
            COBRANCA VARCHAR(50),
            NATUREZA VARCHAR(50),
            NAT_JUR VARCHAR(50),
            GESTAO VARCHAR(50),
            RUBRICA VARCHAR(50),
            IND_VDRL VARCHAR(10),
            MUNIC_MOV VARCHAR(100),
            COD_IDADE VARCHAR(10),
            IDADE VARCHAR(10),
            DIAS_PERM VARCHAR(10),
            MORTE VARCHAR(10),
            NACIONAL VARCHAR(50),
            NUM_PROC VARCHAR(50),
            CAR_INT VARCHAR(10),
            TOT_PT_SP VARCHAR(20),
            CPF_AUT VARCHAR(50),
            HOMONIMO VARCHAR(10),
            NUM_FILHOS VARCHAR(10),
            INSTRU VARCHAR(50),
            CID_NOTIF VARCHAR(50),
            CONTRACEP1 VARCHAR(50),
            CONTRACEP2 VARCHAR(50),
            GESTRISCO VARCHAR(10),
            INSC_PN VARCHAR(50),
            SEQ_AIH5 VARCHAR(50),
            CBOR VARCHAR(50),
            CNAER VARCHAR(50),
            VINCPREV VARCHAR(50),
            GESTOR_COD VARCHAR(50),
            GESTOR_TP VARCHAR(50),
            GESTOR_CPF VARCHAR(50),
            GESTOR_DT VARCHAR(20),
            CNES VARCHAR(50),
            CNPJ_MANT VARCHAR(50),
            INFEHOSP VARCHAR(10),
            CID_ASSO VARCHAR(50),
            CID_MORTE VARCHAR(50),
            COMPLEX VARCHAR(50),
            FINANC VARCHAR(50),
            FAEC_TP VARCHAR(50),
            REGCT VARCHAR(50),
            RACA_COR VARCHAR(50),
            ETNIA VARCHAR(50),
            SEQUENCIA VARCHAR(50),
            REMESSA VARCHAR(50),
            AUD_JUST VARCHAR(100),
            SIS_JUST VARCHAR(100),
            VAL_SH_FED VARCHAR(20),
            VAL_SP_FED VARCHAR(20),
            VAL_SH_GES VARCHAR(20),
            VAL_SP_GES VARCHAR(20),
            VAL_UCI VARCHAR(20),
            MARCA_UCI VARCHAR(10),
            DIAGSEC1 VARCHAR(50),
            DIAGSEC2 VARCHAR(50),
            DIAGSEC3 VARCHAR(50),
            DIAGSEC4 VARCHAR(50),
            DIAGSEC5 VARCHAR(50),
            DIAGSEC6 VARCHAR(50),
            DIAGSEC7 VARCHAR(50),
            DIAGSEC8 VARCHAR(50),
            DIAGSEC9 VARCHAR(50),
            TPDISEC1 VARCHAR(50),
            TPDISEC2 VARCHAR(50),
            TPDISEC3 VARCHAR(50),
            TPDISEC4 VARCHAR(50),
            TPDISEC5 VARCHAR(50),
            TPDISEC6 VARCHAR(50),
            TPDISEC7 VARCHAR(50),
            TPDISEC8 VARCHAR(50),
            TPDISEC9 VARCHAR(50)
        );

        PRINT 'Tabela criada!';

        -- Array com todos os arquivos
        DECLARE @Arquivos TABLE (
            ID INT IDENTITY(1,1),
            NomeArquivo VARCHAR(50)
        );

        INSERT INTO @Arquivos (NomeArquivo) VALUES
        ('RD202401.csv'),
        ('RD202402.csv'),
        ('RD202403.csv'),
        ('RD202404.csv'),
        ('RD202405.csv'),
        ('RD202406.csv'),
        ('RD202407.csv'),
        ('RD202408.csv'),
        ('RD202409.csv'),
        ('RD202410.csv'),
        ('RD202411.csv'),
        ('RD202412.csv');

        -- Variáveis para loop
        DECLARE @TotalArquivos INT, @Contador INT = 1;
        DECLARE @NomeArquivo VARCHAR(50), @CaminhoCompleto VARCHAR(500);
        DECLARE @SQL NVARCHAR(MAX);

        SELECT @TotalArquivos = COUNT(*) FROM @Arquivos;

        -- Loop através de todos os arquivos
        WHILE @Contador <= @TotalArquivos
        BEGIN
            SELECT @NomeArquivo = NomeArquivo 
            FROM @Arquivos 
            WHERE ID = @Contador;

            SET @CaminhoCompleto = 'C:\Users\Lyvia\OneDrive\Desktop\tem\' + @NomeArquivo;

            PRINT '📁 Importando: ' + @NomeArquivo;

            BEGIN TRY
                SET @SQL = '
                BULK INSERT Staging_AIH_Hospitalar
                FROM ''' + @CaminhoCompleto + '''
                WITH (
                    FIRSTROW = 2,
                    FIELDTERMINATOR = '';'',
                    ROWTERMINATOR = ''0x0a'',
                    MAXERRORS = 10000
                );'

                EXEC sp_executesql @SQL;

                PRINT '   ✅ Sucesso: ' + @NomeArquivo;

            END TRY
            BEGIN CATCH
                PRINT '   ❌ Erro no arquivo ' + @NomeArquivo + ': ' + ERROR_MESSAGE();
                -- Continua para o próximo arquivo mesmo se um falhar
            END CATCH

            SET @Contador = @Contador + 1;
        END

        -- Verifica resultado final
        DECLARE @TotalRegistros INT;
        SELECT @TotalRegistros = COUNT(*) FROM Staging_AIH_Hospitalar;

        PRINT '=========================================';
        PRINT '🎉 CARREGAMENTO CONCLUÍDO!';
        PRINT '📊 Total de registros carregados: ' + CAST(@TotalRegistros AS VARCHAR(20));
        PRINT '=========================================';

    END TRY
    BEGIN CATCH
        PRINT '❌ ERRO NA PROCEDURE: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;

-- Executar a stored procedure
EXEC sp_Carregar_AIH_Hospitalar;
  
------------------------------------------------------------------------------------
--==========================================
-- TRANSFORMAÇÃO
--========================================


-------------------------------------------------
    -- 1. Normalizações textuais: TRIM, REMOVER ASPAS, UPPER, NULLIF
-------------------------------------------------
    UPDATE dbo.Staging_AIH_Hospitalar
    SET
        CNPJ_MANT    = NULLIF(LTRIM(RTRIM(REPLACE(CNPJ_MANT, '"', ''))), ''),
        N_AIH        = NULLIF(LTRIM(RTRIM(REPLACE(N_AIH, '"', ''))), ''),
        DIAGSEC1     = NULLIF(UPPER(LTRIM(RTRIM(REPLACE(DIAGSEC1, '"', '')))), ''),
        DIAG_PRINC   = NULLIF(UPPER(LTRIM(RTRIM(REPLACE(DIAG_PRINC, '"', '')))), ''),
        SEXO         = NULLIF(LTRIM(RTRIM(REPLACE(SEXO, '"', ''))), ''),
        UF_ZI        = NULLIF(UPPER(LTRIM(RTRIM(REPLACE(UF_ZI, '"', '')))), ''),
        MUNIC_RES    = NULLIF(UPPER(LTRIM(RTRIM(REPLACE(MUNIC_RES, '"', '')))), ''),
        CNES         = NULLIF(LTRIM(RTRIM(REPLACE(CNES, '"', ''))), '')
    -- WHERE ... (poderíamos limitar com WHERE para atualizar só linhas necessárias)
    ;

-------------------------------------------------
    -- 2. Normalização do SEXO (mapa completo e seguro)
-------------------------------------------------
    UPDATE dbo.Staging_AIH_Hospitalar
    SET SEXO =
        CASE
            WHEN UPPER(SEXO) IN ('1','M','MA','MASC','MASCULINO','MAS') THEN 'M'
            WHEN UPPER(SEXO) IN ('2','3','F','FEM','FEMININO','FEM') THEN 'F'
            WHEN UPPER(SEXO) IN ('0','9','N','U','I','UNKNOWN','NA','-') THEN NULL
            ELSE NULL
        END
    WHERE SEXO IS NOT NULL;

    -------------------------------------------------
    -- 3. Conversões numéricas ( remover aspas -> remover pontos milhares -> trocar vírgula por ponto)

    -------------------------------------------------
    UPDATE dbo.Staging_AIH_Hospitalar
    SET
        VAL_TOT = TRY_CAST(
                    REPLACE(
                      REPLACE(
                        REPLACE(NULLIF(LTRIM(RTRIM(VAL_TOT)), ''), '"', ''),  -- remove aspas
                      '.', ''),  -- remove separador de milhar
                    ',', '.') AS DECIMAL(15,2)),
        VAL_UTI = TRY_CAST(
                    REPLACE(
                      REPLACE(
                        REPLACE(NULLIF(LTRIM(RTRIM(VAL_UTI)), ''), '"', ''),
                      '.', ''),
                    ',', '.') AS DECIMAL(15,2)),
        -- inteiros
        QT_DIARIAS = TRY_CAST(NULLIF(LTRIM(RTRIM(QT_DIARIAS)), '') AS INT),
        IDADE      = TRY_CAST(NULLIF(LTRIM(RTRIM(IDADE)), '') AS INT),
        DIAS_PERM  = TRY_CAST(NULLIF(LTRIM(RTRIM(DIAS_PERM)), '') AS INT)
    ;

    -------------------------------------------------
    -- 4. Registrar valores que não converteram corretamente (ex.: VAL_TOT com formato errado)
    -------------------------------------------------
    INSERT INTO dbo.AIH_ConversionErrors (ColName, OrigValue, RowIdentifier)
    SELECT 'VAL_TOT', VAL_TOT AS OrigValue, COALESCE(N_AIH, CNES, '') AS RowIdentifier
    FROM dbo.Staging_AIH_Hospitalar
    WHERE VAL_TOT IS NOT NULL
      AND VAL_TOT <> ''
      AND TRY_CAST(REPLACE(REPLACE(REPLACE(VAL_TOT, '"', ''), '.', ''), ',', '.') AS DECIMAL(15,2)) IS NULL
    ;

    INSERT INTO dbo.AIH_ConversionErrors (ColName, OrigValue, RowIdentifier)
    SELECT 'VAL_UTI', VAL_UTI AS OrigValue, COALESCE(N_AIH, CNES, '') AS RowIdentifier
    FROM dbo.Staging_AIH_Hospitalar
    WHERE VAL_UTI IS NOT NULL
      AND VAL_UTI <> ''
      AND TRY_CAST(REPLACE(REPLACE(REPLACE(VAL_UTI, '"', ''), '.', ''), ',', '.') AS DECIMAL(15,2)) IS NULL
    ;

    -------------------------------------------------
    -- 5. Conversão de datas (exemplo para Data_Nasc_raw, Data_Entrada_raw, Data_Saida_raw no formato YYYYMMDD)
    --    Ajuste nomes das colunas conforme sua tabela real.
    -------------------------------------------------
	ALTER TABLE dbo.Staging_AIH_Hospitalar
	ADD Data_Entrada DATE, Data_Saida DATE, Data_Nasc DATE;

    UPDATE dbo.Staging_AIH_Hospitalar
    SET
        [NASC] = TRY_CONVERT(date, NULLIF(LTRIM(RTRIM([NASC])), ''), 112),
        [DT_INTER]= TRY_CONVERT(date, NULLIF(LTRIM(RTRIM([DT_INTER])), ''), 112),
        [DT_SAIDA] = TRY_CONVERT(date, NULLIF(LTRIM(RTRIM([DT_SAIDA])), ''), 112)
    ;

 
    -------------------------------------------------
    -- 6. Remover registros inválidos (CNES / UF_ZI / ANO_CMPT vazios)
    -------------------------------------------------
    DELETE FROM dbo.Staging_AIH_Hospitalar
    WHERE CNES IS NULL OR CNES = ''
       OR UF_ZI IS NULL OR UF_ZI = ''
       OR ANO_CMPT IS NULL OR ANO_CMPT = ''
    ;

	
--==========================================
-- LOAD - CARREGAR PARA TABELAS DESTINO
--========================================

-- 1. POPULAR TABELAS DIMENSIONAIS PRIMEIRO

-- Região (precisa ser populada manualmente ou com dados externos)
INSERT INTO Regiao (Nome)
VALUES 
    ('Norte'), ('Nordeste'), ('Centro-Oeste'), ('Sudeste'), ('Sul');

-- Nível de Escolaridade
INSERT INTO Nivel_de_Escolaridade (Descricao_Escolaridade)
SELECT DISTINCT 
    CASE 
        WHEN INSTRU = '01' THEN 'Analfabeto'
        WHEN INSTRU = '02' THEN '1º Grau Incompleto'
        WHEN INSTRU = '03' THEN '1º Grau Completo'
        WHEN INSTRU = '04' THEN '2º Grau Incompleto'
        WHEN INSTRU = '05' THEN '2º Grau Completo'
        WHEN INSTRU = '06' THEN '3º Grau Incompleto'
        WHEN INSTRU = '07' THEN '3º Grau Completo'
        ELSE 'Não Informado'
    END
FROM Staging_AIH_Hospitalar
WHERE INSTRU IS NOT NULL;

-- Tipo Unidade
INSERT INTO Tipo_Unidade (Ds_Tipo_Unidade)
SELECT DISTINCT COMPLEX
FROM Staging_AIH_Hospitalar
WHERE COMPLEX IS NOT NULL;

-- Tipo Atendimento -- 
INSERT INTO Tipo_Atendimento (Descricao)
SELECT DISTINCT CAR_INT
FROM [dbo].[Staging_AIH_Hospitalar]
WHERE CAR_INT IS NOT NULL;

-- Tipo Leito
INSERT INTO Tipo_Leito (Descricao, Categoria)
VALUES 
    ('UTI Adulto', 'UTI'),
    ('UTI Pediátrico', 'UTI'),
    ('UTI Neonatal', 'UTI'),
    ('UTI Queimados', 'UTI'),
    ('UTI Coronariana', 'UTI'),
    ('Enfermaria', 'Comum'),
    ('Apartamento', 'Comum');

-- CID10
INSERT INTO CID10 (Descricao, Notificacao_Compulsoria, Capitulo)
SELECT DISTINCT 
    DIAG_PRINC,
    CASE WHEN CID_NOTIF IS NOT NULL THEN 1 ELSE 0 END,
    LEFT(DIAG_PRINC, 3)
FROM Staging_AIH_Hospitalar
WHERE DIAG_PRINC IS NOT NULL;

-- Especialidade Médica
INSERT INTO Especialidade_Medica (Nome, Descricao)
SELECT DISTINCT ESPEC, ESPEC
FROM Staging_AIH_Hospitalar
WHERE ESPEC IS NOT NULL;

-- Classificação Risco
INSERT INTO Classificacao_Risco (Descricao)
VALUES 
    ('Eletivo'), ('Urgência'), ('Emergência');

-- Tipo Recurso
INSERT INTO Tipo_Recurso (Id_Tipo_Recurso, Descricao)
VALUES 
    (1, 'Equipamento Médico'),
    (2, 'Medicamento'),
    (3, 'Material Hospitalar'),
    (4, 'Equipamento de TI');

-- Tipo Demanda
INSERT INTO Tipo_Demanda (Descricao)
VALUES 
    ('Consulta'), ('Exame'), ('Cirurgia'), ('Internação');

-- Faixa Etária
INSERT INTO Faixa_Etaria (Descricao, Min_Idade, Max_Idade)
VALUES 
    ('0-1 ano', 0, 1),
    ('2-5 anos', 2, 5),
    ('6-12 anos', 6, 12),
    ('13-17 anos', 13, 17),
    ('18-39 anos', 18, 39),
    ('40-59 anos', 40, 59),
    ('60+ anos', 60, 999);

-- Raça/Cor
INSERT INTO RACA_COR (Descricao)
SELECT DISTINCT 
    CASE RACA_COR
        WHEN '01' THEN 'Branca'
        WHEN '02' THEN 'Preta'
        WHEN '03' THEN 'Parda'
        WHEN '04' THEN 'Amarela'
        WHEN '05' THEN 'Indígena'
        ELSE 'Não Informado'
    END
FROM Staging_AIH_Hospitalar
WHERE RACA_COR IS NOT NULL;

-- Natureza Jurídica
INSERT INTO Natureza_Juridica (Tipo, Descricao, Justificativas_AUD, Justificativas_SIS)
SELECT DISTINCT 
    NAT_JUR,
    CASE 
        WHEN NAT_JUR = '01' THEN 'Administração Pública'
        WHEN NAT_JUR = '02' THEN 'Entidade Empresarial'
        WHEN NAT_JUR = '03' THEN 'Entidade Sem Fins Lucrativos'
        ELSE 'Outros'
    END,
    AUD_JUST,
    SIS_JUST
FROM Staging_AIH_Hospitalar
WHERE NAT_JUR IS NOT NULL;

-- 2. POPULAR UF E MUNICÍPIOS
INSERT INTO UF (Id_Regiao, Sigla, Nome)
SELECT DISTINCT 
    CASE 
        WHEN UF_ZI IN ('AC', 'AP', 'AM', 'PA', 'RO', 'RR', 'TO') THEN 1
        WHEN UF_ZI IN ('AL', 'BA', 'CE', 'MA', 'PB', 'PE', 'PI', 'RN', 'SE') THEN 2
        WHEN UF_ZI IN ('DF', 'GO', 'MT', 'MS') THEN 3
        WHEN UF_ZI IN ('ES', 'MG', 'RJ', 'SP') THEN 4
        WHEN UF_ZI IN ('PR', 'RS', 'SC') THEN 5
        ELSE 1
    END,
    UF_ZI,
    CASE 
        WHEN UF_ZI = 'AC' THEN 'Acre'
        WHEN UF_ZI = 'AL' THEN 'Alagoas'
        -- ... completar para todos os estados
        ELSE 'Estado Desconhecido'
    END
FROM Staging_AIH_Hospitalar
WHERE UF_ZI IS NOT NULL;

-- Municipio
INSERT INTO Municipio (Id_Uf, Nome)
SELECT DISTINCT 
    u.Id_Uf,
    s.MUNIC_MOV
FROM Staging_AIH_Hospitalar s
INNER JOIN UF u ON s.UF_ZI = u.Sigla
WHERE s.MUNIC_MOV IS NOT NULL;

-- 3. POPULAR ENDEREÇO E HOSPITAL
INSERT INTO Endereco_Hospital (No_Logradouro, Nu_Endereco, No_Complemento, No_Bairro, Co_Cep, Nu_Telefone, No_Email)
SELECT DISTINCT
    'Endereço não informado' as No_Logradouro,
    'S/N' as Nu_Endereco,
    'Complemento não informado' as No_Complemento,
    'Bairro não informado' as No_Bairro,
    CEP as Co_Cep,
    NULL as Nu_Telefone,
    'email@hospital.com' as No_Email
FROM Staging_AIH_Hospitalar
WHERE CEP IS NOT NULL;

-- Hospital
INSERT INTO Hospital (CNES, Id_Municipio, Id_Natureza_Juridica, Id_Uf, Id_Endereco, Nome_Hospital, Tipo_Gestao, Razao_Social)
SELECT DISTINCT
    s.CNES,
    m.Id_Municipio,
    nj.Id_Natureza_Juridica,
    u.Id_Uf,
    e.Id_Endereco,
    'Hospital ' + s.CNES as Nome_Hospital,
    s.GESTAO as Tipo_Gestao,
    'Razão Social ' + s.CNES as Razao_Social
FROM Staging_AIH_Hospitalar s
INNER JOIN Municipio m ON s.MUNIC_MOV = m.Nome
INNER JOIN UF u ON s.UF_ZI = u.Sigla
INNER JOIN Natureza_Juridica nj ON s.NAT_JUR = CAST(nj.Tipo AS VARCHAR)
INNER JOIN Endereco_Hospital e ON s.CEP = e.Co_Cep
WHERE s.CNES IS NOT NULL;

-- 4. POPULAR PACIENTES
INSERT INTO Paciente (Id_Municipio, Id_Raca, Id_Escolaridade, Nomes_Semelhantes, Idade, Etnia, Nacionalidade, Data_Nascimento, Sexo, Num_Filhos)
SELECT DISTINCT
    m.Id_Municipio,
    r.Id_raca,
    e.Id_Escolaridade,
    CASE WHEN s.HOMONIMO = '1' THEN 1 ELSE 0 END,
    CAST(s.IDADE AS INT),
    s.ETNIA,
    s.NACIONAL,
    CASE 
        WHEN ISDATE(s.NASC) = 1 THEN CAST(s.NASC AS DATE)
        ELSE NULL
    END,
    s.SEXO,
    CAST(COALESCE(s.NUM_FILHOS, '0') AS INT)
FROM Staging_AIH_Hospitalar s
INNER JOIN Municipio m ON s.MUNIC_RES = m.Nome
INNER JOIN RACA_COR r ON 
    CASE s.RACA_COR
        WHEN '01' THEN 'Branca'
        WHEN '02' THEN 'Preta'
        WHEN '03' THEN 'Parda'
        WHEN '04' THEN 'Amarela'
        WHEN '05' THEN 'Indígena'
        ELSE 'Não Informado'
    END = r.Descricao
INNER JOIN Nivel_de_Escolaridade e ON 
    CASE 
        WHEN s.INSTRU = '01' THEN 'Analfabeto'
        WHEN s.INSTRU = '02' THEN '1º Grau Incompleto'
        WHEN s.INSTRU = '03' THEN '1º Grau Completo'
        WHEN s.INSTRU = '04' THEN '2º Grau Incompleto'
        WHEN s.INSTRU = '05' THEN '2º Grau Completo'
        WHEN s.INSTRU = '06' THEN '3º Grau Incompleto'
        WHEN s.INSTRU = '07' THEN '3º Grau Completo'
        ELSE 'Não Informado'
    END = e.Descricao_Escolaridade;

-- 5. POPULAR INTERNAÇÕES
INSERT INTO Internacao (
    Id_Paciente, Id_Hospital, Sequencia_Internacao, Data_Internacao, 
    Data_Saida, Morte, Identificacao_internacao, Especialidade_Leito, 
    Cobranca, Gestao_De_Risco, Procedimento_Solicitado, Diaria_Acompanhante, 
    Ano_Internacao, Mes_Internacao
)
SELECT
    p.Id_Paciente,
    h.Id_Hospital,
    CAST(s.SEQUENCIA AS INT),
    CASE WHEN ISDATE(s.DT_INTER) = 1 THEN CAST(s.DT_INTER AS DATE) ELSE NULL END,
    CASE WHEN ISDATE(s.DT_SAIDA) = 1 THEN CAST(s.DT_SAIDA AS DATE) ELSE NULL END,
    CASE WHEN s.MORTE = '1' THEN 1 ELSE 0 END,
    CAST(s.IDENT AS INT),
    s.ESPEC,
    s.COBRANCA,
    CASE WHEN s.GESTRISCO = '1' THEN 1 ELSE 0 END,
    CAST(s.PROC_SOLIC AS INT),
    CAST(s.DIAR_ACOM AS INT),
    CAST(s.ANO_CMPT AS INT),
    CAST(s.MES_CMPT AS INT)
FROM Staging_AIH_Hospitalar s
INNER JOIN Paciente p ON 
    p.Idade = CAST(s.IDADE AS INT) 
    AND p.Sexo = s.SEXO
INNER JOIN Hospital h ON s.CNES = h.CNES;

-- 6. POPULAR PROCEDIMENTOS MÉDICOS
INSERT INTO Procedimento_Medico (Descricao, Val_Sh, Val_Sp, Val_Sadt, Val_Tot)
SELECT DISTINCT
    'Procedimento ' + s.PROC_REA,
    CAST(s.VAL_SH AS DECIMAL(15,2)),
    CAST(s.VAL_SP AS DECIMAL(15,2)),
    CAST(s.VAL_SADT AS DECIMAL(15,2)),
    CAST(s.VAL_TOT AS DECIMAL(15,2))
FROM Staging_AIH_Hospitalar s
WHERE s.PROC_REA IS NOT NULL;

-- 7. POPULAR PROCEDIMENTOS INTERNAÇÃO
INSERT INTO Procedimento_Internacao (
    Id_Internacao, Id_Procedimento_Medico, Val_Sh_Fed, Val_Sp_Fed, 
    Val_Sp_Ges, Val_Uci, Val_Sh_Ges, Procedimento_Realizado
)
SELECT
    i.Id_Internacao,
    pm.Id_Procedimento_Medico,
    CAST(s.VAL_SH_FED AS DECIMAL(15,2)),
    CAST(s.VAL_SP_FED AS DECIMAL(15,2)),
    CAST(s.VAL_SP_GES AS DECIMAL(15,2)),
    CAST(s.VAL_UCI AS DECIMAL(15,2)),
    CAST(s.VAL_SH_GES AS DECIMAL(15,2)),
    CAST(s.PROC_REA AS INT)
FROM Staging_AIH_Hospitalar s
INNER JOIN Internacao i ON s.IDENT = CAST(i.Identificacao_internacao AS VARCHAR)
INNER JOIN Procedimento_Medico pm ON s.PROC_REA = CAST(pm.Id_Procedimento_Medico AS VARCHAR);

-- 8. POPULAR DETALHES INTERNAÇÃO
INSERT INTO Detalhe_Internacao (
    Id_Internacao, Tipo_Diag_Secun, Diag_Adicionais, 
    Permanencia_Hospital, Cobranca, Complexidade
)
SELECT
    i.Id_Internacao,
    CAST(s.TPDISEC1 AS INT),
    CAST(s.DIAGSEC1 AS INT),
    CAST(s.DIAS_PERM AS INT),
    s.COBRANCA,
    s.COMPLEX
FROM Staging_AIH_Hospitalar s
INNER JOIN Internacao i ON s.IDENT = CAST(i.Identificacao_internacao AS VARCHAR);

-- 9. POPULAR UTI
INSERT INTO UTI (
    Id_Internacao, Tipo_UTI, Qtd_Internacoes_Uti_Mes, 
    Qtd_Internacoes_Uti_Total, Qtd_Internacoes_Periodo,
    Qtd_Internacoes_Ate_Alta, Qtd_Internacoes_Ano, Total_Internacao
)
SELECT
    i.Id_Internacao,
    CASE 
        WHEN s.MARCA_UTI = '1' THEN 1
        WHEN s.MARCA_UCI = '1' THEN 2
        ELSE 0
    END,
    CAST(s.UTI_MES_IN AS INT),
    CAST(s.UTI_MES_TO AS INT),
    CAST(s.UTI_INT_IN AS INT),
    CAST(s.UTI_INT_AL AS INT),
    CAST(s.UTI_INT_AN AS INT),
    CAST(s.UTI_INT_TO AS INT)
FROM Staging_AIH_Hospitalar s
INNER JOIN Internacao i ON s.IDENT = CAST(i.Identificacao_internacao AS VARCHAR)
WHERE s.MARCA_UTI = '1' OR s.MARCA_UCI = '1';

-- 10. POPULAR SAÚDE REPRODUTIVA
INSERT INTO Saude_Reprodutiva (
    Id_Internacao, Exame_Vdrl, Contraceptivo_1, 
    Contraceptivo_2, Num_Filhos
)
SELECT
    i.Id_Internacao,
    CASE WHEN s.IND_VDRL = '1' THEN 1 ELSE 0 END,
    s.CONTRACEP1,
    s.CONTRACEP2,
    CAST(s.NUM_FILHOS AS INT)
FROM Staging_AIH_Hospitalar s
INNER JOIN Internacao i ON s.IDENT = CAST(i.Identificacao_internacao AS VARCHAR)
WHERE s.SEXO = 'F';

-- 11. POPULAR CONDIÇÕES DE SAÚDE
INSERT INTO Condicoes_Saude (
    Id_Saude_Reprodutiva, Exame_Vdrl, Gestacao_Risco, Infeccao_Hospitalar
)
SELECT
    sr.Id_Saude_Reprodutiva,
    sr.Exame_Vdrl,
    CASE WHEN s.GESTRISCO = '1' THEN 1 ELSE 0 END,
    CASE WHEN s.INFEHOSP = '1' THEN 1 ELSE 0 END
FROM Staging_AIH_Hospitalar s
INNER JOIN Internacao i ON s.IDENT = CAST(i.Identificacao_internacao AS VARCHAR)
INNER JOIN Saude_Reprodutiva sr ON i.Id_Internacao = sr.Id_Internacao;

-- 12. POPULAR FINANCEIRO
INSERT INTO Financeiro (
    Id_Internacao, Tipo_de_financiamento, Fonte_Financiamento,
    Total_Procedimento, Valor_Hospitalar, Valor_Sadt, 
    Valor_Profissional, Valor_Rn, Valor_Protese, 
    Valor_Acompanhante, Valor_Sangue, Valor_Sadtsr,
    Valor_Analgesico_obstetra, Valor_Pediatria1, 
    Valor_UTI, Valor_Transplante, Numero_Procedimentos
)
SELECT
    i.Id_Internacao,
    CAST(s.FINANC AS INT),
    CAST(s.FAEC_TP AS INT),
    CAST(s.VAL_TOT AS DECIMAL(15,2)),
    CAST(s.VAL_SH AS DECIMAL(15,2)),
    CAST(s.VAL_SADT AS DECIMAL(15,2)),
    CAST(s.VAL_SP AS DECIMAL(15,2)),
    CAST(s.VAL_RN AS DECIMAL(15,2)),
    CAST(s.VAL_ORTP AS DECIMAL(15,2)),
    CAST(s.VAL_ACOMP AS DECIMAL(15,2)),
    CAST(s.VAL_SANGUE AS DECIMAL(15,2)),
    CAST(s.VAL_SADTSR AS DECIMAL(15,2)),
    CAST(s.VAL_OBSANG AS DECIMAL(15,2)),
    CAST(s.VAL_PED1AC AS DECIMAL(15,2)),
    CAST(s.VAL_UTI AS DECIMAL(15,2)),
    CAST(s.VAL_TRANSP AS DECIMAL(15,2)),
    CAST(s.NUM_PROC AS INT)
FROM Staging_AIH_Hospitalar s
INNER JOIN Internacao i ON s.IDENT = CAST(i.Identificacao_internacao AS VARCHAR);

-- 13. POPULAR GESTOR
INSERT INTO Gestor (
    Id_Financeiro, Tipo_Gestor, CPF_Gestor, 
    Data_Gestao, Remessa_Arquivos
)
SELECT
    f.Id_Financeiro,
    CAST(s.GESTOR_TP AS INT),
    s.GESTOR_CPF,
    CASE WHEN ISDATE(s.GESTOR_DT) = 1 THEN CAST(s.GESTOR_DT AS DATE) ELSE NULL END,
    s.REMESSA
FROM Staging_AIH_Hospitalar s
INNER JOIN Internacao i ON s.IDENT = CAST(i.Identificacao_internacao AS VARCHAR)
INNER JOIN Financeiro f ON i.Id_Internacao = f.Id_Internacao
WHERE s.GESTOR_TP IS NOT NULL;

-- 14. POPULAR LEITOS UTI
INSERT INTO Leito_UTI_Detalhe (
    Id_Hospital, UTI_TOTAL_EXIST, UTI_TOTAL_SUS,
    UTI_ADULTO_EXIST, UTI_ADULTO_SUS,
    UTI_PEDIATRICO_EXIST, UTI_PEDIATRICO_SUS,
    UTI_NEONATAL_EXIST, UTI_NEONATAL_SUS,
    UTI_QUEIMADO_EXIST, UTI_QUEIMADO_SUS,
    UTI_CORONARIANA_EXIST, UTI_CORONARIANA_SUS
)
SELECT DISTINCT
    h.Id_Hospital,
    '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
FROM Hospital h;

-- ATUALIZAR LEITOS UTI BASEADO NOS DADOS EXISTENTES
UPDATE l SET
    UTI_TOTAL_EXIST = CAST(COUNT(i.Id_Internacao) AS VARCHAR)
FROM Leito_UTI_Detalhe l
INNER JOIN Hospital h ON l.Id_Hospital = h.Id_Hospital
INNER JOIN Internacao i ON h.Id_Hospital = i.Id_Hospital
INNER JOIN UTI u ON i.Id_Internacao = u.Id_Internacao;

-- 15. POPULAR ATENDIMENTOS
INSERT INTO Atendimento (
    Id_Paciente, Id_Hospital, Id_Class_Risco, 
    Id_Tipo_Atendimento, Data_Hora, 
    Inscricao_Paciente, Total_Usuarios_Atendidos
)
SELECT
    p.Id_Paciente,
    h.Id_Hospital,
    2, -- Default para Urgência
    1, -- Default para Primeiro Atendimento
    i.Data_Internacao,
    s.INSC_PN,
    1
FROM Staging_AIH_Hospitalar s
INNER JOIN Paciente p ON 
    p.Idade = CAST(s.IDADE AS INT) 
    AND p.Sexo = s.SEXO
INNER JOIN Hospital h ON s.CNES = h.CNES
INNER JOIN Internacao i ON s.IDENT = CAST(i.Identificacao_internacao AS VARCHAR);

-- MENSAGEM DE CONCLUSÃO
PRINT 'ETL concluído com sucesso!';
PRINT 'Total de registros processados: ' + CAST(@@ROWCOUNT AS VARCHAR);


