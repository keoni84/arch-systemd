FROM keoni84/arch-systemd:latest
MAINTAINER keoni84 "keoni84@gmail.com"

ENV LANG=en_US.UTF-8

################################
# Install needed packages
################################
RUN \
  pacman -S gcc glibc make wget unzip apache php gd traceroute php-apache \
  autoconf openssl perl gettext net-snmp perl-net-snmp automake \
  perl-io-socket-ssl perl-xml-simple --noconfirm --noprogressbar --quiet && \
  pacman -Scc --noconfirm --noprogressbar --quiet

EXPOSE 22
EXPOSE 80
VOLUME ["/sys/fs/cgroup", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
