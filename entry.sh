#!/bin/bash

if ! command -v aws &>/dev/null; then
  echo "aws could not be found"
  exit
fi

if [[ -z $ARTIFACT_DOMAIN ]]; then
  echo "Please set the ARTIFACT_DOMAIN environemnt variable"
  exit 1
fi

if [[ -z $ARTIFACT_DOMAIN_OWNER ]]; then
  echo "Please set the ARTIFACT_DOMAIN_OWNER environemnt variable"
  exit 1
fi

if [[ -z $ARTIFACT_REPOSITORY ]]; then
  echo "Please set the ARTIFACT_REPOSITORY environemnt variable"
  exit 1
fi

if [[ -n $ARTIFACT_REGION ]]; then
  CODEARTIFACT_TOKEN="$(aws codeartifact get-authorization-token --region $ARTIFACT_REGION --domain ${ARTIFACT_DOMAIN} --domain-owner ${ARTIFACT_DOMAIN_OWNER} --query authorizationToken --output text)"
  export PIPENV_PYPI_MIRROR=https://aws:${CODEARTIFACT_TOKEN}@${ARTIFACT_DOMAIN}-${ARTIFACT_DOMAIN_OWNER}.d.codeartifact.${ARTIFACT_REGION}.amazonaws.com/pypi/${ARTIFACT_REPOSITORY}/simple/
else
  CODEARTIFACT_TOKEN="$(aws codeartifact get-authorization-token --domain ${ARTIFACT_DOMAIN} --domain-owner ${ARTIFACT_DOMAIN_OWNER} --query authorizationToken --output text)"
  export PIPENV_PYPI_MIRROR=https://aws:${CODEARTIFACT_TOKEN}@${ARTIFACT_DOMAIN}-${ARTIFACT_DOMAIN_OWNER}.d.codeartifact.${ARTIFACT_REGION}.amazonaws.com/pypi/${ARTIFACT_REPOSITORY}/simple/
fi

eval sls "$@"
