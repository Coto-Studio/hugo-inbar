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
        # Config (main1)
        - "traefik.http.services.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1.loadbalancer.server.port={{ op://${VAULT_ID}/$ITEM_ID/deploy/port }}"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}`) || Host(`www.{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-http.middlewares=https-redirect"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}`) || Host(`www.{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-https.tls.certresolver=le"
        # www Redirect (main1)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-https.middlewares={{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-www-redirect"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-www-redirect.redirectregex.regex=^https?://www.{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}/(.*)"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-www-redirect.redirectregex.replacement=https://{{ op://${VAULT_ID}/$ITEM_ID/domain/main1 }}/$${1}"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main1-www-redirect.redirectregex.permanent=true"
  
  main2:
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
        # Config (main2)
        - "traefik.http.services.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2.loadbalancer.server.port={{ op://${VAULT_ID}/$ITEM_ID/deploy/port }}"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}`) || Host(`www.{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-http.middlewares=https-redirect"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}`) || Host(`www.{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-https.tls.certresolver=le"
        # www Redirect (main2)
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-https.middlewares={{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-www-redirect"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-www-redirect.redirectregex.regex=^https?://www.{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}/(.*)"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-www-redirect.redirectregex.replacement=https://{{ op://${VAULT_ID}/$ITEM_ID/domain/main2 }}/$${1}"
        - "traefik.http.middlewares.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-main2-www-redirect.redirectregex.permanent=true"

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
        # Config
        - "traefik.http.services.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev.loadbalancer.server.port={{ op://${VAULT_ID}/$ITEM_ID/deploy/port }}"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-http.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev1 }}`) || Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev2 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-http.entrypoints=http"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-http.middlewares=https-redirect"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-https.rule=Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev1 }}`) || Host(`{{ op://${VAULT_ID}/$ITEM_ID/domain/dev2 }}`)"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-https.entrypoints=https"
        - "traefik.http.routers.{{ op://${VAULT_ID}/$ITEM_ID/deploy/stack }}-{{ op://${VAULT_ID}/$ITEM_ID/deploy/service }}-dev-https.tls.certresolver=le"
        

networks:
  traefik-public:
    external: true
