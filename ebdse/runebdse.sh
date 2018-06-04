#!/bin/bash

set -x

#Vs
offers=4000
items=2300
tokens=1500
ingredients=150
recipes=150
categories=200

#Es
recipecategory=145
tokeningredient=150
ingredientrecipe=300
offeritem=4000
itemtoken=1500

#misc
rate=10k
threads=64
host=localhost
graphname=offers3
reads=100
#arg=-v

# type is dsegraph, cql, or sparksql (workload type)
# yaml the name of your yaml in ./activities/
# tags help you design which block from the yaml to run (user defined in the yaml)
# cycles can be a number (1M) or a range (10..100000) how many times to run
# host - a dse node
# nameofgraph is a <<>> pointy bracket thing in the yaml
# you are not allowed to provide a graphname argument in the create call
/tmp/ebdse/ebdse run type=dsegraph yaml=offers tags=phase:create-graph cycles=1 host=$host nameofgraph=$graphname

# graphname is required in all the dsegraph types unless you are creating a graph
/tmp/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:graph-schema cycles=1 host=$host

# The rest of these are <<>> in the yaml
/tmp/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-recipe-category-edge cycles=$recipecategory recipecategory=$recipecategory  cyclerate=$rate host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/tmp/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-ingredient-recipe-edge cycles=$ingredientrecipe ingredientrecipe=$ingredientrecipe  cyclerate=$rate host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/tmp/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-token-ingredient-edge cycles=$tokeningredient tokeningredient=$tokeningredient  cyclerate=$rate host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/tmp/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-item-token-edge cycles=$itemtoken itemtoken=$itemtoken  cyclerate=$rate host=$host threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/tmp/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-offer-item-edge cycles=$offeritem offeritem=$offeritem  cyclerate=$rate host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/tmp/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:add-item-prices cycles=$items cyclerate=$rate host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens

/tmp/ebdse/ebdse run type=dsegraph yaml=offers graphname=$graphname tags=phase:read cycles=$reads cyclerate=$rate host=$host  threads=$threads offers=$offers items=$items ingredients=$ingredients recipes=$recipes categories=$categories tokens=$tokens
