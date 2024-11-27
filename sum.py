import sys

def additionner(arg1, arg2):
    """
    Additionne deux nombres et retourne le résultat.

    :param arg1: Premier nombre à additionner (float)
    :param arg2: Deuxième nombre à additionner (float)
    :return: La somme de arg1 et arg2 (float)
    """
    return arg1 + arg2

def main():
    """
    Fonction principale qui lit les arguments de la ligne de commande et les passe à 'additionner'.
    Elle affiche également le résultat dans la console.
    """
    # Vérifier si le bon nombre d'arguments a été passé
    if len(sys.argv) != 3:
        print("Usage: python sum.py <arg1> <arg2>")
        sys.exit(1)
    
    # Récupérer les arguments de la ligne de commande et les convertir en float
    arg1 = float(sys.argv[1])
    arg2 = float(sys.argv[2])

    # Calculer la somme
    result = additionner(arg1, arg2)

    # Afficher le résultat
    print(result)

if __name__ == '__main__':
    main()

