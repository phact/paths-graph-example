#!/bin/bash

# <<offers:150000>>
# <<items:230000>>
# <<tokens:230000>>
# <<ingredients:2300>>
# <<recipes:230>>
# <<categories:3>>

offers=15000000
items=23000000
tokens=23000000
ingredients=230000
recipes=23000
categories=300
threads=64

/opt/ebdse/ebdse -v run type=dsegraph yaml=offers tags=phase:create-graph cycles=1 host=node0

/opt/ebdse/ebdse -v run type=dsegraph yaml=offers graphname=offers tags=phase:graph-schema cycles=100 host=node0 threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories

/opt/ebdse/ebdse -v run type=dsegraph yaml=offers graphname=offers tags=phase:add-offer-coupon-triple cycles=15000000 cyclerate=1k host=node0  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories

/opt/ebdse/ebdse -v run type=dsegraph yaml=offers graphname=offers tags=phase:add-item-token-triple cycles=23000000 cyclerate=1k host=node0 threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories

/opt/ebdse/ebdse -v run type=dsegraph yaml=offers graphname=offers tags=phase:add-token-ingredient-triple cycles=23000000 cyclerate=1k host=node0 threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories

/opt/ebdse/ebdse -v run type=dsegraph yaml=offers graphname=offers tags=phase:add-ingredient-recipe-triple cycles=230000 cyclerate=1k host=node0 threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories

/opt/ebdse/ebdse -v run type=dsegraph yaml=offers graphname=offers tags=phase:add-recipe-category-triple cycles=23000 cyclerate=1k host=node0 threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories
