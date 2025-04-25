globals [
   individu-selectionne
   selected-attribut
]

turtles-own [
  role
  age
  situation-matrimoniale
  nombre-repas
  salaire
  condition-physique
  moyen-de-deplacement
  personnalite
  type-repas
  quartier
  compagnie-habituelle
  statut-social
  niveau-etude
  metier
  hobbies
  milieux-frequentes

  dechets-alimentaires
  dechets-plastiques
  dechets-papiers
  dechets-autres
]

to choisir-individu
  set individu-selectionne one-of turtles with [role = "individu"]
  set selected-attribut "age"  ;; Attribut par défaut
end

to setup
  clear-all
  create-turtles count_personne [
    set role "individu"
    setxy random-xcor random-ycor
    assign-individu-attributes
    set shape "person"
    set color blue
  ]
  create-turtles count_déchets [
    set role "dechet"
    setxy random-xcor random-ycor
    set shape "square"
    set color red
  ]
  create-turtles count_quartier [
    set role "quartier"
    setxy random-xcor random-ycor
    set shape "house"
    set color green
  ]
  reset-ticks
end

to-report get-value-attribut [agent attribut]
  if agent = nobody [report "Aucun individu"]

  ;; Vérifier si l'attribut est valide et renvoyer la bonne valeur
  if attribut = "age" [report [age] of agent]
  if attribut = "situation-matrimoniale" [report [situation-matrimoniale] of agent]
  if attribut = "salaire" [report [salaire] of agent]
  if attribut = "nombre-repas" [report [nombre-repas] of agent]
  if attribut = "statut-social" [report [statut-social] of agent]
  if attribut = "condition-physique" [report [condition-physique] of agent]
  if attribut = "moyen-de-deplacement" [report [moyen-de-deplacement] of agent]
  if attribut = "personnalite" [report [personnalite] of agent]
  if attribut = "type-repas" [report [type-repas] of agent]
  if attribut = "quartier" [report [quartier] of agent]
  if attribut = "compagnie-habituelle" [report [compagnie-habituelle] of agent]
  if attribut = "niveau-etude" [report [niveau-etude] of agent]
  if attribut = "metier" [report [metier] of agent]
  if attribut = "hobbies" [report liste-en-texte [hobbies] of agent]
  if attribut = "milieux-frequentes" [report liste-en-texte [milieux-frequentes] of agent]

  report "Inconnu"  ;; Si aucun attribut valide n'est trouvé
end

to-report liste-en-texte [liste]
  if empty? liste [ report "" ]  ;;

  report reduce [ [a b] -> (word a ", " b) ] liste  ;;
end

to assign-individu-attributes
  set age random 53 + 18
  set situation-matrimoniale one-of ["célibataire" "marié" "divorcé"]
  set nombre-repas 1 + random 3
  set salaire 50000 + random 450000
  set condition-physique one-of ["bonne" "moyenne" "mauvaise"]
  set moyen-de-deplacement one-of ["à pied" "moto" "voiture" "transport en commun"]
  set personnalite one-of ["économe" "gaspilleur" "écologique"]
  set type-repas one-of ["traditionnel" "moderne" "mixte"]
  set quartier one-of ["Bastos" "Essos" "Melen" "Nkoldongo"]
  set compagnie-habituelle one-of ["seul" "amis" "famille" "collègues"]
  set statut-social one-of ["bas" "moyen" "élevé"]
  set niveau-etude one-of ["primaire" "secondaire" "universitaire"]
  set metier one-of ["enseignant" "vendeur" "étudiant" "fonctionnaire" "artisan"]
  set hobbies n-of 2 ["sport" "lecture" "cinéma" "jeux" "marche" "cuisine"]
  set milieux-frequentes n-of 2 ["marché" "bureau" "bar" "maison" "église"]
  set dechets-alimentaires 0
  set dechets-plastiques 0
  set dechets-papiers 0
  set dechets-autres 0
end

to go
  ask turtles with [role = "individu"] [
    routine-journaliere
  ]
  tick
  update-plot-quartiers
end

to routine-journaliere
  let d-alim nombre-repas * (0.2 + random-float 0.3)
  set dechets-alimentaires dechets-alimentaires + d-alim
  creer-dechet "alimentaire" d-alim

  if moyen-de-deplacement != "à pied" [
    let d-plast 0.1 + random-float 0.2
    set dechets-plastiques dechets-plastiques + d-plast
    creer-dechet "plastique" d-plast
  ]

  if member? "bureau" milieux-frequentes [
    let d-papier 0.05 + random-float 0.15
    set dechets-papiers dechets-papiers + d-papier
    creer-dechet "papier" d-papier
  ]

  let d-autre 0
  if personnalite = "gaspilleur" [ set d-autre 0.2 + random-float 0.2 ]
  if personnalite = "économe" [ set d-autre 0.05 + random-float 0.05 ]
  if personnalite = "écologique" [ set d-autre 0.1 + random-float 0.1 ]
  set dechets-autres dechets-autres + d-autre
  creer-dechet "autres" d-autre
end

to update-plot-quartiers
  set-current-plot "Déchets par quartier"

  foreach ["Bastos" "Essos" "Melen" "Nkoldongo"] [
    quartier-name ->
    set-current-plot-pen quartier-name

    ;; Calculer la somme des déchets pour chaque quartier
    let total-dechets sum [
      dechets-alimentaires + dechets-plastiques + dechets-papiers + dechets-autres
    ] of turtles with [role = "individu" and quartier = quartier-name]

    ;; Afficher le total des déchets pour le quartier
    plot total-dechets
  ]
end

to creer-dechet [type-dechet quantite]
  repeat floor quantite [
    hatch 1 [
      set role "dechet"
      set shape (ifelse-value
                 type-dechet = "alimentaire" [ "circle" ]
                 type-dechet = "plastique"   [ "square" ]
                 type-dechet = "papier"      [ "triangle" ]
                 [ "star" ])

      set color (ifelse-value
                 type-dechet = "alimentaire" [ green ]
                 type-dechet = "plastique"   [ blue ]
                 type-dechet = "papier"      [ yellow ]
                 [ red ])
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
977
10
1492
526
-1
-1
15.364
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
47
56
165
89
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
44
159
167
193
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
192
88
357
121
count_personne
count_personne
0
100
90.0
10
1
NIL
HORIZONTAL

MONITOR
580
56
758
101
dechets-alimentaires
mean [dechets-alimentaires] of turtles
17
1
11

MONITOR
580
118
758
163
dechets-plastiques
mean [dechets-plastiques] of turtles
17
1
11

MONITOR
787
58
965
103
dechets-papiers
mean [dechets-papiers] of turtles
17
1
11

MONITOR
788
119
965
164
dechets-autres
mean [dechets-autres] of turtles
17
1
11

PLOT
0
559
237
723
Évolution des déchets
Time
Quantité
0.0
10.0
0.0
10.0
true
true
"" "set-current-plot-pen \"alimentaire\"\nplot sum [dechets-alimentaires] of turtles with [role = \"individu\"]\n\nset-current-plot-pen \"plastique\"\nplot sum [dechets-plastiques] of turtles with [role = \"individu\"]\n\nset-current-plot-pen \"papier\"\nplot sum [dechets-papiers] of turtles with [role = \"individu\"]\n\nset-current-plot-pen \"autres\"\nplot sum [dechets-autres] of turtles with [role = \"individu\"]\n"
PENS
"alimentaire" 1.0 0 -2674135 true "" ""
"plastique" 1.0 0 -7500403 true "" ""
"papier" 1.0 0 -13345367 true "" ""
"autres" 1.0 0 -16777216 true "" ""

PLOT
241
559
464
723
Déchets par quartier
Time
Quartier
0.0
10.0
0.0
10.0
true
true
"" "foreach [\"Bastos\" \"Essos\" \"Melen\" \"Nkoldongo\"] [\n  quartier-name ->\n  set-current-plot-pen quartier-name\n  let total-dechets sum [\n    dechets-alimentaires + dechets-plastiques + dechets-papiers + dechets-autres\n  ] of turtles with [role = \"individu\" and quartier = quartier-name]\n  plot total-dechets\n]\n"
PENS
"Bastos" 1.0 1 -1184463 true "" ""
"Essos" 1.0 1 -13403783 true "" ""
"Melen" 1.0 1 -13345367 true "" ""
"Nkoldongo" 1.0 1 -16777216 true "" ""

PLOT
492
562
710
725
Déchets par personnalité
Time
Personnalité
0.0
10.0
0.0
10.0
true
true
"" "to plot-dechets-par-personnalite\n  set-current-plot \"Déchets par personnalité\"\n  let personnalites [\"économe\" \"gaspilleur\" \"écologique\"]\n  clear-plot\n  let personnalites-numeriques [0 1 2]\n  foreach personnalites-numeriques [\n    idx -> \n    let personnalite-nom (item idx personnalites)\n    plotxy idx (count dechets with [ [personnalite] of producteur = personnalite-nom ])\n  ]\nend"
PENS
"économe" 1.0 1 -10899396 true "" ""
"gaspilleur" 1.0 1 -13345367 true "" ""
"écologique" 1.0 1 -2674135 true "" ""

SLIDER
192
136
359
169
count_déchets
count_déchets
0
100
100.0
2
1
NIL
HORIZONTAL

SLIDER
192
183
361
216
count_quartier
count_quartier
0
100
100.0
2
1
NIL
HORIZONTAL

PLOT
720
565
933
725
Déchets par statut social
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" "foreach [\"bas\" \"moyen\" \"élevé\"] [\n  statut ->\n  set-current-plot-pen statut\n  let total-dechets sum [\n    dechets-alimentaires + dechets-plastiques + dechets-papiers + dechets-autres\n  ] of turtles with [role = \"individu\" and statut-social = statut]\n  plot total-dechets\n]\n"
PENS
"bas" 1.0 0 -2674135 true "" ""
"moyen" 1.0 0 -13791810 true "" ""
"élevé" 1.0 0 -2754856 true "" ""

BUTTON
46
105
166
141
Choisir un individu
choisir-individu\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
397
188
918
518
Déchets par attribut
Attributs
Quantité de déchets
0.0
10.0
0.0
10.0
true
false
"" "if individu-selectionne != nobody [\n  clear-plot\n  \n  let total-dechets (\n    ([dechets-alimentaires] of individu-selectionne) +\n    ([dechets-plastiques] of individu-selectionne) +\n    ([dechets-papiers] of individu-selectionne) +\n    ([dechets-autres] of individu-selectionne)\n  )\n  \n  let x-value 0\n  \n  if attribut-selectionne = \"age\" [ set x-value [age] of individu-selectionne ]\n  if attribut-selectionne = \"salaire\" [ set x-value [salaire] of individu-selectionne ]\n  if attribut-selectionne = \"nombre-repas\" [ set x-value [nombre-repas] of individu-selectionne ]\n  \n  ; Pour les attributs textuels, on peut assigner une valeur numérique\n  if attribut-selectionne = \"statut-social\" [\n    let val [statut-social] of individu-selectionne\n    set x-value (position val [\"bas\" \"moyen\" \"élevé\"])\n  ]\n  \n  ; Ajoute ici les autres cas si tu veux les mapper aussi\n  \n  plotxy x-value total-dechets\n]\n"
PENS
"individu" 1.0 1 -13345367 true "" ""

MONITOR
387
116
552
161
selected-attribut
ifelse-value individu-selectionne != nobody\n  [ get-value-attribut individu-selectionne selected-attribut ]\n  [ \"Aucun individu sélectionné\" ]
17
1
11

MONITOR
388
56
551
101
individu-selectionne 
individu-selectionne
17
1
11

CHOOSER
193
31
356
76
attribut-selectionne
attribut-selectionne
"age" "salaire" "nombre-repas" "statut-social" "situation-matrimoniale" "condition-physique" "moyen-de-deplacement" "personnalite" "type-repas" "quartier" "compagnie-habituelle" "niveau-etude" "metier" "hobbies" "milieux-frequentes"
9

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house efficiency
false
0
Rectangle -7500403 true true 180 90 195 195
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 165 75 165 150 90
Line -16777216 false 75 165 225 165

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

quartier
true
0
Rectangle -7500403 true true 90 120 120 150
Polygon -7500403 true true 75 120 75 120 75 120 135 120 105 90 75 120
Circle -16777216 true false 105 135 0

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
