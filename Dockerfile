# ARQUIVO DE DEFINIÇÃO DO DOCKER
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

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
# O --no-cache-dir evita que o pip armazene os pacotes baixados em cache, sempre fazendo instalações do zero, caso algum arquivo tenha sido alterado.
RUN pip install --no-cache-dir -r requirements.txt 

# Copy the rest of the application code into the container
COPY . .

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# PARA CRIAR A IMAGEM, EXECUTAR O COMANDO ABAIXO NO TERMINAL, AONDE -t É A TAG DA IMAGEM E O "." É O DIRETÓRIO ATUAL. O DOCKER PRECISA ESTAR RODANDO.
# docker build -t api .
#
# docker images -> PARA VER AS IMAGENS CRIADAS
#
# docker run -p 8000:8000 api <nome da imagem> -> PARA RODAR A IMAGEM CRIADA, MAPEANDO A PORTA 8000 DO CONTAINER PARA A PORTA 8000 DA APLICAÇÃO
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