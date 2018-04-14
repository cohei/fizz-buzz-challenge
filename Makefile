.PHONY: binary
binary:
	stack install

.PHONY: image
image: binary
	docker-compose build

.PHONY: imagePushed
imagePushed: image
	gcloud docker -- push asia.gcr.io/fizz-buzz-challenge/exe

.PHONY: cluster
cluster:
	terraform apply

.PHONY: clusterDestroyed
clusterDestroyed:
	terraform destroy

.PHONY: kubectlAuthenticated
kubectlAuthenticated: cluster
	gcloud container clusters get-credentials executor

.PHONY: secret
secret: kubectlAuthenticated secretDeleted
	@kubectl create secret generic fizz-buzz-challenge \
		--from-literal=uri=${FIZZBUZZ_CHALLENGE_URI}

.PHONY: secretDeleted
secretDeleted: kubectlAuthenticated
	kubectl delete secret fizz-buzz-challenge || true

.PHONY: job
job: imagePushed kubectlAuthenticated jobDeleted secret
	kubectl create -f job.yaml

.PHONY: jobDeleted
jobDeleted:
	kubectl delete -f job.yaml || true

.PHONY: lastLog
lastLog:
	kubectl logs `kubectl get pods -o json | jq -r '.items[0].metadata.name'`
