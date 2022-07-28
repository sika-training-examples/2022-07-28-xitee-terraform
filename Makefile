fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

fmt-check-diff:
	terraform fmt -check -diff -recursive

setup-git-hooks:
	rm -rf .git/hooks
	(cd .git && ln -s ../.git-hooks hooks)

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

gen-docs:
	# Generate the docs for environments
	terraform-docs markdown ./modules/vm > ./modules/vm/README.md
	git add ./modules/vm/README.md

	# Commit
	git commit -m "[auto] docs: Terraform generated docs"

tf-init:
ifndef CLINET_ID
	$(error CLINET_ID is undefined)
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
		-backend-config="client_id=${CLINET_ID}" \
		-backend-config="subscription_id=${SUBSCRIPTION_ID}" \
		-backend-config="tenant_id=${TENANT_ID}" \
		-backend-config="client_secret=${CLIENT_SECRET}"
