# MysqlScript-ultima2021
the mysql script used in the our project

## Como crear un servidor MySql en vmware

Configuren la red del servidor y ssh primero con cualquier ip que quieran
y asegurensen que se pueden conectar con ssh (putty):

```
vi /etc/sysconfig/network-scripts/ifcfg-NOMBRE DE TARJETA DE RED

BOOTPROTO=static
IPADDR=192.168.1.151  algun ip de su red libre, yo use ese
PREFIX=24             capaz que el tuyo es distinto
GATEWAY=192.168.1.1 	capaz que el tuyo es distinto 

systemctl restart network
systemctl start sshd
```

**ahora empieza la instalacion de mysql 5.7.30**  
tenemos que bajarnos wget para poder instalarnos cosas del internet sin un navegador
```
yum install wget
wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
vi /etc/yum.repos.d/mysql-community.repo
```
dentro de [mysql80-community]

```
enabled=0
```
dentro de [mysql57-community]
```
enabled=1
```
Guarda los cambios, seguimos:
```
yum install mysql-community-server-5.7.30
grep "temporary password" /var/log/mysqld.log
```
**ACORDATE DEL PASSWORD QUE APARECE**
```
vi /etc/my.cnf
```
**ABAJO DE [mysqld] AGREGAR:**
```
bind-address=IP DEL SERVIDOR
```
Guarda los cambios, seguimos:
```
systemctl start mysqld
systemctl enable mysqld
mysql_secure_installation
	****PONE EL TEMP PASSWORD DEL GREP 
	****PONE PASS NUEVO  SI QUERES
y
n
y
y
mysql -root -p
	****TU MYSQL PASSWORD
uninstall plugin validate_password;
```

ahora tienen que cear un usuario que se usaria para correr el programa, yo habia hecho 6 usuarios con privilegios especificos porque se pidio en base de datos hacer eso. Pero como no tenemos permiso para crear usuarios en el servidor de la utu voy a usar mi propio usuario:
```
CREATE USER "federico.costa"@"%" IDENTIFIED BY "49800853";
GRANT ALL PRIVILEGES ON *.* TO "federico.costa"@"%";
```

Fin. Ahora pueden usar el workbench con el servidor. primero deben crear una nueva conexion dandole click al simbolo + de la pagina de inicio en el WB
>**connection name:** algun nombre  
>**connection method:** seleccionen SSH  
>>**SSH hostname:** ip del servidor:22  
>>**SSH username:** root   les va pedir el password del usuario root del servidor, no de la base de datos  
>>**MYSQL hostname:** ip del servidor  
>>**username:** root  les va pedir el password del usuario root de mysql  

## Otras links:
[github main application](https://github.com/ULTIMA2021/ProyectoULTIMA)

[trello](https://trello.com/b/qcD4KHrV/primer-entrega-ultima)

[miro](https://miro.com/app/board/o9J_lAxZIOM=/)

[github config de servidores](https://github.com/ULTIMA2021/Sistemas-Operativos)
