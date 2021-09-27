NAME := "github-actions-serverless-lambda-python"
PROFILE := "liaison"
REGION := "us-east-2"
BRANCH := $$(git rev-parse --abbrev-ref HEAD)
TAG := ${BRANCH}

ifeq ($(TAG),"master")
	TAG = "latest"
endif

--repo:
	git init
	gh repo create liaison-inc/${NAME}
--ecr:
	aws ecr create-repository --profile ${PROFILE} --region ${REGION} --repository-name ${NAME}
--ecr-delete:
	aws ecr delete-repository --profile ${PROFILE} --region ${REGION} --repository-name ${NAME}
--remove:
	$(docker rmi $(docker images -q ${NAME}) -f) \
  	$(docker rmi $(docker images -f dangling=true -q) -f)
--push:
	git add .
	git diff-index --quiet HEAD || git commit -am "update"
	git push origin ${BRANCH}
#####################################################################################################################
#####################################################################################################################
#####################################################################################################################
#####################################################################################################################
#####################################################################################################################
init:
	make -- --repo
	make -- --ecr
clean:
	make -- --remove
	make -- --ecr-delete

build:
	docker build -t ${NAME}:${TAG} .

deploy:
	echo "${TAG}"
	make build
	make -- --push
	docker --version; \
  	$$(aws ecr --profile ${PROFILE} get-login --region ${REGION} --no-include-email); \
    docker tag ${NAME}:${TAG} 773024094974.dkr.ecr.${REGION}.amazonaws.com/${NAME}:${TAG}; \
    docker push 773024094974.dkr.ecr.${REGION}.amazonaws.com/${NAME}:${TAG}