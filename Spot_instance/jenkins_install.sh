# #!/bin/bash
# sudo apt update -y
# wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
# echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
# sudo apt update -y
# #sudo apt install temurin-17-jdk -y
# sudo apt install openjdk-17-jre-headless -y
# /usr/bin/java --version
# curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
# echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt-get update -y
# sudo apt-get install jenkins -y
# sudo systemctl enable jenkins
# sudo systemctl start jenkins

# # From Officially Page
# # sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
# #   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# # echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
# #   https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
# #   /etc/apt/sources.list.d/jenkins.list > /dev/null
# # sudo apt-get update
# # sudo apt-get install jenkins


# ##Install Docker and Run SonarQube as Container
# sudo apt-get update
# sudo apt-get install docker.io -y
# # sudo usermod -aG docker ubuntu
# # sudo usermod -aG docker jenkins  
# # newgrp docker
# sudo chmod 777 /var/run/docker.sock

# # Add the current user to the docker group
# sudo chown $USER /var/run/docker.sock
# sudo usermod -aG docker $USER

# # Enable Docker to start on boot
# sudo systemctl enable docker

# # Start Docker service
# sudo systemctl start docker


# # docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# #install trivy
# sudo apt-get install wget apt-transport-https gnupg lsb-release -y
# wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
# echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
# sudo apt-get update
# sudo apt-get install trivy -y