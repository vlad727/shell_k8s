#!/bin/bash
#set -x 
while true
do
# GET ISTIO OPERATORS FOR CURRENT ENV
IOS=$(kubectl  get io -A --no-headers | awk 'NR!=1 {print $1}')

### FIRST LOOP BEGIN
for n in $IOS 
do
    #echo -e "control plane:\n$n " 
    #echo "--------------------------------------------" 

    # GET ALREADY ATTACHED NAMESPACES TO CONTROL PLANE
    NS_ATTACHED=$(kubectl get ns --selector istio.io/rev=$n --no-headers --ignore-not-found=true  | awk '{print $1}')
    if [[ -z $NS_ATTACHED ]]
        then 
            echo "control plane $n does not any connected namespaces"
    fi
    ### SECOND LOOP BEGIN
    # CHECK NAMESPACE DOES IT CONTAIN NET-ATTACH-DEF 
    for i in $NS_ATTACHED
    do OUTPUT=$(kubectl get net-attach-def -n $i --ignore-not-found=true)  
    if [ $? == 0 ] && ! [[ -z $OUTPUT ]] # -z check ouput is it empty?
        then 
            echo "$i contain network-attachments-definition" 1> /dev/null
        else 
            echo "$i does not contain network-attachments-definition"
            # ADD NET-ATTACH-DEF TO NS
            kubectl apply -f nad.yaml -n $i
            # CHECK THAT IS APPLIED 
            kubectl get net-attach-def -n $i
    fi 
    #echo "--------------------------------------------" 
    done ### END FOR SECOND LOOP 

done ### FIRST LOOP FINISH
sleep 10                
done ### END FOR WHILE
