#!/usr/bin/env bash
# Script that sets up your web servers for the deployment of web_static.

# Install Nginx if it not already installed
if ! command -v nginx > /dev/null 2>&1; then
	    sudo apt-get update
	        sudo apt-get install -y nginx
fi

# Create the necessary directories
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a fake HTML file to test Nginx configuration
echo "<html>
    <head>
    </head>
    <body>
    	Holberton School
    </body>
</html>" | sudo tee /data/web_static/releases/test/index.html

	    # Create a symbolic link, delete if it already exists
	    if [ -L /data/web_static/current ]; then
		        sudo rm /data/web_static/current
			fi
			sudo ln -s /data/web_static/releases/test/ /data/web_static/current

			# Give ownership of /data/ folder to the ubuntu user AND group recursively
			sudo chown -R ubuntu:ubuntu /data/

			# Update Nginx configuration to serve the content
			nginx_conf="/etc/nginx/sites-available/default"

			if ! grep -q "location /hbnb_static/" $nginx_conf; then
				    sudo sed -i '/server_name _;/a \\n\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}' $nginx_conf
			fi

			# Restart Nginx
			sudo service nginx restart

			# Exit successfully
			exit 0

