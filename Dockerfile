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
make install && \
make install-commandmode && \
make install-config && \
make install-webconf && \
cp /tmp/nagios/nagios.service /usr/lib/systemd/system/nagios.service && \
chown root:root /usr/lib/systemd/system/nagios.service && \
chmod 644 /usr/lib/systemd/system/nagios.service && \
systemctl enable nagios.service && \
systemctl enable httpd.service && \
sed -i 's/^LoadModule mpm_event_module modules\/mod_mpm_event\.so/#LoadModule mpm_event_module modules\/mod_mpm_event\.so/g' /etc/httpd/conf/httpd.conf && \
sed -i 's/^#LoadModule mpm_prefork_module modules\/mod_mpm_prefork\.so/LoadModule mpm_prefork_module modules\/mod_mpm_prefork\.so/g' /etc/httpd/conf/httpd.conf && \
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html index.htm AddType application\/x-httpd-php .phpAddType application\/x-httpd-php-source .phps/g' /etc/httpd/conf/httpd.conf && \
sed -i 's/#LoadModule cgid_module/LoadModule cgid_module/g' /etc/httpd/conf/httpd.conf && \
sed -i 's/#LoadModule cgi_module/LoadModule cgi_module/g' /etc/httpd/conf/httpd.conf && \
echo 'LoadModule php7_module modules/libphp7.so' >> /etc/httpd/conf/httpd.conf && \
echo 'Include "conf/extra/nagios.conf"' >> /etc/httpd/conf/httpd.conf && \
echo 'Include "conf/extra/php7_module.conf"' >> /etc/httpd/conf/httpd.conf && \
printf '\n<FilesMatch ".php$">\n' >> /etc/httpd/conf/httpd.conf && \
printf '\tSetHandler application/x-httpd-php\n' >> /etc/httpd/conf/httpd.conf && \
printf '</FilesMatch>\n' >> /etc/httpd/conf/httpd.conf && \
printf '<FilesMatch ".phps$">\n' >> /etc/httpd/conf/httpd.conf && \
printf '\tSetHandler application/x-httpd-php-source\n' >> /etc/httpd/conf/httpd.conf && \
printf '</FilesMatch>\n' >> /etc/httpd/conf/httpd.conf && \
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin 1d0ntkn0w && \
cpan App::cpanminus && \
cpanm Module::Install && \
cpan Monitoring::Plugin && \
cd /tmp/nagios/nagios-plugins-2.2.1 && \
./configure && \
make && make install && \
ln -s /usr/local/nagios /nagios && \
cd / && \
rm -rf /tmp/nagios*

EXPOSE 22
EXPOSE 80
VOLUME ["/sys/fs/cgroup", "/run"]
CMD  ["/usr/lib/systemd/systemd"]
