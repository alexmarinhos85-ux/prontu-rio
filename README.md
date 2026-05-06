# Prontuário Eletrônico SUS

Um sistema de prontuário eletrônico para o Sistema Único de Saúde (SUS) desenvolvido para modernizar o atendimento e registro de informações de saúde dos pacientes.

## 📋 Características

- ✅ Registro de pacientes com dados de identificação SUS
- ✅ Integração com SIGTAP (Tabela de Procedimentos SUS)
- ✅ Integração com CID-10 (Classificação Internacional de Doenças)
- ✅ Prontuário eletrônico com histórico de atendimentos
- ✅ Banco de dados relacional otimizado
- ✅ Views para consultas rápidas

## 🏗️ Arquitetura do Projeto

```
prontu-rio/
├── backend/          # API REST (Node.js/Express ou Python/Flask)
├── frontend/         # Interface web (React/Vue)
├── database/         # Scripts SQL e migrations
│   └── schema.sql    # Schema completo do banco
├── README.md         # Este arquivo
└── .gitignore        # Configuração Git
```

## 🗄️ Estrutura do Banco de Dados

### Tabelas Principais

| Tabela | Descrição |
|--------|-----------|
| `pacientes` | Dados demográficos dos pacientes |
| `prontuarios` | Registros de atendimentos médicos |
| `tb_cid` | Classificação Internacional de Doenças (CID-10) |
| `tb_procedimento_sus` | Procedimentos do SUS (SIGTAP) |
| `historico_alteracoes` | Auditoria de mudanças no sistema |

### Relacionamentos

```
pacientes (1) ──→ (∞) prontuarios
    ↓
tb_cid
tb_procedimento_sus
```

## 🚀 Como Começar

### 1. Clonar o Repositório

```bash
git clone https://github.com/alexmarinhos85-ux/prontu-rio.git
cd prontu-rio
```

### 2. Configurar o Banco de Dados

```bash
# PostgreSQL
psql -U postgres -f database/schema.sql

# MySQL
mysql -u root -p < database/schema.sql
```

### 3. Importar Dados SIGTAP e CID-10

Utilize os repositórios oficiais para importação:

- **SIGTAP**: [rdsilva/SIGTAP](https://github.com/rdsilva/SIGTAP)
- **CID-10**: [lucasrafagnin/CID10-SQL](https://github.com/lucasrafagnin/CID10-SQL)

## 📚 Referências e Dados

### CID-10 - Classificação Internacional de Doenças

- **Fonte Oficial**: [DATASUS](http://www2.datasus.gov.br/)
- **Repositório Útil**: [lucasrafagnin/CID10-SQL](https://github.com/lucasrafagnin/CID10-SQL)
- **Formato**: Código (ex: A00, I10) + Descrição

### SIGTAP - Sistema de Gerenciamento da Tabela de Procedimentos

- **Fonte Oficial**: [DATASUS - SIGTAP](http://sigtap.datasus.gov.br/)
- **Repositório Útil**: [rdsilva/SIGTAP](https://github.com/rdsilva/SIGTAP)
- **Dados**: Código do procedimento, descrição, valor SUS, complexidade

### Documentação SUS

- [Portaria GM nº 2.934/2022 - PEC](http://www.saude.gov.br/)
- [Manual de Padrões ABNT para Saúde Digital](https://www.abnt.org.br/)

## 🔧 Tecnologias Recomendadas

### Backend

- **Node.js + Express** ou **Python + Flask/Django**
- **PostgreSQL** ou **MySQL**
- **Docker** para containerização

### Frontend

- **React** ou **Vue.js**
- **Tailwind CSS** ou **Bootstrap**
- **TypeScript** para type safety

## 📝 Licença

Este projeto é de uso público para fins educacionais e de saúde.

## 📧 Contato

**Desenvolvedor**: alexmarinhos85-ux  
**GitHub**: [@alexmarinhos85-ux](https://github.com/alexmarinhos85-ux)

---

**Última atualização**: 2026-05-06
