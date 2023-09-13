ROS_WAN_INTERFACE=ether2
ROS_WG_INTERFACE=wg0
ROS_WG_PORT="24846"
ROS_PUB_IP="164.132.20.163"
ROS_PUB_SUB="28"
ROS_INT_IP="10.63.0.1"
ROS_INT_SUB="24"


DIR_TMP=$(mktemp -d -p /tmp)
cd $DIR_TMP

wg genkey > privatekey
wg pubkey < privatekey > publickey

ROS_PRIVKEY=$(cat privatekey)
ROS_PUBKEY=$(cat publickey)

rm -rf DIR_TMP


echo "### /interface/wireguard ###

ROS_PRIVKEY=\"$ROS_PRIVKEY\"
ROS_PUBKEY=\"$ROS_PUBKEY\"

/interface wireguard
add listen-port=$ROS_WG_PORT name=$ROS_WG_INTERFACE private-key=\"$ROS_PRIVKEY\" public-key=\"$ROS_PUBKEY\"

/ip address
add address=$ROS_PUB_IP/$ROS_PUB_SUB  interface=$ROS_WAN_INTERFACE
add address=$ROS_INT_IP/$ROS_INT_SUB  interface=$ROS_WG_INTERFACE

";