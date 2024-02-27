FROM google/cloud-sdk

RUN apt-get update && apt-get install -y python3-pip python3

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

CMD chmod 755 ./workstations.sh
CMD chmod 755 ./update_config.sh

# Install production dependencies.
RUN pip3 install Flask gunicorn

# Run the web service on container startup
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app:app
