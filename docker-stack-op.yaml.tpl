---
services:
  main1:
    image: {{ op://${VAULT_ID}/$ITEM_ID/deploy/image }}:main
    networks:
      - traefik-public
    deploy:
      replicas: 1
      labels:
        # Enable Traefik
        - "traefik.enable=true"
        - "traefik.docker.network=traefik-public"
        - "traefik.constraint-label=traefik-public"
        ## Service
        - "traefik.http.services{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}.loadbalancer.server.port=80"
        ## Middleware (www-redirect)
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect.redirectregex.regex=^https?://(?:www\\.)?(.+)"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect.redirectregex.replacement=https://$${1}"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect.redirectregex.permanent=true"
        ## Route HTTP (domain1)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}`) || Host(`www.{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-http.middlewares=https-redirect"
        ## Route HTTPS (domain1)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}`) || Host(`www.{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-https.tls.certresolver=le"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-https.middlewares={{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-https.service={{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}"
        ## Route HTTP (domain2)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}`) || Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-http.middlewares=https-redirect"
        ## Route HTTPS (domain2)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}`) || Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-https.tls.certresolver=le"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-https.middlewares={{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-www-redirect"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-https.service={{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}"

  dev:
    image: {{ op://${VAULT_ID}/$ITEM_ID/deploy/image }}:dev
    networks:
      - traefik-public
    deploy:
      labels:
        # Enable Traefik
        - "traefik.enable=true"
        - "traefik.docker.network=traefik-public"
        - "traefik.constraint-label=traefik-public"
        # Service
        - "traefik.http.services.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev.loadbalancer.server.port=80"
        ## Route HTTP (domain1)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-dev-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev1 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-dev-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-dev-http.middlewares=https-redirect"
        ## Route HTTPS (domain1)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-dev-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev1 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-dev-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-dev-https.tls.certresolver=le"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain1-dev-https.service={{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev"
        ## Route HTTP (domain2)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-dev-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev2 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-dev-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-dev-http.middlewares=https-redirect"
        ## Route HTTPS (domain2)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-dev-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev2 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-dev-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-dev-https.tls.certresolver=le"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-domain2-dev-https.service=cabin-23-inbar-dev"

networks:
  traefik-public:
    external: true
