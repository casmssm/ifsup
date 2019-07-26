FROM debian:latest
MAINTAINER  Carlos_Martins

# ajusta timezone correta - precisa do pacote tzdata para funcionar
ENV TZ=America/Sao_Paulo
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG pt_BR.utf8

# env para direrório da aplicação
ENV APP_DIR=/opt/ifsup

RUN apt update && \
apt install -y  apt-utils curl locales nano tzdata \
cron wget cups cups-tea4cups cups-ipp-utils \
cups-filters ghostscript hplip libcupsfilters1 firewalld mariadb-server rsync python-pil apache2 net-tools cups-pdf nmap && \
localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8 && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
#################################
# install netdata e graylog collector
mkdir /home/netdata && cd /home/netdata && \
wget https://my-netdata.io/kickstart.sh && chmod +x kickstart.sh && \
./kickstart.sh all --dont-wait && \
# script para subir os serviços de monitoramento
echo "#!/bin/bash \n\
/etc/init.d/cron start \n\
/etc/init.d/ssh start \n\
/etc/init.d/cups start \n\
/etc/init.d/mysql start \n\
/etc/init.d/firewalld start \n\
netdata \n\
" > /home/startup.sh && chmod +x /home/startup.sh

##Instalando dependencias da aplicacao
RUN cd /tmp && git clone https://github.com/casmssm/ifsup.git && rsync -av /tmp/ifsup/Server/ /opt/ifsup/
RUN echo 'ifsupadmin\nifsupadmin' | passwd root
RUN cd /opt/ifsup/dependencies/ && tar -zxf pkpgcounter-3.50.tar.gz && cd pkpgcounter-3.50 && python setup.py install
RUN /etc/init.d/mysql start && /etc/init.d/apache2 start && /etc/init.d/firewalld start && sleep 3 && /opt/ifsup/install_Debian.sh

#RUN sed -i 's@Subsystem.*@Subsystem\tsftp\tinternal-sftp@g' /etc/ssh/sshd_config

## Expondo as portas
EXPOSE 80
EXPOSE 631
EXPOSE 5000
EXPOSE 3306
CMD /home/startup.sh && /bin/bash
