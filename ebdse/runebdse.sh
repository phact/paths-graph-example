#!/bin/bash

set -x

#Vs
person=50000
account=50000       # same as person
application=2500    # 5% of person
creditCard=37500    # 75% of person
device=37500        # 75% of person
event=200000        # 4x person

#Es
familyMember=12500  # 25% of person
submittedApp=2500   # same as application
listedOnApp=50000   # same as account
ownsAccount=50000   # same as account
transferTo=200000   # same as event
transferFrom=200000 # same as event

#misc
rate=10k
threads=64
host=node0
graphname=paths
reads=100
#arg=-v

if [ $# -gt 0 ]; then
    echo $1
    host=$1
fi


# type is dsegraph, cql, or sparksql (workload type)
# yaml the name of your yaml in ./activities/
# tags help you design which block from the yaml to run (user defined in the yaml)
# cycles can be a number (1M) or a range (10..100000) how many times to run
# host - a dse node
# nameofgraph is a <<>> pointy bracket thing in the yaml
# you are not allowed to provide a graphname argument in the create call

# ### 1. CREATE THE GRAPH #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths tags=phase:create-graph cycles=1 host=$host nameofgraph=$graphname

# ### 2. PRODUCTION MODE #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:prod-mode cycles=1 host=$host

# ### 2. CREATE THE SCHEMA #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:graph-schema cycles=1 host=$host

# ### 3. INITIALIZE PEOPLE VERTICES #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:insert-people cycles=$person cyclerate=$rate host=$host threads=$threads account=$account person=$person application=$application creditCard=$creditCard device=$device event=$event

# ### 4. CREATE STAR GRAPHS #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:add-ownsAccount-edge cycles=$person cyclerate=$rate host=$host threads=$threads account=$account person=$person application=$application creditCard=$creditCard device=$device event=$event

# ### 5. CREATE FAMILY MEMBERS #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:add-familyMember-edge cycles=$familyMember cyclerate=$rate host=$host threads=$threads account=$account person=$person application=$application creditCard=$creditCard device=$device event=$event

# ### 6. CREATE APPLICATIONS #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:add-submittedApp-edge cycles=$application cyclerate=$rate host=$host threads=$threads account=$account person=$person application=$application creditCard=$creditCard device=$device event=$event

# ### 7. CREATE EVENTS BETWEEN ACCOUNTS #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:add-event-edge cycles=$event cyclerate=$rate host=$host threads=$threads account=$account person=$person application=$application creditCard=$creditCard device=$device event=$event

# ### 8. TURN ON ANALYTICS QUERIES #####
/tmp/ebdse/ebdse run type=dsegraph yaml=paths graphname=$graphname tags=phase:queries-enabled cycles=1 host=$host
