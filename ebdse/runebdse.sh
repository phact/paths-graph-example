#!/bin/bash

set -x

#Vs
person=4000
application=400
account=4000
event=40000

#Es
familyMember=10
submittedApp=400
listedOnApp=400
ownsAccount=4000
transferTo=40000
transferFrom=40000

#misc
rate=10k
threads=64
host=localhost
graphname=paths
reads=100
#arg=-v

# type is dsegraph, cql, or sparksql (workload type)
# yaml the name of your yaml in ./activities/
# tags help you design which block from the yaml to run (user defined in the yaml)
# cycles can be a number (1M) or a range (10..100000) how many times to run
# host - a dse node
# nameofgraph is a <<>> pointy bracket thing in the yaml
# you are not allowed to provide a graphname argument in the create call
/tmp/ebdse/ebdse run type=dsegraph yaml=paths tags=phase:create-graph cycles=1 host=$host nameofgraph=$graphname

# graphname is required in all the dsegraph types unless you are creating a graph
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:graph-schema cycles=1 host=$host

# The rest of these are <<>> in the yaml
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:add-familyMember-edge cycles=$familyMember person=$person cyclerate=$rate host=$host threads=$threads

/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:add-ownsAccount-edge cycles=$ownsAccount account=$account person=$person cyclerate=$rate host=$host threads=$threads