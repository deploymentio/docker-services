#!/bin/bash

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

export PATH="$PATH:$JAVA_HOME/bin"
if [[ -z $DIO_ENVIORNMENT || -z $DIO_BASE_DOMAIN ]]; then
	
	exec java $EUREKA_JVM_PARAMS \
		-jar /opt/eureka/eureka.war \
		--spring.profiles.active=local \
		--server.port=8080

else

	exec java $EUREKA_JVM_PARAMS \
		-jar /opt/eureka/eureka.war \
		--spring.profiles.active=aws \
		--server.port=8080 \
		--dio.base-domain=$DIO_BASE_DOMAIN \
		--dio.environment=$DIO_ENVIRONMENT \
		--dio.aws-region=$AWS_DEFAULT_REGION \
		--dio.use-private-ip=$EUREKA_USE_PRIVATE_IP

fi
