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
  pacman -S sudo gcc make sed awk gzip grep vim tree iproute2 openssh --noconfirm --noprogressbar --quiet && \

  # Generate locale en_US UTF-8
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen && \

  # Clean up
  pacman -Rs gcc make --noconfirm --noprogressbar && \
  pacman -Scc --noconfirm --noprogressbar --quiet && \

  # Configure ssh & set root password
  echo 'root:root' |chpasswd && \
  sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \

  # systemd stuff
  systemctl mask tmp.mount systemd-tmpfiles-setup.service && \
  systemctl enable sshd && \
  if [ ! -e /sbin/init ]; then ln -s /lib/systemd/systemd /sbin/init; fi

EXPOSE 22
VOLUME ["/sys/fs/cgroup", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
