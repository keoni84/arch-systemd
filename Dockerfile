FROM keoni84/arch-systemd:ssh
MAINTAINER keoni84 "keoni84@gmail.com"

ENV LANG=en_US.UTF-8

COPY nagios.tgz /tmp/nagios.tgz

################################
# Install needed packages
################################
RUN \
  pacman -S gcc glibc make wget unzip apache php gd traceroute php-apache \
  autoconf openssl perl gettext net-snmp perl-net-snmp automake \
  perl-io-socket-ssl perl-xml-simple --noconfirm --noprogressbar --quiet && \
  pacman -Scc --noconfirm --noprogressbar --quiet && \
  tar zxf /tmp/nagios.tgz -C /tmp && \
  tar zxf /tmp/nagios/nagios-4.3.2.tar.gz -C /tmp/nagios && \
  tar zxf /tmp/nagios/nagios-plugins-2.2.1.tar.gz -C /tmp/nagios && \
  cd /tmp/nagios/nagios-4.3.2 && \
  ./configure --with-httpd-conf=/etc/httpd/conf/extra && \
  make && \
  make all && \
  useradd -s /bin/bash -m nagios && \
  usermod -a -G nagios http && \
  make install

EXPOSE 22
EXPOSE 80
VOLUME ["/sys/fs/cgroup", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
