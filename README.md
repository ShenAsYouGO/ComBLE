Nom du projet : ComBLE <br>
Version du document : 1.1
ETAT : En cours, je compte continuer même en dehors de mon stage, je vais pouvoir m'y plonger dedans.
ANWSER : 

# Introduction
## Présentation de l’entreprise
L’Entreprise Arcsolu est une SARL spécialisée dans le développement d’ERP, de machine d’encaissement certifié NF525,

elle vend principalement leur service à des restaurateurs ainsi qu’à des magasins.

## Enjeux de la demande
À l’aide du langage flûter, crée une connexion entre le client et le serveur à l’aide de Bluetooth et laisser la possibilité au client de se connecter à différents appareils, avoir la possibilité d’afficher le message envoyé par le client.

Cela permettrait par exemple dans un restaurant de pouvoir commander la commande d’un client à distance et de l’afficher à l’aide du Bluetooth.

# Analyse du besoin
## Objectif
Crée une connexion entre le client et le serveur, pour pouvoir transmettre des informations en utilisant le Bluetooth (BLE = Bluetooth low energy)

## Description
2 appareils représentant l’un, le serveur et l’autre, le client, le client doit pouvoir détecter le serveur et transmettre des informations via Bluetooth.
Le client doit avoir la possibilité de choisir le serveur.
Le serveur doit pouvoir afficher l’information transmise.
Outils
J’utiliserai le langage Flutter avec l’IDE Android studio pour ce projet.

**L'app affichera dans un premier temps, le choix d'être soit un serveur soit un client, s'il choisit d'être le client, il devra choisir le serveur a lequel il veut se connecter, si c'est un serveur, il doit attendre une connexion.
Lorsque le client est connecté, il va pouvoir envoyer des messages et le serveur devrait pouvoir l'afficher.**

## Outil disponible
Pour ce projet j'utiliserai Flutter à l'aide Android studio, mais avec également un plugin, Flutter blue plus qui permet une connection en BLE plus efficace.

## Maquette
Communication entre un client et un serveur.

![](/img/1s1c.png)

Communication entre un client et plusieurs serveurs.

![](/img/2s1c.png)

Le client choisir le serveur ou il veut communiquer.

Dans le cas contraire ou il y a plusieurs clients et un seul serveur, tous les clients communiques sur le même serveur.

![](/img/1s2c.png)

## Diagramme
![](/img/CasUtilisations.png)
