The script that checks for an existing instance - assigns a floating ip - and lists the instance details

#!/bin/bash
# Advanced OpenStack Script: Create an Instance and Assign a Floating IP
INSTANCE_NAME="MyInstance"
IMAGE_NAME="Ubuntu 20.04"
FLAVOR_NAME="m1.small"
NETWORK_NAME="private_network"
FLOATING_IP_POOL="public"
# Function to get the status of an instance
get_instance_status() {
openstack server show "$1" -f value -c status
}
# Check if the instance already exists
if openstack server list | grep -q "$INSTANCE_NAME"; then
echo "Instance $INSTANCE_NAME already exists."
else
# Create a new instance
echo "Creating instance $INSTANCE_NAME..."
openstack server create --image "$IMAGE_NAME" --flavor "$FLAVOR_NAME" --
network "$NETWORK_NAME" "$INSTANCE_NAME"
Â Â Â Â 
# Wait for the instance to be ACTIVE
while [ $(get_instance_status "$INSTANCE_NAME") != "ACTIVE" ]; do
Â Â Â Â  sleep 5
done
echo "Instance $INSTANCE_NAME is active."
fi
# Assign a floating IP if not already assigned
if ! openstack server show "$INSTANCE_NAME" -f value -c addresses | grep -
q "float"; then
# Create and assign a floating IP
FLOATING_IP=$(openstack floating ip create "$FLOATING_IP_POOL" -f value -c 
floating_ip_address)
openstack server add floating ip "$INSTANCE_NAME" "$FLOATING_IP"
echo "Assigned floating IP $FLOATING_IP to $INSTANCE_NAME."
else
echo "Instance $INSTANCE_NAME already has a floating IP."
fi
# Show instance details
echo "Instance $INSTANCE_NAME details:"
openstack server show "$INSTANCE_NAME"
