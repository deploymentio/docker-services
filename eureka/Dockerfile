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

# add the src amd pom.xml
ADD src /tmp/src/
ADD pom.xml /tmp/

# download, build, and install eureka-server
RUN MVN_VERSION=3.3.9 && \
    MVN_FILE=apache-maven-${MVN_VERSION}-bin.tar.gz && \
    curl -L -o /tmp/${MVN_FILE} "http://apache.osuosl.org/maven/maven-3/${MVN_VERSION}/binaries/${MVN_FILE}" && \
    tar xzf /tmp/${MVN_FILE} -C /tmp; rm /tmp/${MVN_FILE} && \
    cd /tmp && \
    apache-maven-${MVN_VERSION}/bin/mvn --batch-mode clean package && \
    EUREKA_WAR=$(ls target/eureka-server-*.war | sed -e 's/target\/\(eureka-server-.*\.war\)$/\1/') && \
    mkdir -p /opt/eureka && cp target/${EUREKA_WAR} /opt/eureka/ && \
    ln -s /opt/eureka/${EUREKA_WAR} /opt/eureka/eureka.war && \
    cp src/main/resources/eureka.sh /opt/eureka/ && chmod 755 /opt/eureka/eureka.sh && \ 
    rm -rf ~/.m2 /tmp/apache-maven-${MVN_VERSION}

# env variables that can be overridden
ENV DIO_ENVIRONMENT= \
	DIO_BASE_DOMAIN= \
	AWS_DEFUALT_REGION=us-east-1 \
	EUREKA_JVM_PARAMS="-Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom -server -Xms256m" \
	EUREKA_USE_PRIVATE_IP=false
	
# expose the following ports
EXPOSE 8080

# run this command
ENTRYPOINT ["/opt/eureka/eureka.sh"]