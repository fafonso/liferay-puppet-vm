#FROM ubuntu:14.04
FROM ubuntu:15.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean \
	&& sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list \
	&& apt-get update -y \
	&& apt-get install -y debconf-utils -y \
	&& echo mysql-server-5.6 mysql-server/root_password password admin | debconf-set-selections \
	&& echo mysql-server-5.6 mysql-server/root_password_again password admin | debconf-set-selections \
	&& apt-get install -y mysql-server-5.6 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
	&& apt-get install -y default-jdk net-tools --fix-missing \
	&& apt-get install -y git wget unzip curl --fix-missing \
	&& rm -rf /var/lib/apt/lists/*
 
#RUN ln -fs /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java /etc/alternatives/java

#expose ports
EXPOSE 8080 8000 1234
 
RUN mkdir -p /opt/liferay/ 

RUN cd /opt/liferay && wget https://kent.dl.sourceforge.net/project/lportal/Liferay%20Portal/7.0.2%20GA3/liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip -O liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip 

RUN \
	cd /opt/liferay/ && \
	unzip liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip  && ls -lrt /opt/liferay/liferay-ce-portal-7.0-ga3

COPY setenv.sh /opt/liferay/liferay-ce-portal-7.0-ga3/tomcat-8.0.32/bin/
COPY portal-ext.properties /opt/liferay/liferay-ce-portal-7.0-ga3/

COPY entrypoint.sh /opt/liferay/liferay-ce-portal-7.0-ga3/tomcat-8.0.32/bin/
RUN chmod +x /opt/liferay/liferay-ce-portal-7.0-ga3/tomcat-8.0.32/bin/entrypoint.sh
 
# Add vertx to the path
#ENV PATH /usr/local/vertx/vert.x-2.1.2/bin:$PATH
 
ENTRYPOINT ["/opt/liferay/liferay-ce-portal-7.0-ga3/tomcat-8.0.32/bin/entrypoint.sh"]
 
CMD ["bash"]
