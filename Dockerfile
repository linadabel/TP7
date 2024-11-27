# Utiliser une image Python officielle
FROM python:3.9-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires
COPY . /app

# Installer les dépendances (si vous avez un fichier requirements.txt)
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port 5000 (assurez-vous que votre application écoute sur ce port)
EXPOSE 5000

# Lancer l'application avec Python
CMD ["python", "sum.py"]
