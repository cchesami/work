#Create a dcokerfile from ubuntu base image and install
#java in it,docwnload jenkins.war and make
#"java -jar jenkins.war" as the default process of the
#container


FROM ubuntu
  MAINTAINER Cletus
  RUN apt-get update
  RUN apt-get install -y openjdk-8-jdk
  ADD https://get.jenkins.io/war-stable/2.263.4/jenkins.war /
  ENTRYPOINT ["java","-jar","jenkins.war"]

