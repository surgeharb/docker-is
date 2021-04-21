FROM adoptopenjdk/openjdk8:jdk8u192-b12-alpine
MAINTAINER anupam@wso2.com

# Set user configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
ARG WSO2_SERVER_HOME=${USER_HOME}/wso2is-5.7.0

# create a user group and a user
RUN  addgroup -g ${USER_GROUP_ID} ${USER_GROUP}
RUN  adduser -u ${USER_ID} -D -g '' -h ${USER_HOME} -G ${USER_GROUP} ${USER}

# Copy wso2 product and kubernetes membership libs.
COPY files/product/wso2is-5.7.0 ${WSO2_SERVER_HOME}/
COPY files/libs/dnsjava-2.1.8.jar ${WSO2_SERVER_HOME}/repository/components/lib/
COPY files/libs/kubernetes-membership-scheme-1.0.5.jar ${WSO2_SERVER_HOME}/repository/components/dropins/

# Change owner and permission
RUN chmod 777 -R ${WSO2_SERVER_HOME}/
RUN chown -R wso2carbon:wso2 ${WSO2_SERVER_HOME}/

# copy init script to user home
COPY init.sh ${USER_HOME}/
RUN chown -R wso2carbon:wso2 ${USER_HOME}/init.sh
RUN chmod +x ${USER_HOME}/init.sh


ENV WSO2_SERVER_HOME=${WSO2_SERVER_HOME}
USER ${USER_ID}
WORKDIR ${USER_HOME}
EXPOSE 9763 9443
ENTRYPOINT ["/home/wso2carbon/init.sh"]
