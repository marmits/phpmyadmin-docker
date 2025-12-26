FROM alpine:3.20 AS tunnel_ssh

RUN apk add --no-cache openssh autossh bash 

# Évite les prompts SSH
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
