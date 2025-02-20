# Using the base image that contains the PHP environment
FROM devopsedu/webapp

# For copying the contents of the current directory to /var/www/html inside the container
COPY website/. /var/www/html/

# Remove default index.html
RUN rm /var/www/html/index.html

# Exposing port 80 to allow web traffic
EXPOSE 80

# Starting Apache in the foreground to keep the container running
CMD ["apache2ctl", "-D", "FOREGROUND"]
