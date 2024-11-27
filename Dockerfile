# Utiliser une image de base Python
FROM python:3.13.0-alpine3.20

# Installer Sphinx et toutes les autres dépendances nécessaires pour votre script Python
RUN pip install sphinx

# Installer toutes les dépendances nécessaires pour le script Python
RUN pip install --no-cache-dir some-package

# Définir le répertoire de travail pour l'application
WORKDIR /app

# Copier le script sum.py dans le conteneur
COPY sum.py /app/

# Créer un répertoire pour la documentation Sphinx
COPY ./docs /app/docs

# Définir le répertoire de travail où se trouvent le script sum.py et les documents
WORKDIR /app

# exécuter Sphinx pour initialiser la documentation
# RUN sphinx-quickstart /app/docs
