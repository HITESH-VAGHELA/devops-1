# ---------- Multi-staging dockerfile ----------

FROM openjdk:8-jdk as builder

RUN addgroup --gid 1627 client \
    && adduser --uid 1627 --gid 1627 client

RUN apt-get update \ 
    && apt-get install ant -y

WORKDIR /usr/local/ant

RUN chown -R client:client /usr/local/ant

USER client

COPY --chown=client:client . .

RUN ant

# ------------ app host on tomcat server ------------

FROM tomcat:9.0.65

WORKDIR /usr/local/tomcat/webapps 
ENV CATALINA_OPTS="-DDATABASE_SERVER: ${DATABASE_SERVER} \
            -DDATABASE: ${DATABASE} \
            -DMYSQL_USER: ${MYSQL_USER} \
            -DDATABASE_PORT: ${DATABASE_PORT} \
            -DMYSQL_PASSWORD: ${MYSQL_PASSWORD}"
RUN addgroup --gid 1627 client \
    && adduser --uid 1627 --gid 1627 client
RUN chown -R client:client /usr/local/tomcat/webapps

USER client

COPY --from=builder --chown=client:client /usr/local/ant/babycare.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
