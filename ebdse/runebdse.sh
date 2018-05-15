#!/bin/bash

set -x

# <<offers:150000>>
# <<items:230000>>
# <<tokens:230000>>
# <<ingredients:2300>>
# <<recipes:230>>
# <<categories:3>>

offers=150000
items=23000
tokens=23000
ingredients=230
recipes=23
categories=3
threads=64
host=localhost
#arg=-v

/opt/ebdse/ebdse run type=dsegraph yaml=offers tags=phase:create-graph cycles=1 host=$host

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:graph-schema cycles=1 host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-offer-item-triple cycles=$offers cyclerate=1k host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-item-token-triple cycles=$items cyclerate=1k host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-token-ingredient-triple cycles=$tokens cyclerate=1k host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-ingredient-recipe-triple cycles=$ingredients cyclerate=1k host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-recipe-category-triple cycles=$recipes cyclerate=1k host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens
