#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the new document root path
NEW_DOC_ROOT="/var/www/html/portfolio-webpage/" # Suggested new location

# Apache configuration files
APACHE_CONF="/etc/apache2/apache2.conf"
SITE_CONF="/etc/apache2/sites-available/000-default.conf"

# Apache user and group, common default is 'www-data' for Ubuntu
APACHE_USER="www-data"
APACHE_GROUP="www-data"

# Ensure the new document root directory exists, create if not
echo "Ensuring target directory structure exists..."
sudo mkdir -p "$NEW_DOC_ROOT"

# Move the document root directory to the new location (if it exists)
if [ -d "/home/vagrant//portfolio-webpage/" ]; then
    echo "Moving document root to the new location..."
    sudo mv "/home/vagrant/portfolio-webpage/" "$(dirname "$NEW_DOC_ROOT")"
fi

# Set proper permissions for files and directories
echo "Setting permissions for $NEW_DOC_ROOT..."
sudo chown -R $APACHE_USER:$APACHE_GROUP $NEW_DOC_ROOT
sudo find $NEW_DOC_ROOT -type d -exec chmod 755 {} \;
sudo find $NEW_DOC_ROOT -type f -exec chmod 644 {} \;

# Update Apache configuration: DocumentRoot
echo "Updating Apache site configuration..."
sudo sed -i "s|DocumentRoot /.*|DocumentRoot $NEW_DOC_ROOT|" $SITE_CONF

# Explicitly set DirectoryIndex to coming-soon.html
echo "Setting DirectoryIndex to coming-soon.html..."
sudo sed -i "/DocumentRoot/c\DocumentRoot $NEW_DOC_ROOT\n\tDirectoryIndex coming-soon.html" $SITE_CONF

# Restart Apache to apply changes
echo "Restarting Apache to apply changes..."
sudo systemctl restart apache2

echo "Apache configuration updated. 'coming-soon.html' is now the default page in $NEW_DOC_ROOT."