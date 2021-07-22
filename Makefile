build:
	docker build -t github-actions-serverless-lambda-python .

deploy:
	git add .
	git commit -am "update"
	git push origin $$(git rev-parse --abbrev-ref HEAD)

remove:
	$(docker rmi $(docker images -q github-actions-serverless-lambda-python) -f) \
    $(docker rmi $(docker images -f dangling=true -q) -f)