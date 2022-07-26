#!/usr/bin/env bash
set -ex

start_service() {
  cat <<EOF > /usr/lib/systemd/system/consul.service
[Unit]
Description="consul"
Requires=network-online.target
After=network-online.target

[Service]
Environment="PORT=80"
Type=simple
ExecStart=/usr/bin/consul agent -data-dir /var/consul -config-dir=/etc/consul.d/
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
  systemctl enable consul.service
  systemctl start consul.service
}

setup_deps() {
  add-apt-repository universe -y
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  curl -sL 'https://deb.dl.getenvoy.io/public/gpg.8115BA8E629CC074.key' | gpg --dearmor -o /usr/share/keyrings/getenvoy-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/getenvoy-keyring.gpg] https://deb.dl.getenvoy.io/public/deb/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/getenvoy.list
  apt update -qy
  version="${consul_version}"
  consul_package="consul="$${version:1}"*"
  cts_package="consul-terraform-sync="$${cts_version:1}"*"
  apt install -qy apt-transport-https gnupg2 curl lsb-release nomad $${consul_package} $${cts_package} getenvoy-envoy unzip jq apache2-utils nginx

  curl -fsSL https://get.docker.com -o get-docker.sh
  sh ./get-docker.sh
  curl https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
  func-e use 1.20.1
  cp ~/.func-e/versions/1.20.1/bin/envoy /usr/local/bin/
}

setup_networking() {
  # echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-arptables
  # echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-ip6tables
  # echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-iptables
  curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$([ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.0.0.tgz
  mkdir -p /opt/cni/bin
  tar -C /opt/cni/bin -xzf cni-plugins.tgz
}

setup_consul() {
  mkdir --parents /etc/consul.d /var/consul
  chown --recursive consul:consul /etc/consul.d
  chown --recursive consul:consul /var/consul

  cat <<EOF >/etc/consul.d/consul.hcl
data_dir = "/opt/consul"
bind_addr = "$(hostname -I | awk '{print $1}')"
EOF
}

setup_services() {
  curl -L -o counting-service.zip https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip
  curl -L -o dashboard-service.zip https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip
  sudo unzip counting-service.zip -d /usr/local/bin
  sudo unzip dashboard-service.zip -d /usr/local/bin
  rm counting-service.zip dashboard-service.zip
}

cd /home/ubuntu/

setup_networking
setup_deps

setup_consul

start_service "consul"

# nomad and consul service is type simple and might not be up and running just yet.
sleep 10

setup_services

echo "done"
