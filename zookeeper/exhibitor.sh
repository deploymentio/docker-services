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

# required params
if [[ -z $EXHIBITOR_HOST_OR_IP || -z $EXHIBITOR_S3_BUCKET || -z $DIO_ENVIRONMENT || -z $DIO_BASE_DOMAIN ]]; then
	echo "Running in 'file' mode" 

	# Start Exhibitor
	export PATH="$PATH:$JAVA_HOME/bin"
	exec java -jar /opt/zookeeper/exhibitor.jar \
		--configtype file \
		--headingtext "${EXHIBITOR_HEADING}" \
		--fsconfigdir /opt/zookeeper/conf \
		--fsconfigname exhibitor.conf

else
		
	# setting some vars
	CONFIG_FILE=/opt/zookeeper/conf/exhibitor.conf
	S3_PREFIX=${DIO_ENVIRONMENT}.${DIO_BASE_DOMAIN}/zookeeper
	S3_BUCKET_PATH=s3://${EXHIBITOR_S3_BUCKET}/${S3_PREFIX}/exhibitor.conf
	S3_CONFIG="${EXHIBITOR_S3_BUCKET}:${S3_PREFIX}/exhibitor.conf"   
	echo "*** Running in 's3' mode: \$AWS_DEFAULT_REGION=[$AWS_DEFAULT_REGION] \$EXHIBITOR_HOST_OR_IP=[$EXHIBITOR_HOST_OR_IP] \$EXHIBITOR_S3_BUCKET=[$EXHIBITOR_S3_BUCKET] \$S3_PREFIX=[$S3_PREFIX] ***" 

	# Save CONFIG_FILE if not found in S3_BUCKET_PATH
	[[ $( aws s3 ls ${S3_BUCKET_PATH} | wc -l ) -gt 0 ]] || aws s3 cp ${CONFIG_FILE} ${S3_BUCKET_PATH}
	
	# Start Exhibitor
	export PATH="$PATH:$JAVA_HOME/bin"
	exec java -jar /opt/zookeeper/exhibitor.jar \
		--configtype s3 \
		--s3region ${AWS_DEFAULT_REGION} \
		--s3config ${S3_CONFIG} \
		--headingtext "${EXHIBITOR_HEADING}" \
		--nodemodification true \
		--hostname ${EXHIBITOR_HOST_OR_IP}
		
fi