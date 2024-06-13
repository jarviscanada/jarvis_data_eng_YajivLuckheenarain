#! /bin/sh




# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start docker
# || is the OR operator


#sudo systemctl status docker || systemctl start docker
sudo systemctl status docker > /dev/null 2>&1 || sudo systemctl start docker > /dev/null 2>&1

# Check container status (try the following cmds on terminal)
#docker container inspect jrvs-psql
docker container inspect jrvs-psql > /dev/null 2>&1
container_status=$?

# User switch case to handle create|stop|start options
case $cmd in 
  create)

    
    # Check if the container is already created
    if [ $container_status -eq 0 ]; then
      echo 'Container already exists'
      exit 1
    fi

    # Check # of CLI arguments
    if [ $# -ne 3 ]; then
      echo 'Create requires username and password'
      exit 1
    fi
    
    # Create volume and container
    docker volume create jrvs-psql-vol
    docker run --name jrvs-psql -e POSTGRES_USER=$db_username -e POSTGRES_PASSWORD=$db_password -d -v jrvs-psql-vol:/var/lib/postgresql/data -p 5432:5432 postgres
    
    # Check if the container started successfully
    if [ $? -ne 0 ]; then
      echo 'Failed to create and start the container'
      exit 1
    fi

    echo 'PostgreSQL container created and started'
    exit 0
    ;;

  start|stop)
    # Check if the container has been created
    if [ $container_status -ne 0 ]; then
      echo 'Container has not been created'
      exit 1
    fi

    # Start or stop the container
    docker container $cmd jrvs-psql
    if [ $? -ne 0 ]; then
      echo "Failed to $cmd the container"
      exit 1
    fi

    echo "PostgreSQL container $cmded"
    exit 0
    ;;

  *)
    echo 'Illegal command'
    echo 'Commands: start|stop|create'
    exit 1
    ;;
esac

