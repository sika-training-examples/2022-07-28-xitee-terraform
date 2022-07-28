lock:
	rm -rf .terraform.lock.hcl
	terraform providers lock \
		-platform=darwin_amd64 \
		-platform=darwin_arm64 \
		-platform=linux_amd64 \
		-platform=linux_arm64 \
		-platform=windows_amd64
	git add .terraform.lock.hcl
	git commit -m "[auto] chore(terraform.lock.hcl): Update Terraform lock" .terraform.lock.hcl

tf-init:
ifndef CLIENT_ID
	$(error CLIENT_ID is undefined)
endif
ifndef SUBSCRIPTION_ID
	$(error SUBSCRIPTION_ID is undefined)
endif
ifndef TENANT_ID
	$(error TENANT_ID is undefined)
endif
ifndef CLIENT_SECRET
	$(error CLIENT_SECRET is undefined)
endif
	terraform init \
		-backend-config="client_id=${CLIENT_ID}" \
		-backend-config="subscription_id=${SUBSCRIPTION_ID}" \
		-backend-config="tenant_id=${TENANT_ID}" \
		-backend-config="client_secret=${CLIENT_SECRET}"
