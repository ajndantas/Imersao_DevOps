# ARQUIVO DE DEFINIÇÃO DO DOCKER
#
# AQUI VAI TUDO O QUE MODIFICA A IMAGEM
#
# DEVE-SE BAIXAR UMA IMAGEM DO DOCKERHUB PARA SER PASSADA NO FROM. UMA Imagem base do Python
# https://hub.docker.com/search?q=python OPTAR PELAS IMAGENS OFICIAIS (https://hub.docker.com/_/python)
# 
# AS IMAGENS ALPINE SÃO IMAGENS MENORES, MAS NÃO TEM TODAS AS BIBLIOTECAS. IMAGENS MENORES SÃO MAIS RÁPIDAS.
#
# https://github.com/docker-library/python/blob/3fae0a14ac171f46e47d7ce41567e40524af5bcc/3.13/alpine3.22/Dockerfile
#
# REFERENCIA SOBRE OS COMMANDOS DO DOCKERFILE (https://docs.docker.com/reference/dockerfile/)
#
# FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]. A TAG (SimpleTags) SE COPIA DO SITE DO DOCKERHUB
FROM python:3.13.5-alpine3.22

# PODEMOS USAR A IA PARA GERAR OS COMANDOS DO DOCKERFILE, PASSANDO COMO CONTEXTO O SCRIPT PYTHON PRINCIPAL, QUE É O app.py

# Set the working directory. PASTA DO CONTAINER ONDE OS COMANDOS SERÃO EXECUTADOS
WORKDIR /app

# Copy the requirements file into the container. O arquivo requirements.txt deve estar no mesmo diretório do Dockerfile, ou o caminho deve ser ajustado.
COPY requirements.txt .

# Install the dependencies
# O --no-cache-dir evita que o pip armazene os pacotes baixados em cache, sempre fazendo instalações do zero, caso algum arquivo tenha sido alterado.
# A DIFERENÇA PARA O CMD, É QUE O RUN RODA EM TEMPO DE CONSTRUCAO (BUILD), O CMD RODA EM TEMPO DE EXECUCAO (RUNTIME)
RUN pip install --no-cache-dir -r requirements.txt 

# Copy the rest of the application code into the container
COPY . .

# Expose the port the container runs on
EXPOSE 8000 

# Command to run the application
## BOM PARA DESENVOLVIMENTO, MAS NÃO É BOM PARA PRODUÇÃO, POIS O --reload RECARREGA A APLICAÇÃO A CADA MUDANÇA NO CÓDIGO
#CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"] # A PORTA AQUI É A MESMA DO EXPOSE
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

# PARA CRIAR A IMAGEM, EXECUTAR O COMANDO ABAIXO NO TERMINAL, AONDE PARA -t É PASSADA A IMAGEM:TAG, QUE POR PADRÃO, CASO NÃO PASSADA, FICA COM A TAG latest. 
# O "." É O DIRETÓRIO ATUAL. O DOCKER PRECISA ESTAR RODANDO.
#
# docker build -t api .
#
# docker images -> PARA VER AS IMAGENS CRIADAS
#
# docker run -p 8000:8000 <nome da imagem> -> PARA RODAR A IMAGEM CRIADA, MAPEANDO A PORTA 8000 DA APLICAÇÃO (FORA) PARA A PORTA 8000 DO CONTAINER (DENTRO)
#
#(venv) PS G:\Meu Drive\Cursos e Treinamentos\Cientista de Dados\Treinamento Python\Imersao DevOps Alura> docker run -p 8000:8000 api
#INFO:     Will watch for changes in these directories: ['/app']
#INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
#INFO:     Started reloader process [1] using StatReload
#INFO:     Started server process [8]
#INFO:     Waiting for application startup.
#INFO:     Application startup complete.
#
# PODEMOS DISPONIBILIZAR A IMAGEM PARA SER BAIXADA, E DEPOIS SER EXECUTADA.

# Qual é a diferença entre CMD e RUN no Dockerfile ?

# O Gemini disse
# Essa é uma das dúvidas mais comuns de quem está começando com Docker! A diferença fundamental é quando o comando é executado e o que ele faz com a imagem.

# 1. RUN: A fase de construção (Build)
# O RUN é executado durante o processo de criação da imagem. Pense nele como uma "instalação".

# O que faz: Executa um comando, salva o resultado (commit) e cria uma nova camada na imagem.

# Exemplos: Instalar pacotes (apt-get install), criar pastas (mkdir), baixar dependências (npm install) ou compilar código.

# Frequência: Ele roda apenas uma vez (no build). O resultado fica "congelado" dentro da imagem.

# 2. CMD: A fase de execução (Runtime)
# O CMD define o comando padrão que o container executará quando for iniciado.

# O que faz: Não altera a imagem. Ele apenas diz: "Ei, quando esse container subir, rode isso aqui".

# Exemplos: Iniciar um servidor web (apache2ctl -D FOREGROUND), rodar um script de entrada ou iniciar o n8n (n8n start).

# Frequência: Roda toda vez que você inicia o container.

# Sobrescrita: Se você rodar docker run imagem ls, o ls vai ignorar o CMD que você definiu no Dockerfile.

# Tabela Comparativa
# Característica	RUN	                                        CMD
# Momento	        Durante o docker build.	                    Durante o docker run.
# Objetivo	    Instalar software e preparar o ambiente.	Iniciar a aplicação principal.
# Resultado	    Cria camadas permanentes na imagem.	        Não altera a imagem, apenas define o processo.
# Quantidade	    Pode ter vários no Dockerfile.	            Apenas o último no arquivo é considerado.