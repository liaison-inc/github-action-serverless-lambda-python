FROM nikolaik/python-nodejs:python3.7-nodejs14-alpine

LABEL version="1.0.0"
LABEL repository="https://github.com/serverless/github-action"
LABEL homepage="https://github.com/serverless/github-action"
LABEL maintainer="Serverless, Inc. <hello@serverless.com> (https://serverless.com)"

LABEL "com.github.actions.name"="Serverless"
LABEL "com.github.actions.description"="Wraps the Serverless Framework to enable common Serverless commands."
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="red"

RUN mkdir /opt/tools
COPY ./entry.sh /opt/tools

RUN apk update
RUN apk upgrade
RUN apk add bash
RUN apk add musl-dev
RUN apk add make
RUN apk add gcc

RUN apk add aws-cli

RUN npm i -g serverless@2.52.0
RUN npm install --save-dev serverless-lift

RUN python3 -m pip install --upgrade pip setuptools
RUN python3 -m pip install --user pipx
RUN python3 -m pipx install pipenv

ENV PATH="/root/.local/bin:${PATH}"

ENTRYPOINT ["/opt/tools/entry.sh"]