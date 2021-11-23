#!/bin/bash
echo "Este script pertenece al alumno Carlos Covarrubias, Matrícula 1423741, asignatura SSO"
sleep 5

CENTOS=$(cat /etc/centos-release)
echo "tu versión de CentOs es $CENTOS"
sleep 3
clear

echo "Comprobando el estado de clamav"
rpm -q clamav
if  yum -q list installed *clamav*; then
        echo "Se reemplazará esta versión de clamav"
        sleep 3
        sudo systemctl stop clamd@scan && sudo systemctl disable clamd@scan
        sudo systemctl status clamd@scan
        sudo freshclam
        sudo systemctl enable clamd@scan
        sudo systemctl start clamd@scan
        sudo systemctl status clamd@scan
        echo "Se reemplazó la versión con éxito"
else
        echo "Se instalará clamav"
        sleep 3
        sudo yum -y install epel-release
        sudo yum clean all
        sudo yum -y install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
        sudo freshclam
        sudo setsebool -P antivirus_can_scan_system 1
        sudo setsebool -P clamd_use_jit 0
        sudo systemctl enable clamd@scan
        sudo systemctl start clamd@scan
        sudo yum remove epel-release
        sudo yum update
        echo "La instalación fue exitosa"
fi
clear

if [[ $CENTOS = *7* ]]; then

    echo "Instalaremos EPEL en tu sistema CentOS 7"
    sleep 3
    sudo wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo rpm -ivh epel-release-latest-7.noarch.rpm
    echo "Verificaremos que aparezca en tu lista de repositorios"
    sudo yum -y repolist
fi


echo "########## Se verificarán las actualizaciones pendientes ##########"
sleep 3
sudo yum list updates

echo "########## Se realizarán las actualizaciones pertinentes ##########"
sleep 3
sudo yum -y update
echo "########## Se recomienda reiniciar el sistema ##########"

echo "########## El programa se cerrará ##########"
clear
