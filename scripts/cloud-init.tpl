#cloud-config
write_files:
  - path: /var/tmp/compose.yaml
    permissions: '0640'
    content: |
      name: terraform-enterprise
      services:
        tfe:
          image: images.releases.hashicorp.com/hashicorp/terraform-enterprise:${tfe_release}
          environment:
            TFE_LICENSE: "${tfe_license}"
            TFE_HOSTNAME: "${route53_subdomain}.${route53_zone}"
            TFE_OPERATIONAL_MODE: "disk"    
            TFE_ENCRYPTION_PASSWORD: "${tfe_password}"
            TFE_DISK_CACHE_VOLUME_NAME: $${COMPOSE_PROJECT_NAME}_terraform-enterprise-cache
            TFE_TLS_CERT_FILE: /etc/ssl/private/terraform-enterprise/cert.pem
            TFE_TLS_KEY_FILE: /etc/ssl/private/terraform-enterprise/key.pem
            TFE_TLS_CA_BUNDLE_FILE: /etc/ssl/private/terraform-enterprise/bundle.pem
            TFE_IACT_SUBNETS: "0.0.0.0/0"  
          cap_add:
            - IPC_LOCK
          read_only: true
          tmpfs:
            - /tmp
            - /run
            - /var/log/terraform-enterprise
          ports:
            - "80:80"
            - "443:443"
          volumes:
            - type: bind
              source: /var/run/docker.sock
              target: /var/run/docker.sock
            - type: bind
              source: ./certs
              target: /etc/ssl/private/terraform-enterprise
            - type: bind
              source: ./data
              target: /var/lib/terraform-enterprise 
            - type: volume
              source: terraform-enterprise-cache
              target: /var/cache/tfe-task-worker/terraform
      
      volumes:
        terraform-enterprise-cache:

  - path: /var/tmp/install_docker.sh 
    permissions: '0750'
    content: |
      #!/usr/bin/env bash
      curl -fsSL https://get.docker.com -o get-docker.sh
      sudo sh get-docker.sh --version 24.0

  - path: /var/tmp/certificates.sh 
    permissions: '0750'
    content: |
      #!/usr/bin/env bash

      # Create folders for FDO installation and TLS certificates

      mkdir -p /fdo/certs
      mkdir -p /fdo/data

      echo ${full_chain} | base64 --decode > /fdo/certs/cert.pem
      echo ${private_key_pem} | base64 --decode > /fdo/certs/key.pem
  
  - path: /var/tmp/install_tfe.sh   
    permissions: '0750'
    content: |
      #!/usr/bin/env bash    
      
      # Copy Docker compose file to install path
      cp /var/tmp/compose.yaml /fdo
      cp /fdo/certs/cert.pem /fdo/certs/bundle.pem
      
      # Switch to install path
      pushd /fdo

      # Authenticate to container image registry
      echo "${tfe_license}" | docker login --username terraform images.releases.hashicorp.com --password-stdin
      
      # Pull the image and spin up the TFE FDO container
      docker compose up --detach    

runcmd:
  - sudo bash /var/tmp/install_docker.sh 
  - sudo bash /var/tmp/certificates.sh
  - sudo bash /var/tmp/install_tfe.sh