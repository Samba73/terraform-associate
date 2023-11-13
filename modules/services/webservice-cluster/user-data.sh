#! /bin/bash
echo "<p>${server_text}</p>" > index.html
sudo echo "<html><body><h1>Hello from Instance: Instance id `curl http://169.254.169.254/latest/meta-data/instance-id`</h1></body></html>" >> index.html
echo "<h1>DB Name:</h1> ${db_name}" >> index.html
echo "<h1>DB Address:</h1> ${address}" >> index.html
nohup busybox httpd -f -p ${port} &