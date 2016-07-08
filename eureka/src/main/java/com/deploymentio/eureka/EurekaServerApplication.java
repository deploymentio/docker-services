/*
 * Copyright 2016 - Deployment IO
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.deploymentio.eureka;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.commons.util.InetUtils;
import org.springframework.cloud.commons.util.InetUtilsProperties;
import org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import com.netflix.appinfo.AmazonInfo;
import com.netflix.appinfo.AmazonInfo.MetaDataKey;
import com.netflix.appinfo.InstanceInfo.InstanceStatus;

@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {

	@Profile("aws")	
	@Configuration
	public static class AwsEurekaInstanceConfigProvider {
		
		@Value("${dio.base-domain}")
		protected String baseDomain;
		
		@Value("${dio.environment}")
		protected String environment;

		@Value("${dio.use-private-ip}")
		protected boolean usePrivateIp;

		@Value("${spring.application.name}")
		protected String name;
		
		@Value("${server.port}")
		protected int serverPort;
		
		@Bean
		public EurekaInstanceConfigBean eurekaInstanceConfig() {
			EurekaInstanceConfigBean b = new EurekaInstanceConfigBean(new InetUtils(new InetUtilsProperties()));
			AmazonInfo info = AmazonInfo.Builder.newBuilder().autoBuild("eureka");
			b.setDataCenterInfo(info);
			b.setInitialStatus(InstanceStatus.UP);
			b.setAppname(name);
			b.setInstanceEnabledOnit(true);
			b.setNonSecurePort(serverPort);
			b.setNonSecurePortEnabled(true);
			b.setSecurePortEnabled(false);
			b.setInstanceId(info.get(MetaDataKey.instanceId));
			b.setVirtualHostName(name + "." + environment + baseDomain);
			b.setHostname(info.get(usePrivateIp ? MetaDataKey.localIpv4 : MetaDataKey.publicHostname));
			return b;
		}
	}

	public static void main(String[] args) {
		new SpringApplicationBuilder(EurekaServerApplication.class).web(true).run(args);
	}
}