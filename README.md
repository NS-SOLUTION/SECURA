# SECURA.APP.01 — Plataforma de Inteligência Agrícola

## 1. Requisitos
- Windows 10/11, macOS ou Linux
- Node.js LTS (20 ou superior recomendado)
- MySQL 8+
- Ligação à Internet para NASA POWER, NASA GIBS e instalação das dependências
- Credenciais Meta WhatsApp Cloud API para envio real de mensagens

## 2. Instalação rápida no Windows
1. Extraia o ZIP para uma pasta, por exemplo `C:\SECURA_APP_01`.
2. Instale Node.js LTS e MySQL 8.
3. Crie a base de dados executando `database/secura.sql` no MySQL Workbench ou terminal.
4. Copie `backend/.env.example` para `backend/.env` e preencha as credenciais.
5. Execute `INICIAR_SECURA.bat`. O script instala as dependências e inicia os serviços.
6. Abra `http://localhost:5173`.

> O `index.html` é a entrada da interface React, mas não é uma aplicação autónoma de duplo clique. O React, a API e o MySQL precisam de ser iniciados. O inicializador automatiza a instalação e arranque da aplicação, mas não instala nem configura o MySQL.

## 3. Configuração
Edite `backend/.env`:
- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
- `JWT_SECRET`: use uma chave longa, aleatória e privada.
- `WHATSAPP_TOKEN`, `WHATSAPP_PHONE_NUMBER_ID`, `WHATSAPP_VERIFY_TOKEN`: credenciais emitidas pela Meta.
- `PORT`: porta da API (por defeito 4000).

Nunca publique o ficheiro `.env` nem coloque tokens no frontend.

## 4. Integrações de dados
- NASA POWER: o backend consulta a API pública para temperatura, precipitação, humidade relativa e vento. A disponibilidade e resolução variam por parâmetro/localização.
- NASA GIBS: camada de imagens de satélite no mapa Leaflet. A imagem apresentada depende do produto, data e disponibilidade do serviço.
- WhatsApp: o endpoint exige token, ID do número empresarial e destinatário válido. A Meta pode exigir templates aprovados para mensagens iniciadas pela empresa.
- Google Maps não é obrigatório nesta versão; o mapa usa Leaflet e OpenStreetMap/NASA GIBS. Para Google Maps será necessária uma chave e configuração própria.

## 5. Segurança antes de produção
Este repositório é uma base funcional de desenvolvimento, não uma certificação de produção. Antes de publicar:
- usar HTTPS e proxy reverso;
- configurar CORS para o domínio real;
- guardar segredos num gestor de segredos;
- aplicar backups, monitorização, rate limiting e política de retenção;
- rever permissões, validação, auditoria e requisitos legais;
- configurar envio de e-mail e recuperação de palavra-passe;
- validar os limites agronómicos com especialistas locais.

## 6. Funcionalidades incluídas
- Registo e login com bcrypt/JWT;
- CRUD básico de fazendas;
- consulta meteorológica NASA POWER por coordenadas;
- mapa Leaflet com camada NASA GIBS;
- registo de medições e geração simples de alertas configuráveis;
- envio WhatsApp Cloud API (quando configurado);
- histórico de notificações.

## 7. API
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/farms`
- `POST /api/farms`
- `GET /api/climate/:farmId`
- `POST /api/climate/:farmId/sync`
- `GET /api/alerts`
- `POST /api/notifications/whatsapp/:farmId`
- `GET /api/health`

Todas as rotas exceto autenticação e health exigem `Authorization: Bearer <token>`.

## 8. Dados e limitações
Não são inseridos dados meteorológicos fictícios. O painel começa sem fazendas até o utilizador criar uma. As medições só aparecem após sincronização bem-sucedida com a fonte externa e são guardadas com data e fonte.
