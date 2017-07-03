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

  # systemd stuff
  systemctl mask tmp.mount systemd-tmpfiles-setup.service && \
  if [ ! -e /sbin/init ]; then ln -s /lib/systemd/systemd /sbin/init; fi

RUN \
  # Installing Other stuff
  # GEM_HOME="/tmp/verifier/gems" \
  # GEM_PATH="/tmp/verifier/gems" \
  # GEM_CACHE="/tmp/verifier/gems/cache" \
  # gem install busser --no-rdoc --no-ri \
    #--no-format-executable -n /tmp/verifier/bin --no-user-install && \

  # Busser plugins
  # GEM_HOME="/tmp/verifier/gems" \
  # GEM_PATH="/tmp/verifier/gems" \
  # GEM_CACHE="/tmp/verifier/gems/cache" \
  # gem install busser-serverspec serverspec --no-rdoc --no-ri --no-user-install

VOLUME ["/sys/fs/cgroup", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
