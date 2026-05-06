-- ===================================================================
-- PRONTUÁRIO ELETRÔNICO SUS - Schema do Banco de Dados
-- Versão: 1.0
-- Data: 2026-05-06
-- ===================================================================

-- ===================================================================
-- 1. TABELA DE PACIENTES
-- ===================================================================
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    numero_sus VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    dt_nascimento DATE NOT NULL,
    genero CHAR(1),
    endereco VARCHAR(255),
    numero_endereco VARCHAR(10),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(8),
    telefone VARCHAR(11),
    email VARCHAR(100),
    dt_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_pacientes_cpf ON pacientes(cpf);
CREATE INDEX idx_pacientes_numero_sus ON pacientes(numero_sus);
CREATE INDEX idx_pacientes_nome ON pacientes(nome);

-- ===================================================================
-- 2. TABELA CID-10 (Classificação Internacional de Doenças)
-- ===================================================================
CREATE TABLE tb_cid (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(5) UNIQUE NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    descricao_completa TEXT,
    capitulo VARCHAR(100),
    categoria VARCHAR(5),
    dt_importacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_cid_codigo ON tb_cid(codigo);
CREATE INDEX idx_cid_descricao ON tb_cid(descricao);

-- ===================================================================
-- 3. TABELA SIGTAP (Tabela de Procedimentos do SUS)
-- ===================================================================
CREATE TABLE tb_procedimento_sus (
    id SERIAL PRIMARY KEY,
    codigo_procedimento VARCHAR(10) UNIQUE NOT NULL,
    nome_procedimento VARCHAR(255) NOT NULL,
    descricao TEXT,
    tipo_complexidade VARCHAR(2),
    vl_sa DECIMAL(10, 2),
    vl_sp DECIMAL(10, 2),
    vl_sh DECIMAL(10, 2),
    habilitacao VARCHAR(50),
    dt_importacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_procedimento_codigo ON tb_procedimento_sus(codigo_procedimento);
CREATE INDEX idx_procedimento_nome ON tb_procedimento_sus(nome_procedimento);

-- ===================================================================
-- 4. TABELA DE PRONTUÁRIOS (Registros de Atendimentos)
-- ===================================================================
CREATE TABLE prontuarios (
    id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL,
    dt_atendimento TIMESTAMP NOT NULL,
    queixa_principal TEXT,
    cid10_codigo VARCHAR(5),
    procedimento_sus_codigo VARCHAR(10),
    anamnese TEXT,
    exame_fisico TEXT,
    diagnostico TEXT,
    plano_tratamento TEXT,
    medicacoes TEXT,
    observacoes TEXT,
    medico_responsavel VARCHAR(255),
    especialidade VARCHAR(100),
    unidade_saude VARCHAR(255),
    dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE RESTRICT,
    FOREIGN KEY (cid10_codigo) REFERENCES tb_cid(codigo),
    FOREIGN KEY (procedimento_sus_codigo) REFERENCES tb_procedimento_sus(codigo_procedimento)
);

CREATE INDEX idx_prontuarios_paciente ON prontuarios(paciente_id);
CREATE INDEX idx_prontuarios_data ON prontuarios(dt_atendimento);
CREATE INDEX idx_prontuarios_cid ON prontuarios(cid10_codigo);
CREATE INDEX idx_prontuarios_procedimento ON prontuarios(procedimento_sus_codigo);

-- ===================================================================
-- 5. TABELA DE HISTÓRICO DE ALTERAÇÕES (Auditoria)
-- ===================================================================
CREATE TABLE historico_alteracoes (
    id SERIAL PRIMARY KEY,
    tabela_alterada VARCHAR(50) NOT NULL,
    id_registro INT NOT NULL,
    tipo_operacao VARCHAR(10) NOT NULL,
    dados_anteriores JSONB,
    dados_novos JSONB,
    usuario_alteracao VARCHAR(100),
    dt_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_historico_tabela ON historico_alteracoes(tabela_alterada);
CREATE INDEX idx_historico_data ON historico_alteracoes(dt_alteracao);

-- ===================================================================
-- 6. VIEW - Prontuários com Informações Completas do Paciente
-- ===================================================================
CREATE VIEW vw_prontuarios_completo AS
SELECT
    p.id as prontuario_id,
    pac.id as paciente_id,
    pac.nome as paciente_nome,
    pac.cpf,
    pac.numero_sus,
    pac.dt_nascimento,
    p.dt_atendimento,
    p.queixa_principal,
    c.codigo as cid_codigo,
    c.descricao as cid_descricao,
    s.codigo_procedimento as procedimento_codigo,
    s.nome_procedimento,
    p.diagnostico,
    p.medico_responsavel,
    p.especialidade,
    p.unidade_saude
FROM prontuarios p
JOIN pacientes pac ON p.paciente_id = pac.id
LEFT JOIN tb_cid c ON p.cid10_codigo = c.codigo
LEFT JOIN tb_procedimento_sus s ON p.procedimento_sus_codigo = s.codigo_procedimento
WHERE pac.ativo = TRUE;

-- ===================================================================
-- 7. VIEW - Estatísticas de Procedimentos por CID
-- ===================================================================
CREATE VIEW vw_estatisticas_cid AS
SELECT
    c.codigo,
    c.descricao,
    COUNT(p.id) as total_atendimentos,
    COUNT(DISTINCT p.paciente_id) as total_pacientes,
    MAX(p.dt_atendimento) as ultimo_atendimento
FROM tb_cid c
LEFT JOIN prontuarios p ON c.codigo = p.cid10_codigo
GROUP BY c.codigo, c.descricao
ORDER BY total_atendimentos DESC;

-- ===================================================================
-- 8. VIEW - Últimos Atendimentos por Paciente
-- ===================================================================
CREATE VIEW vw_ultimos_atendimentos AS
SELECT
    pac.id,
    pac.nome,
    pac.numero_sus,
    p.dt_atendimento,
    c.codigo as cid_codigo,
    c.descricao as diagnostico,
    p.medico_responsavel,
    ROW_NUMBER() OVER (PARTITION BY pac.id ORDER BY p.dt_atendimento DESC) as rank
FROM pacientes pac
LEFT JOIN prontuarios p ON pac.id = p.paciente_id
LEFT JOIN tb_cid c ON p.cid10_codigo = c.codigo
WHERE pac.ativo = TRUE;

-- ===================================================================
-- COMENTÁRIOS DAS TABELAS
-- ===================================================================
COMMENT ON TABLE pacientes IS 'Dados demográficos dos pacientes do SUS';
COMMENT ON TABLE tb_cid IS 'Classificação Internacional de Doenças (CID-10)';
COMMENT ON TABLE tb_procedimento_sus IS 'Procedimentos do Sistema Único de Saúde (SIGTAP)';
COMMENT ON TABLE prontuarios IS 'Registros de atendimentos médicos e prontuários eletrônicos';
COMMENT ON TABLE historico_alteracoes IS 'Auditoria de todas as alterações nos dados';

COMMENT ON COLUMN pacientes.numero_sus IS 'Número do Cartão SUS do paciente';
COMMENT ON COLUMN prontuarios.cid10_codigo IS 'Código CID-10 do diagnóstico';
COMMENT ON COLUMN prontuarios.procedimento_sus_codigo IS 'Código SIGTAP do procedimento realizado';
