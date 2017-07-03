FROM keoni84/arch-systemd:latest
MAINTAINER keoni84 "keoni84@gmail.com"

ENV LANG=en_US.UTF-8

################################
# Install & Configure ssh
################################
RUN \
  # Install & config ssh
  pacman -S openssh --noconfirm --noprogressbar --quiet && \
  pacman -Scc --noconfirm --noprogressbar --quiet && \
  echo 'root:root' |chpasswd && \
  sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  systemctl enable sshd

EXPOSE 22
VOLUME ["/sys/fs/cgroup", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
