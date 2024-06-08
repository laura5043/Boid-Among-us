
<h1>Présentation du projet</h1>

Dans ce repository vous trouverez l'ensemble du projet Boid-Among-us développé dans le cadre d'un projet d'école. L'objectif fut de simuler la propagation d'un virus quelconque au sein d'une population. Pour illustrer cette simulation, nous avons voulu créer un jeu qui serait à la fois instructif et divertissant en nous basant sur le célèbre jeu **Among us**.

<h2>1. Objectif du jeu</h2>

Dans ce projet vous trouverez deux modes de jeux, un mode **Solo** et un mode **Multijoueur**.

<h3>Mode Solo</h3>

Dans le mode **Solo** vous incarnez l'agent **Imposteur** (personnage rouge) autrement dit le patient zéro de l'infection. L'objectif de l'imposteur est d'infecté tous les autres agent **sain**.
L'infection d'un agent **sain** se réalise en plusieurs étapes, dans un premier temps il rentre en contact avec l'imposteur (joueur) et obtient le statut **infecté**, après 8 secondes il passera du statut **infecté** au statut **mort**. L'imposteur l'emporte lorsque tous les agents **sain** sont **mort**.

Contrairement au joueur l'objectif de l'agent **docteur** (personnage blanc) est de guérir les agents **infecté**, celui ci gagne lorsqu'un certain nombre d'agent guérit est atteint.

<h3>Mode Multijoueur</h3>

Dans le mode **multijoueur** le jeu est jouable en local à deux joueur. Le joueur 1 incarne **l'imposteur** (contrôlable avec les flèches du clavier) et le joueur 2 incarne le **docteur** (contrôlable avec la souris). Les objectifs respectifs restent les mêmes que dans le mode solo.

<img width="350" alt="image" src="https://github.com/laura5043/Boid-Among-us/assets/127864434/e369067d-77d4-4d0e-9442-3ee38065647b" class="center">

<h2>2. Mise en place</h2>

L'ensemble de ce projet a été réaliser sur **Godot engine v3.5.3** un moteur de jeu gratuit et open-source disponible sur le site ci-dessous :

<link>https://godotengine.org/download/3.x/windows/</link>

Pour charger le projet il vous suffit de récupérer le projet

