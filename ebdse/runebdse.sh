#!/bin/bash

set -x

# <<offers:150000>>
# <<items:230000>>
# <<tokens:230000>>
# <<ingredients:2300>>
# <<recipes:230>>
# <<categories:3>>

offers=15000000
items=2300000
tokens=2300000
ingredients=23000
recipes=2300
categories=30
threads=64
host=node0
reads=100000
#arg=-v

/opt/ebdse/ebdse run type=dsegraph yaml=offers tags=phase:create-graph cycles=1 host=$host

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:graph-schema cycles=1 host=$host

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-recipe-category-triple cycles=$recipes cyclerate=1k host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-ingredient-recipe-triple cycles=$ingredients cyclerate=1k host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-token-ingredient-triple cycles=$tokens cyclerate=1k host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-item-token-triple cycles=$items cyclerate=1k host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-offer-item-triple cycles=$offers cyclerate=1k host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:add-item-prices cycles=$items cyclerate=1k host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/opt/ebdse/ebdse run type=dsegraph yaml=offers graphname=offers tags=phase:read cycles=$reads cyclerate=1k host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens
