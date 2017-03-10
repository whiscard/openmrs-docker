# What is OpenMRS/OpenHMIS

OpenMRS is an open source medical records system that is deployed around the world. You can find more information at [OpenMRS.org](https://openmrs.org). OpenHMIS adds hospital management features on top of OpenMRS; information about it can be found at [www.OpenHMISAfrica.org](http://www.OpenHMISAfrica.org). Documentation for configuring OpenHMIS can be found on the [OpenMRS Wiki](https://wiki.openmrs.org/display/docs/OpenHMIS+Modules).

# OpenHMIS Docker Images

These docker images will install the OpenMRS platform, OpenMRS reference application, and the latest OpenHMIS modules. The images will also optionally create a demo database with a limited amount of patients, observations, and the minimal configuration data needed for the OpenHMIS modules to be used.

The images are tagged by OpenMRS platform and reference application versions:

    OpenMRS Platform 1.11.5 with Reference App 2.3.1 (tag: plat1.11.5_ref2.3.1)
    OpenMRS Platform 1.11.5 without the reference app (tag: plat1.11.5)
    OpenMRS Platform 1.9.9 without the reference app (tag: plat1.9.9)

To get the latest release, the following tags can be used:

    OpenMRS Platform 1.11.x with Reference App 2.x (tag: plat1.11.x_ref2.x)
    OpenMRS Platform 1.11.x without the reference app (tag: plat1.11.x)
    OpenMRS Platform 1.9.x without the reference app (tag: plat1.9.x)

The `latest` tag will always be the current plat1.11.x_ref2.x image.

# How to Use the OpenHMIS Images

## Setting up MySQL

This image assumes that MySQL will be running in separate server or another image. To set up a MySQL instance via docker, first create a docker data value for the MySQL data files:

    docker create --name mysql-data arungupta/mysql-data-container

Next, start an instance of the MySQL docker image that will use that data volume:

    docker run --name openmrs-mysql --volumes-from mysql-data -v /var/lib/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=test -d -p=3306:3306 mysql/mysql-server:5.6

###### Note that there are different security options for the MySQL accounts. See [here](https://hub.docker.com/r/mysql/mysql-server/) for more information.


## Start the OpenMRS Instance

Once the MySQL image is downloaded and running you can now start the OpenHMIS image:

    docker run --name openhmis-test --link openmrs-mysql:mysql -it -p 9999:8080 -e DEMO_DATA=1 -e DB_USER='root' -e DB_PASS='test' openhmis/openmrs-docker:latest

This command will start a new container called 'openhmis-test' and link it to the running MySQL instance (note that the name matches the MySQL docker image we created). We are mapping the instance port 8080 to the local port 9999 so that we can easily browse the site on development machines that already have port 8080 in use. The command also sets a few variables to configure the installation process, see below for the list of available variables. Lastly, the command is loading the image defined at [openhmis/openmrs-docker](https://hub.docker.com/r/openhmis/openmrs-docker/) under the latest tag.

###### Note that images including the reference application can take up to 10 minutes to load.

## Connect to OpenMRS

Once the OpenMRS image has finished loading (look for a line like: `INFO: Server startup in 232561 ms`) the server can be accessed in one of two ways:

1. Via `localhost` on mapped port. Note that some host OS's will require port mapping in the VM for this to work correctly via localhost.
2. Via the image's ip address on the mapped port. The image ip address can be found via `docker-machine ip default` (though this might be specific to OS X).

## Environment Variables

### DEMO_DATA

Tells the script to load the demo data. This parameter simply needs to be set to something, the value does not matter.

### DB_USER (Required if loading demo data)

The MySQL user account that will be used to prepare the database. This account must have access to create databases and users. Note that this is not the account which will be used by OpenMRS.

### DB_PASS (Required if loading demo data)

The MySQL account password.

### OPENMRS_MYSQL_HOST

The MySQL host ip address. If not specified this will be the address defined in MYSQL_PORT_3306_TCP_ADDR which gets set via the linked MySQL image.

### OPENMRS_MYSQL_PORT

The MySQL host port. If not specified this will be the port defined in MYSQL_PORT_3306_TCP_ADDR which gets set via the linked MySQL image.

### DB_NAME

The name to use for the OpenMRS database. If not defined this will be set to the default database name for the image selected. If a database with the specified name already exists it will not be updated and the specified OpenMRS user will be given access to it.

### OPENMRS_DB_USER

The MySQL user account that will be used by OpenMRS to connect to the database. If not defined this will be set to the default defined in the dockerfile.

### OPENMRS_DB_PASS

The MySQL account password for the OpenMRS user account. If not defined this will be set to the default defined in the dockerfile.

### OPENMRS_DATABASE_SCRIPT

The full path and file name to the compressed (zipped) database population script. If not defined the demo data for the specified image will be used.

# User Feedback

If you have any issues with this installation or comments/improvements, feel free to contact the OpenHMIS team  on our [Chat](http://chat.openhmisafrica.org) or on [OpenMRS Talk](https://talk.openmrs.org).
