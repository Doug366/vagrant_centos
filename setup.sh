#!/bin/bash
 
echo "****** Provisioning virtual machine... ******"
echo "****** Updating yum ******"
cd /vagrant
sudo yum update
echo "****** Installing Curl ******"
sudo yum install curl -y
echo "****** Installing RVM ******"
su - vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable'
echo "****** Installing Ruby $1 ******"
su - vagrant -c "rvm install $1" - this works but must compile ruby
#su - vagrant -c "rvm mount -r $1" # use this if there is a binary available to avoid need to compile ruby - this fails
#su - vagrant -c "rvm mount -r $1 --verify-downloads 2" # use this if there is a binary available to avoid need to compile ruby - this fails too
source /home/vagrant/.rvm/scripts/rvm
su - vagrant -c "rvm --default use $2"
su - vagrant -c "rvm gemset list"
su - vagrant -c "rvm gemset create $3"
su - vagrant -c "rvm use $2@$3 --default"
su - vagrant -c "rvm gemset list"
echo "****** Installing Git ******"
sudo yum install git -y
echo "****** Installing $4 ******"
if [ "$4" == "MySQL" ]; then
	sudo yum install mysql-server -y
	sudo /etc/init.d/mysqld restart
else
	cd /etc
	sudo curl -O http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
	sudo rpm -ivh pgdg*
	sudo yum install postgresql94-server -y
	sudo service postgresql-9.4 initdb
	sudo chkconfig postgresql-9.4 on
	sudo service postgresql-9.4 start
fi	
echo "****** Adding Passenger & Nginx Repo ******"
	sudo yum install epel-release pygpgme curl -y
	sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
	sudo chown root: /etc/yum.repos.d/passenger.repo
	sudo chmod 600 /etc/yum.repos.d/passenger.repo
	sudo yum update
echo "****** Installing Passenger & Nginx ******"
	sudo yum install nginx passenger -y
echo "****** Installing Rails ******"
	su - vagrant -c "gem install rails --version=$5 --no-rdoc --no-ri"
if [ "$6" == "true" ]; then
	echo "****** Installing ImageMagick ******"
	sudo yum install ImageMagick -y
else
	echo "****** ImageMagick Not Required ******"
fi
echo "****** Install Nano ******"
	sudo yum install nano -y
echo "****** Completed provisioning virtual machine! ******"
echo "****** Be sure to uncomment the passenger_root, passenger_ruby & passenger_instance_registry_dir lines in /etc/nginx/conf.d/passenger.conf file!!!  ******"
echo "****** Then do a 'sudo service nginx restart' ******"