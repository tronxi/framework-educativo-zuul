FROM alpine/git as git
WORKDIR /repo
ADD https://api.github.com/repos/tronxi/framework-educativo-zuul/git/refs/heads/develop version.json
RUN git clone https://github.com/tronxi/framework-educativo-zuul.git
RUN cd framework-educativo-zuul && git checkout develop

FROM maven as builder
COPY --from="git" /repo/framework-educativo-zuul .
RUN mvn package spring-boot:repackage

FROM openjdk:8-alpine
ENV zuul-service zuul-service
ENV profile dev
COPY --from="builder" /target/framework-educativo-0.0.1-SNAPSHOT.jar .
CMD java -jar -Dspring.profiles.active=${profile} framework-educativo-0.0.1-SNAPSHOT.jar --eureka-host=${eureka_host} --zuul-servic=${zuul-service}