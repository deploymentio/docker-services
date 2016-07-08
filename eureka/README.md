## Eureka docker image

Contains docker image for running a netflix-eureka server (https://github.com/Netflix/eureka) in a micro services infrastructure. This docker image is published on https://hub.docker.com/r/deploymentio/eureka/

There are two modes the eureka server can be started in. The *local* mode is used for local development. Starting a contianer in this mode will start a standlone eureka server in a non-HA fasion. This mode is not suitable for running in production. The other mode is *aws* mode, suitable to run on an EC2 instance with the `host` docker networking mode. The *aws* mode requires the following docker `ENV` variables to be set to function properly:

- `AWS_DEFUALT_REGION` - Defaults to `us-east-1`, set it to AWS region of your choice.
- `DIO_ENVIRONMENT`, `DIO_BASE_DOMAIN` - Required parameters that make up the domain which would be equal to `{DIO_ENVIRONMENT}.{DIO_BASE_DOMAIN}`. The domain is used to lookup eureka instances themselves using the name of `eureka.{domain}`. Also, the domain would be for eureka servers to discover each other through DNS TXT records - see https://github.com/Netflix/eureka/wiki/Deploying-Eureka-Servers-in-EC2 for more details.
- `EUREKA_JVM_PARAMS` - Sensible default value is present but this provides a means to override the defaults. See the Dockerfile for the defaults.
- `EUREKA_USE_PRIVATE_IP` - Defaults to `false` which will register the eureka peers with EC2 instance's public hostname. If this is set to `true`, eureka peers will be registered with the EC2 instance's private IP address, which might be needed if the eureka instance runs in a private subnet of your VPC.