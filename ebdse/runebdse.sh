#!/bin/bash

set -x

# <<offers:150000>>
# <<items:230000>>
# <<tokens:230000>>
# <<ingredients:2300>>
# <<recipes:230>>
# <<categories:3>>

#Vs
offers=4000000
items=2300000
tokens=1500000
ingredients=150000
recipes=15000
categories=201

#Es
recipecategory=145000
tokeningredient=150000
#ingredientrecipe=150000
ingredientrecipe=300000
offeritem=4000000
itemtoken=1500000

#misc
rate=10k
threads=64
host=node0
graphname=offers3
reads=100
#arg=-v

/opt/ebdse/ebdse run type=dsegraph yaml=offers tags=phase:create-graph cycles=1 host=$host nameofgraph=$graphname

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:graph-schema cycles=1 host=$host

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-recipe-category-triple cycles=$recipecategory recipecategory=$recipecategory  cyclerate=$rate host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-ingredient-recipe-triple cycles=$ingredientrecipe ingredientrecipe=$ingredientrecipe  cyclerate=$rate host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-token-ingredient-triple cycles=$tokeningredient tokeningredient=$tokeningredient  cyclerate=$rate host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-item-token-triple cycles=$itemtoken itemtoken=$itemtoken  cyclerate=$rate host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-offer-item-triple cycles=$offeritem offeritem=$offeritem  cyclerate=$rate host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-item-prices cycles=$items cyclerate=$rate host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:read cycles=$reads cyclerate=$rate host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens
