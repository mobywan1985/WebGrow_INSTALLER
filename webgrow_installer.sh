sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install php7.0-fpm php7.0-mysql php7.0-curl nginx mysql-server joe python-pip composer motion libjpeg-dev gettext libmicrohttpd-dev libavformat-dev libavcodec-dev libavutil-dev libswscale-dev libavdevice-dev libwebp-dev mysql-common libmariadbclient18 libpq5
sudo dpkg -i pi_stretch_motion_4.2.1-1_armhf.deb
sudo cp default /etc/nginx/sites-available/
sudo cp php.ini /etc/php/7.0/fpm/
sudo cp www.conf /etc/php/7.0/fpm/pool.d/
sudo cp motion.conf /etc/motion/
sudo cp motion /etc/default/
sudo cp webgrow.sh /etc/init.d/

cd /home/pi/
su - pi -c 'composer require "twig/twig:^2.0"'

sudo pip install sqlalchemy
sudo pip install apscheduler
sudo pip install pymysql
sudo pip install Adafruit-DHT
sudo pip install requests

sudo mysql -Bse "GRANT ALL PRIVILEGES ON *.* TO 'web'@'localhost' IDENTIFIED BY 'webgrow1985';
CREATE DATABASE webgrow;
USE webgrow;

CREATE table devices(id INT AUTO_INCREMENT NOT NULL,  d_gpio INT, d_trigger INT, d_tchange BOOLEAN, d_hchange BOOLEAN, d_temp INT,d_humid INT, d_interval INT, d_duration INT, d_timer INT,d_name VARCHAR(32), d_run BOOLEAN, d_state BOOLEAN, d_lastrun DATETIME, d_type INT, d_ip VARCHAR(16), d_protocol INT, PRIMARY KEY (id));

CREATE TABLE sensor_log(id INT AUTO_INCREMENT NOT NULL, temperature INT, humidity INT, log_date DATETIME, PRIMARY KEY (id));
CREATE table log(id INT NOT NULL AUTO_INCREMENT, runtime DATETIME, runstate INT, d_id INT, d_gpio INT, d_protocol INT, d_ip VARCHAR(16),PRIMARY KEY(id));
CREATE table schedule(id INT NOT NULL AUTO_INCREMENT, runtime DATETIME, d_state INT, d_id INT, d_dayofwk VARCHAR(30),PRIMARY KEY(id));
CREATE table settings(id INT NOT NULL AUTO_INCREMENT, e_webcam BOOLEAN, e_sensor BOOLEAN, s_samp INT, s_gpio INT, s_alert INT, s_alert_email VARCHAR(100), s_send_email VARCHAR(100), s_send_pw VARCHAR(100), PRIMARY KEY(id));
INSERT INTO settings(e_webcam, e_sensor, s_samp, s_gpio, s_alert_email, s_send_email, s_send_pw) VALUES (false, false, 120, 4, '', '' , '');

CREATE table user(id INT NOT NULL AUTO_INCREMENT, fname VARCHAR(32), lname VARCHAR(32), username VARCHAR(32), password VARCHAR(200), PRIMARY KEY(id));
INSERT INTO user(fname, lname,username, password) VALUES ('Admin','','admin', '\$2y\$10\$GQLb5ODRlEOMhXm0BLdv..UDtdFMKlmw0PpiUiw7VmFwGNu2uTOnq');

CREATE table gpio(id INT AUTO_INCREMENT NOT NULL, gpio INT, PRIMARY KEY (id));
INSERT INTO gpio(gpio) VALUES(0);
INSERT INTO gpio(gpio) VALUES(1);
INSERT INTO gpio(gpio) VALUES(2);
INSERT INTO gpio(gpio) VALUES(3);
INSERT INTO gpio(gpio) VALUES(4);
INSERT INTO gpio(gpio) VALUES(5);
INSERT INTO gpio(gpio) VALUES(6);
INSERT INTO gpio(gpio) VALUES(7);
INSERT INTO gpio(gpio) VALUES(8);
INSERT INTO gpio(gpio) VALUES(9);
INSERT INTO gpio(gpio) VALUES(10);
INSERT INTO gpio(gpio) VALUES(11);
INSERT INTO gpio(gpio) VALUES(12);
INSERT INTO gpio(gpio) VALUES(13);
INSERT INTO gpio(gpio) VALUES(14);
INSERT INTO gpio(gpio) VALUES(15);
INSERT INTO gpio(gpio) VALUES(16);
INSERT INTO gpio(gpio) VALUES(17);
INSERT INTO gpio(gpio) VALUES(18);
INSERT INTO gpio(gpio) VALUES(19);
INSERT INTO gpio(gpio) VALUES(20);
INSERT INTO gpio(gpio) VALUES(21);
INSERT INTO gpio(gpio) VALUES(22);
INSERT INTO gpio(gpio) VALUES(23);
INSERT INTO gpio(gpio) VALUES(24);
INSERT INTO gpio(gpio) VALUES(25);
INSERT INTO gpio(gpio) VALUES(26);
INSERT INTO gpio(gpio) VALUES(27);
INSERT INTO gpio(gpio) VALUES(28);

CREATE table device_protocol(id INT AUTO_INCREMENT NOT NULL, d_genericname VARCHAR(32), d_protocol INT, d_icon VARCHAR(32), PRIMARY KEY (id));
INSERT INTO device_protocol(d_genericname, d_protocol, d_icon) VALUES ('GPIO', 0, 'fas fa-plug');
INSERT INTO device_protocol(d_genericname, d_protocol, d_icon) VALUES ('Tasmota', 20, 'fas fa-plug');

CREATE table device_types(id INT AUTO_INCREMENT NOT NULL, d_genericname VARCHAR(32), d_type INT, d_icon VARCHAR(32), PRIMARY KEY (id));
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Lighting', 0, 'fas fa-lightbulb');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Fan', 10, 'fas fa-wind');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Air Conditioning', 20, 'fas fa-temperature-low');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Heater', 30, 'fas fa-fire-alt');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Humidifier', 40, 'fas fa-smog');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Dehumidifier', 50, 'fas fa-water');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Water Pump', 60, 'fas fa-tint');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Water Chiller', 70, 'fas fa-icicles');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Water Heater', 80, 'fas fa-thermometer-full');
INSERT INTO device_types(d_genericname, d_type, d_icon) VALUES ('Generic Plug', 90, 'fas fa-plug');

CREATE table journal(id INT NOT NULL AUTO_INCREMENT, name VARCHAR(60), start_date DATETIME, end_date DATETIME, note VARCHAR(255), archived BOOLEAN,PRIMARY KEY(id));
CREATE table journal_event(id INT NOT NULL AUTO_INCREMENT, journal_id INT,event_date DATETIME, event_type INT, event_note VARCHAR(255), event_user VARCHAR(32), event_image VARCHAR(255),PRIMARY KEY(id));

CREATE table event_type(id INT NOT NULL AUTO_INCREMENT, type_id INT, full_name VARCHAR(32) ,name VARCHAR(32), icon VARCHAR(32),element VARCHAR(32), PRIMARY KEY(id));
INSERT INTO event_type(type_id, full_name,name, icon, element) VALUES('0','Plain Water','Plain','fas fa-tint', 'event_plain');
INSERT INTO event_type(type_id, full_name,name, icon, element) VALUES('5','Nutrient Water','Nutrients', 'fas fa-tint', 'event_nutes');
INSERT INTO event_type(type_id, full_name,name, icon, element) VALUES('10','Defoliation','Defoliate','fas fa-leaf', 'event_defol');
INSERT INTO event_type(type_id, full_name,name, icon, element) VALUES('20','Log Notes','Note','fas fa-sticky-note', 'event_note');

CREATE table menu(id INT NOT NULL AUTO_INCREMENT,m_name VARCHAR(32), m_header VARCHAR(32),m_url VARCHAR(32), m_icon VARCHAR(32),m_order INT, m_enabled BOOLEAN,  PRIMARY KEY(id));
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('Home', 'Overview','home','fas fa-home',10,1);
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('Devices', 'Devices','devices','far fa-lightbulb',20,1);
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('History', 'History', 'log','fab fa-buffer',25,1);
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('Log Book', 'Log Book','journal','fas fa-book',22,1);
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('Camera', 'Webcam','webcam','fas fa-camera',30,0);
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('Settings', 'Settings','settings','fas fa-tools',40,1);
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('Schedule', 'Scheduling','schedule','fas fa-calendar-check',42,0);
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('Users', 'Users','users','fas fa-users',45,1);
INSERT INTO menu(m_name, m_header,m_url, m_icon,m_order, m_enabled) VALUES ('Logout','Logout', 'logout','fas fa-bolt',50,1);

CREATE table triggers(id INT NOT NULL AUTO_INCREMENT,t_id INT, t_name VARCHAR(32), t_element VARCHAR(32), t_enabled BOOLEAN, PRIMARY KEY(id));
INSERT INTO triggers(t_id, t_name, t_element, t_enabled) VALUES (0, 'None', 'collapseNone',1);
INSERT INTO triggers(t_id, t_name, t_element, t_enabled) VALUES (10, 'Interval','collapseInterval',1);
INSERT INTO triggers(t_id, t_name, t_element, t_enabled) VALUES (15, 'Timer','collapseInterval',1);
INSERT INTO triggers(t_id, t_name, t_element, t_enabled) VALUES (20, 'Temperature','collapseTemp',0);
INSERT INTO triggers(t_id, t_name, t_element, t_enabled) VALUES (25, 'Humidity','collapseHumid',0);
INSERT INTO triggers(t_id, t_name, t_element, t_enabled) VALUES (30, 'Schedule','collapseSched',1);
"


cd /etc/init.d/
sudo update-rc.d webgrow.sh defaults

sudo mkdir /usr/local/bin/webgrow
cd /usr/local/bin/webgrow/
#git cmd to download
git clone https://github.com/mobywan1985/WebGrow_PYTHON.git
cd WebGrow_PYTHON
sudo mv * ../
cd ../
sudo rm -rf WebGrow_PYTHON

cd /var/www/html/
#git cmd to download
git clone https://github.com/mobywan1985/WebGrow_PHP.git
cd WebGrow_PHP
sudo mv * ../
cd ../
sudo rm -rf WebGrow_PHP

echo "Please Reboot Your System!"
