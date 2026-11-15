# multi-booting
Ubuntu &amp; Windows

## 호스트 설치
```bash
sudo apt update && sudo apt upgrade -y
sudo apt-get update

# Chrome
sudo apt install -y wget
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i ./google-chrome-stable_current_amd64.deb

# 우분투 -> 윈도우
# 실행 권한 부여, 한 번만 설정
sudo chmod +x windows.sh
sudo ./windows.sh

# Terminator
sudo apt install terminator -y

# VScode
sudo apt update
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code

# gemini-cli
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g @google/gemini-cli

# claude code
sudo npm install -g @anthropic-ai/claude-code

# codex
sudo npm install -g @openai/codex
```
### Docker
``` bash{
# Docker 설치
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release

# 키를 저장할 디렉토리 생성
sudo mkdir -p /etc/apt/keyrings

# GPG 키 다운로드 및 저장
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 키 파일 권한 설정 (모든 사용자가 읽을 수 있도록)
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 현재 사용자를 docker 그룹에 추가
sudo usermod -aG docker $USER

# 변경 사항을 즉시 적용 (로그아웃 후 다시 로그인하는 효과)
newgrp docker

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

# Docker에 Nvidia 런타임 설정
sudo nvidia-ctk runtime configure --runtime=docker
# Docker 재시작
sudo systemctl restart docker

```
---

## 컨테이너 설치
``` bash
apt update && apt upgrade -y
apt install curl wget gedit sudo git

apt-get update
apt-get install -y nvidia-cuda-toolkit
nvcc --version
```

## ~/.bashrc 설정
``` bash
gedit ~/.bashrc

# docker compose 실행 함수
compose() {
  docker compose -f ~/docker/"$1".yml up -d "$1"
}

# docker 접속 함수
exec() {
  docker exec -it "$1" bash
}

start() {
  docker start "$1"
}

alias vnc='vncviewer localhost:59000'
alias chang='ssh -L 59000:localhost:5901 -C -N -l ubuntu 113.198.65.72'
alias npu='ssh -p 22015 -L 59000:localhost:5901 -C -N -l jairlab 113.198.65.72'
alias 201='ssh -L 59000:localhost:5901 -C -N -l airlab 172.22.81.200'
alias go2='ssh -L 59000:localhost:5901 -C -N -l unitree 192.168.0.6'
```

## VS Code ssh 설정
```
Host 창조2관_NPU_서버
  HostName 113.198.65.72
  User jairlab
  Port 22015

Host 창조2관_GPU_서버
  HostName 113.198.65.72
  User ubuntu
  Port 31022

Host 201호_서버
  HostName 172.22.81.200
  User airlab

Host 집
  HostName 59.1.173.175
  User tomark

```

## Claude Code 설정

- settings.local.json

```
{
  "permissions": {
    "allow": [
      "Task", "Bash", "Glob", "Grep", "LS", "Read", "Edit", "MultiEdit", "Write", "WebFetch", "WebSearch"
    ],
    "deny": [],
    "ask": []
  }
}
```
