sudo apt update && sudo apt upgrade -y

# Install Deno
sudo apt install -y unzip
curl -fsSL https://deno.land/install.sh | bash
echo 'export DENO_INSTALL="/home/ubuntu/.deno"' >> ~/.bashrc
echo 'export PATH="$DENO_INSTALL/bin:$PATH"'    >> ~/.bashrc

# Install Docker
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker ; sudo usermod -aG docker $USER ; newgrp docker

# Install YC
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
yc container registry configure-docker
# Скопировать токен: https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb
yc init

# Init GH Runner
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.315.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.315.0/actions-runner-linux-x64-2.315.0.tar.gz
echo "6362646b67613c6981db76f4d25e68e463a9af2cc8d16e31bfeabe39153606a0  actions-runner-linux-x64-2.315.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.315.0.tar.gz

# Run GH Runner
./config.sh --url https://github.com/lebedev-nikita/my-website --token
./run.sh