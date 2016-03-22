FROM tomcat:7-jre7

ENV OPENMRS_HOME /root/.OpenMRS
ENV OPENMRS_MODULES ${OPENMRS_HOME}/modules
ENV OPENMRS_PLATFORM_VERSION="1.9.9"
ENV OPENMRS_PLATFORM_URL="http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_1.9.9/openmrs.war/download"
ENV OPENMRS_REFERENCE_VERSION=""
ENV OPENMRS_REFERENCE_URL=""
ENV DATABASE_SCRIPT_FILE="openmrs-1.9.9.sql.zip"
ENV DATABASE_SCRIPT_PATH="db/${DATABASE_SCRIPT_FILE}"
ENV OPENHMIS_DATABASE_SCRIPT_FILE="openhmis_demo_data_1.x.sql.zip"
ENV OPENHMIS_DATABASE_SCRIPT_PATH="db/${OPENHMIS_DATABASE_SCRIPT_FILE}"
ENV OPENHMIS_LOCAL_DATABASE_SCRIPT_PATH="/root/temp/db/${OPENHMIS_DATABASE_SCRIPT_FILE}"

ENV DEFAULT_DB_NAME="openmrs_1_9_9"
ENV DEFAULT_OPENMRS_DB_USER="openmrs_user"
ENV DEFAULT_OPENMRS_DB_PASS="Openmrs123"
ENV DEFAULT_OPENMRS_DATABASE_SCRIPT="${DATABASE_SCRIPT_FILE}"
ENV DEFAULT_OPENMRS_DATABASE_SCRIPT_PATH="/root/temp/db/${DEFAULT_OPENMRS_DATABASE_SCRIPT}"

# Refresh repositories and add mysql-client and libxml2-utils (for xmllint)
# Download and Deploy OpenMRS
# Download and copy reference application modules (if defined)
# Unzip modules and copy to module/ref folder
# Create database and setup openmrs db user
RUN apt-get update && apt-get install -y mysql-client libxml2-utils \
    && curl -L ${OPENMRS_PLATFORM_URL} -o ${CATALINA_HOME}/webapps/openmrs.war \
    && mkdir -p ${OPENMRS_MODULES}

# Copy OpenHMIS dependencies
COPY modules/dependencies/1.x/*.omod ${OPENMRS_MODULES}/

# Copy OpenMRS properties file
COPY openmrs-runtime.properties /root/temp/

# Copy default database script
COPY ${DATABASE_SCRIPT_PATH} /root/temp/db/

# Copy OpenHMIS database script
COPY ${OPENHMIS_DATABASE_SCRIPT_PATH} /root/temp/db/

EXPOSE 8080

# Setup openmrs, optionally load demo data, and start tomcat
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]
