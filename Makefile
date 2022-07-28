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
