#!/bin/bash +x

while [ ! -f /opt/instruqt/bootstrap/host-bootstrap-completed ]
do
    echo "Waiting for Instruqt to finish booting the VM"
    sleep 1
done

# Run k3s in agent mode
K3S_CMD=agent
K3S_NODE_NAME=$(hostname)
export K3S_NODE_NAME
K3S_CONTROL_PLANE_HOSTNAME=kubernetes
if [ -n "$K3S_CONTROL_PLANE_HOSTNAME" ]; then
    # Try to fetch node-token from control plane server
    RETRIES=300
    while [ $RETRIES -gt 0 ]; do
        if ! nc -z "$K3S_CONTROL_PLANE_HOSTNAME" 6443; then
            echo "Waiting for k3s api"
            sleep 1
            RETRIES=$((RETRIES-1))
            continue
        fi

        K3S_TOKEN=$(ssh -qo StrictHostKeyChecking=no "${K3S_CONTROL_PLANE_HOSTNAME}" cat /var/lib/rancher/k3s/server/node-token)
        if [ -n "${K3S_TOKEN}" ]; then
            export K3S_TOKEN
            break
        fi

        echo "Waiting for server token to be available"
        sleep 1
        RETRIES=$((RETRIES-1))
    done

    K3S_CONTROL_PLANE_IP=$(host "$K3S_CONTROL_PLANE_HOSTNAME" | grep ' has address ' | awk '{print $NF}')
    K3S_URL="https://${K3S_CONTROL_PLANE_IP}:6443/"
    export K3S_URL
    /usr/local/bin/k3s agent
fi