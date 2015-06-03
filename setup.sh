#!/bin/bash
 
echo "****** Provisioning virtual machine... ******"
echo "****** Updating apt-get ******"
cd /vagrant
sudo apt-get update
echo "****** Installing Curl ******"
sudo apt-get install curl -y
echo "****** Installing RVM ******"
su - vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable'
echo "****** Installing Ruby $1 ******"
#su - vagrant -c "rvm install $1" - this works but must compile ruby
su - vagrant -c "rvm mount -r $1" #use this if there is a binary available to avoid need to compile ruby
source /home/vagrant/.rvm/scripts/rvm
su - vagrant -c "rvm --default use $2"
su - vagrant -c "rvm gemset list"
su - vagrant -c "rvm gemset create $3"
su - vagrant -c "rvm use $2@$3 --default"
su - vagrant -c "rvm gemset list"
echo "****** Installing Git ******"
sudo apt-get install git -y
echo "****** Installing $4 ******"
if [ "$4" == "MySQL" ]; then
	echo "Updating PHP repository"
	sudo apt-get install python-software-properties build-essential -y
	sudo add-apt-repository ppa:ondrej/php5 -y 
	sudo apt-get update 
	
	echo "Installing PHP"
	sudo apt-get install php5-common php5-dev php5-cli php5-fpm -y 
 
	echo "Installing PHP extensions"
	sudo apt-get install curl php5-curl php5-gd php5-mcrypt php5-mysql -y 
	
	echo "Preparing MySQL"
	sudo apt-get install debconf-utils -y
	sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password vagrant"
 
	sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password vagrant"
	
	echo "Installing MySQL server"
	sudo apt-get install mysql-server -y 
else
	cd /etc
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'	
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install postgresql-9.3 pgadmin3 -y
fi	
echo "****** Adding Passenger & Nginx Repo ******"
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
	sudo apt-get install apt-transport-https ca-certificates -y
	echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main" | sudo tee /etc/apt/sources.list.d/passenger.list
	sudo chown root: /etc/apt/sources.list.d/passenger.list
	sudo chmod 600 /etc/apt/sources.list.d/passenger.list
	sudo apt-get update
echo "****** Installing Passenger & Nginx ******"
	sudo apt-get install nginx-extras passenger -y
echo "****** Installing Rails ******"
	su - vagrant -c "gem install rails --version=$5 --no-rdoc --no-ri"
if [ "$6" == "true" ]; then
	echo "****** Installing ImageMagick ******"
	sudo apt-get install imagemagick -y
else
	echo "****** ImageMagick Not Required ******"
fi
echo "****** Completed provisioning virtual machine! ******"
echo "****** Be sure to uncomment the passenger_root & passenger_ruby lines in /etc/nginx/nginx.conf file!!!  ******"
echo "****** Then do a 'sudo service nginx restart' ******"