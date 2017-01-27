FROM ubuntu:14.04
 
# Install dev tools: jdk, git etc...

RUN sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y debconf-utils \
    && echo mysql-server-5.5 mysql-server/root_password password admin | debconf-set-selections \
    && echo mysql-server-5.5 mysql-server/root_password_again password admin | debconf-set-selections \
    && apt-get install -y mysql-server-5.5 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
	&& apt-get install -y net-tools --fix-missing \
	&& apt-get install -y openjdk-7-jdk git wget unzip curl --fix-missing \
	&& rm -rf /var/lib/apt/lists/*
 
# jdk7 is the default jdk
RUN ln -fs /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java /etc/alternatives/java

EXPOSE 8080 8000 1234
 
# Install vertx
RUN mkdir -p /opt/liferay/ 

RUN cd /opt/liferay && wget https://sourceforge.net/projects/lportal/files/Liferay%20Portal/6.2.4%20GA5/liferay-portal-tomcat-6.2-ce-ga5-20151119152357409.zip/download -O liferay-portal-tomcat-6.2-ce-ga5-20151119152357409.zip

RUN \
	cd /opt/liferay/ && \
	unzip liferay-portal-tomcat-6.2-ce-ga5-20151119152357409.zip 

#only for debugging on port 8000
COPY setenv.sh /opt/liferay/liferay-portal-6.2-ce-ga5/tomcat-7.0.62/bin/ 

COPY mysql.jar /opt/liferay/liferay-portal-6.2-ce-ga5/tomcat-7.0.62/lib/ext/
COPY entrypoint.sh /opt/liferay/liferay-portal-6.2-ce-ga5/tomcat-7.0.62/bin/
COPY portal-ext.properties /opt/liferay/liferay-portal-6.2-ce-ga5/
RUN chmod +x /opt/liferay/liferay-portal-6.2-ce-ga5/tomcat-7.0.62/bin/entrypoint.sh
 
# Add vertx to the path
#ENV PATH /usr/local/vertx/vert.x-2.1.2/bin:$PATH
 
#WORKDIR /usr/local/src
ENTRYPOINT ["/opt/liferay/liferay-portal-6.2-ce-ga5/tomcat-7.0.62/bin/entrypoint.sh"]
 
CMD ["bash"]
