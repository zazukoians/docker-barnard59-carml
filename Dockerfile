FROM docker.io/library/maven:3.8.4-openjdk-11 as builder

ARG GIT_CHECKOUT="417a3ab6aa8b3df3819d2b96443a806221d251d6"

WORKDIR /carml
RUN git clone https://github.com/carml/carml-jar.git
WORKDIR /carml/carml-jar
RUN git checkout "${GIT_CHECKOUT}"
RUN mvn clean package && mv carml-app/target/carml-jar-*.jar /carml/carml.jar

FROM docker.io/library/node:18-alpine

ENV CARML_PATH="/carml/carml.jar"
ARG BARNARD59_VERSION="1.1.2"

WORKDIR /app

RUN apk add --no-cache openjdk11-jre-headless
COPY --from=builder /carml/carml.jar "${CARML_PATH}"
RUN npm install -g "barnard59@${BARNARD59_VERSION}"

ENTRYPOINT []
