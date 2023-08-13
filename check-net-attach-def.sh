#!/bin/bash

# GET ALREADY ATTACHED NAMESPACES TO CONTROL PLANE
NS_ATTACHED=$(kubectl get ns --selector istio.io/rev=test-cp --no-headers | awk '{print $1}')

while true
do
# CHECK NAMESPACE DOES IT CONTAIN NET-ATTACH-DEF 
for i in $NS_ATTACHED
do OUTPUT=$(kubectl get pods -n $i --ignore-not-found=true)  
if [ $? == 0 ] && ! [[ -z $OUTPUT ]] # -z check ouput is it empty?
    then 
        echo "$i contain pods"
    else 
        echo "$i does not contain pods"
        # ADD NET-ATTACH-DEF TO NS
        echo "kubectl apply -f net-attach-def -n $i"
fi 
echo "--------------------------------------------" 
done
sleep 10 
done
