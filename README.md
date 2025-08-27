# 🗄️ Projeto Final: Engenharia e Análise de Dados com T-SQL | SUS

## ✅ Visão Geral
Este projeto simula um ciclo completo de **engenharia e análise de dados** utilizando exclusivamente **T-SQL no SQL Server**, com foco em **hospitais, leitos e atendimentos do SUS**.  
Objetivo: gerar **insights acionáveis** sobre capacidade hospitalar, distribuição geográfica, utilização de recursos e padrões de atendimento no Brasil.

<details>
<summary>📊 Principais Categorias Analisadas</summary>

- **Hospitais:** quantidade, tipo e localização  
- **Leitos:** disponibilidade por tipo (clínicos, cirúrgicos, UTI etc.)  
- **Atendimentos:** volumes de internações e procedimentos  
- **Distribuição geográfica:** análise por estado, região e município  

</details>

<details>
<summary>🔎 Perguntas de Negócio e Resultados Esperados</summary>

### 1. Capacidade e Distribuição Geográfica
- Distribuição de leitos (total e de UTI) por 1000 habitantes por estado/região  
- 10 municípios com melhor/pior taxa de leitos e correlação com porte populacional  
- Proporção de leitos públicos x privados por UF  
- Proporção de leitos de alta complexidade por estado  

### 2. Eficiência e Utilização
- Hospitais com maiores volumes de procedimentos e custos  
- Taxa de ocupação média por tipo de leito e região  
- Sazonalidade nos procedimentos hospitalares  
- Custo médio por procedimento por hospital e região  

### 3. Acessibilidade e Equidade
- Regiões com maior/menor densidade de hospitais por área/população  
- Distribuição de leitos de UTI e municípios sem UTI  

### 4. Gestão de Recursos Humanos
- Correlação entre profissionais e taxa de mortalidade/tempo de internação  
- Especialidades que realizam mais procedimentos de alta complexidade  
- Taxa de mortalidade vs proporção de profissionais por leito  

</details>

<details>
<summary>📂 Datasets</summary>

**Principal:**  
- Hospitais e Leitos (Leitos 2024) – CSV com relação de hospitais, tipos de leitos, esfera administrativa e localização  

**Apoio:**  
- Estimativas da População (2024) – XLS/ODS com população por município e estado  
- SIH/SUS – Internações Municipais (RD202401) – CSV com dados de internações, procedimentos, valores e tempo de permanência  

*Objetivo:* Extrair métricas per capita, taxas de ocupação, rankings e correlações para responder às perguntas de negócio.  

[Link para Dicionário de Dados]  

</details>

<details>
<summary>🛠 Organização & Ferramentas</summary>

- **Versionamento:** Git/GitHub  
- **Gestão do projeto:** Quadro Kanban [link para planner]  
- **Visualização opcional:** Power BI ou Tableau  

</details>

<details>
<summary>📅 Cronograma de Entregas</summary>

| Fase | Semana | Entrega | Foco |
|------|--------|---------|------|
| 1 – Concepção | 1 | Kick-off e Análise Exploratória | Definir tema, analisar dataset bruto, criar repositório e Kanban |
|  | 2 | Requisitos e Plano de Análise | Modelo Lógico, perguntas de negócio refinadas |
|  | 3 | Modelagem Física | Definir tipos de dados, constraints e estrutura SQL Server |
| 2 – ETL | 4 | Construção do Banco (DDL) | Criar scripts e estrutura do banco |
|  | 5 | Desenvolvimento do ETL em T-SQL | Stored Procedures para ETL, testes com amostra |
|  | 6 | Execução do ETL e Consultas Explor. | Carga completa e consultas exploratórias |
| 3 – Otimização | 7 | Views e Índices | Otimização para análise |
|  | 8 | Stored Procedures Analíticas | Responder perguntas de negócio |
|  | 9 | Triggers e Transações (DTL) | Auditoria e controle de transações |
|  | 10 | Segurança (DCL) | Logins, usuários e perfis |
| 4 – Finalização | 11 | Documentação & Dashboard | Documentação final e dashboard (opcional) |
|  | 12 | Preparação da Entrega Final | Vídeo de demonstração e apresentação |
|  | 13 | Apresentação Final | Defesa do projeto e insights |

</details>

<details>
<summary>👥 Equipe do Projeto</summary>

| Nome | Papel | GitHub |
|------|-------|--------|
| Guilherme Silviano | Analista de dados | @guisilviano |
| Lyvia | Engenheira de dados | @LyviaVilela |
| Nicole | Analista de dados | @niiukiyo |
| Paulo | Arquiteto de dados | @paulok767 |
| Sergio | Arquiteto de dados | @SergioJunior20 |
| Tiago | Engenheiro de dados | @TiagoCosta777 |

**Disciplina:** Gerenciamento de Banco de Dados – UNASP – Período 2024.2  

</details>


