#/bin/bash
ROS_WG_INTERFACE=wg0
ROS_WG_PORT="24846"
ROS_PUB_IP="164.132.20.163"
ROS_INT_IP="10.63.0.1"
ROS_PRIVKEY="IHGMCO1Fe4qSudzJWSIf59h98GLVV9fe+VqpdTetNFE="
ROS_PUBKEY="1AfttLiuJ4UHA7ixcGDoQYbwCsAvDp8kBMsebW7cyzQ="

LOC_PUB_IP="164.132.20.166"
LOC_INT_IP="10.63.0.3"
LOC_COMMENT="TEST"

### 

DIR_TMP=$(mktemp -d -p /tmp)
cd $DIR_TMP

wg genkey > privatekey
wg pubkey < privatekey > publickey

privatekey=$(cat privatekey)
pubkey=$(cat publickey)

rm -rf DIR_TMP

###

echo "
[Interface]
PrivateKey = $privatekey
Address = $LOC_INT_IP/32
DNS = 1.1.1.1,1.0.0.1
# pubkey = $pubkey

[Peer]
PublicKey = $ROS_PUBKEY
AllowedIPs = 0.0.0.0/0
Endpoint = $ROS_PUB_IP:$ROS_WG_PORT
" > /etc/wireguard/wg0.conf;

echo "### /etc/wireguard/wg0.conf ###"
cat /etc/wireguard/wg0.conf

echo "### /interface/wireguard/peers/ ###
add allowed-address=$LOC_INT_IP/32,$LOC_PUB_IP/32 comment=\"$LOC_COMMENT\" interface=\"$ROS_WG_INTERFACE\" public-key=\"$ROS_PUBKEY\"";
echo
echo