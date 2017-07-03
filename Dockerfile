FROM base/archlinux:latest
MAINTAINER keoni84 "keoni84@gmail.com"

ENV LANG=en_US.UTF-8

################################
# Install stuff
################################
RUN \
  # Update
  pacman -Sy && \
  pacman -S archlinux-keyring --noconfirm --noprogressbar --quiet && \
  pacman -S pacman --noconfirm --noprogressbar --quiet && \
  pacman-db-upgrade && \
  pacman -Su --noconfirm --noprogressbar --quiet && \

  # Install packages
  pacman -S sudo gcc make sed awk gzip grep vim tree iproute2 --noconfirm --noprogressbar --quiet && \

  # Generate locale en_US UTF-8
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen && \

  # Clean up
  pacman -Rs gcc make --noconfirm --noprogressbar && \
  pacman -Scc --noconfirm --noprogressbar --quiet && \

  # systemd & other stuff
  systemctl mask tmp.mount systemd-tmpfiles-setup.service \
  auditd.service display-manager.service plymouth-quit-wait.service \
  plymouth-start.service syslog.service && \
  /usr/bin/echo 'set mouse-=a' > ~/.vimrc && \
  ln -s /usr/bin/vim /usr/bin/vi && \
  echo "alias ll='ls -l'" >> /etc/bash.bashrc && \
  if [ ! -e /sbin/init ]; then ln -s /lib/systemd/systemd /sbin/init; fi

VOLUME ["/sys/fs/cgroup", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
