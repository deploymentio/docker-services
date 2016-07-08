##############################################################################
#                                                                            #
#  Copyright 2016 - Deployment IO                                            #
#                                                                            #
#  Licensed under the Apache License, Version 2.0 (the "License");           #
#  you may not use this file except in compliance with the License.          #
#  You may obtain a copy of the License at                                   #
#                                                                            #
#      http://www.apache.org/licenses/LICENSE-2.0                            #
#                                                                            #
#  Unless required by applicable law or agreed to in writing, software       #
#  distributed under the License is distributed on an "AS IS" BASIS,         #
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  #
#  See the License for the specific language governing permissions and       #
#  limitations under the License.                                            #
#                                                                            #
##############################################################################

FROM deploymentio/base
MAINTAINER Salman Malik <salman@the-tech-warriors.com>

# download and install zookeeper
RUN ZK_VERSION=zookeeper-3.4.8 && \
    ZK_FILE=${ZK_VERSION}.tar.gz && \
    curl -L -o /tmp/${ZK_FILE} "http://apache.osuosl.org/zookeeper/${ZK_VERSION}/${ZK_FILE}" && \
    tar xzf /tmp/${ZK_FILE} -C /opt; rm /tmp/${ZK_FILE} && \
    ln -s /opt/${ZK_VERSION} /opt/zookeeper && \
    cd /opt/zookeeper; rm -rf contrib dist-maven docs ivy* recipes src
    
# download, build, and install exhibitor
RUN MVN_VERSION=3.3.9 && \
    MVN_FILE=apache-maven-${MVN_VERSION}-bin.tar.gz && \
    curl -L -o /tmp/${MVN_FILE} "http://apache.osuosl.org/maven/maven-3/${MVN_VERSION}/binaries/${MVN_FILE}" && \
    tar xzf /tmp/${MVN_FILE} -C /tmp; rm /tmp/${MVN_FILE} && \
    cd /tmp/apache-maven-${MVN_VERSION}/bin && \
    curl -L -o pom.xml https://raw.github.com/Netflix/exhibitor/master/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml && \
    ./mvn --batch-mode clean package && \
    EXHIBITOR_JAR=$(ls target/exhibitor-*.jar | sed -e 's/target\/\(exhibitor-.*\.jar\)$/\1/') && \
    cp target/${EXHIBITOR_JAR} /opt/zookeeper/ && \
    ln -s /opt/zookeeper/${EXHIBITOR_JAR} /opt/zookeeper/exhibitor.jar && \
    rm -rf ~/.m2 /tmp/apache-maven-${MVN_VERSION}

# add config and run scripts 
ADD exhibitor.conf /opt/zookeeper/conf/
ADD exhibitor.sh /opt/zookeeper/bin/
ADD zookeeper-env.sh /opt/zookeeper/conf/

# setup zookeeper, exhibitor configs, and fix perms
RUN mkdir -p /var/log/exhibitor && \
    mkdir -p /var/log/zookeeper && \
    mkdir -p /var/data/exhibitor/index && \
    mkdir -p /var/data/zookeeper/data && \
    mkdir -p /var/data/zookeeper/log && \
    chown -R root:root /opt/zookeeper && \
    chmod 755 /opt/zookeeper/bin/zookeeper-env.sh && \
    chmod 755 /opt/zookeeper/bin/exhibitor.sh

# expose the following ports
EXPOSE 8080 2181 2888 3888

# environment variables
ENV DIO_ENVIRONMENT= \
	DIO_BASE_DOMAIN= \
	EXHIBITOR_S3_BUCKET= \
	EXHIBITOR_HOST_OR_IP= \
	EXHIBITOR_HEADING="Deployment IO" \
	AWS_DEFUALT_REGION=us-east-1

# run this command
ENTRYPOINT ["/opt/zookeeper/bin/exhibitor.sh"]
