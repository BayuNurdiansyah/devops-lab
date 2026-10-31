FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y --no-install-recommends openssh-server sudo python3 python3-apt nginx tzdata \
 && useradd -m -s /bin/bash deploy \
 && echo 'deploy ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/deploy \
 && mkdir -p /run/sshd /home/deploy/.ssh \
 && ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
 && echo Asia/Jakarta > /etc/timezone
COPY lab_key.pub /home/deploy/.ssh/authorized_keys
RUN chown -R deploy:deploy /home/deploy/.ssh \
 && chmod 700 /home/deploy/.ssh && chmod 600 /home/deploy/.ssh/authorized_keys
COPY server/entrypoint.sh /entrypoint.sh
COPY server/status.sh /usr/local/bin/baseline-status
RUN chmod +x /entrypoint.sh /usr/local/bin/baseline-status
CMD ["/entrypoint.sh"]
