FROM bitnami/tomcat:9.0

LABEL maintainer="chiralphapps@gmail.com"

ENV TOMCAT_PASSWORD=Manager
ENV TOMCAT_ALLOW_REMOTE_MANAGEMENT=no
ENV TOMCAT_INSTALL_DEFAULT_WEBAPPS=no

COPY /target/ABCtechnologies*.war /opt/bitnami/tomcat/webapps/ROOT.war

EXPOSE 8080
