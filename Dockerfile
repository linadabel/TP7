# Utiliser l'image Python Alpine légère
FROM python:3.13.0-alpine3.20

# Copier le script Python dans le conteneur
COPY sum.py /app/sum.py

# Commande par défaut pour exécuter le script avec des arguments
CMD ["python", "/app/sum.py"]
