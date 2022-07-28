fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

fmt-check-diff:
	terraform fmt -check -diff -recursive

setup-git-hooks:
	rm -rf .git/hooks
	(cd .git && ln -s ../.git-hooks hooks)

gen-docs:
	# Generate the docs for environments
	terraform-docs markdown ./env/ondrejsika-dev > ./env/ondrejsika-dev/README.md
	git add ./env/ondrejsika-dev/README.md
	terraform-docs markdown ./env/ondrejsika-prod > ./env/ondrejsika-prod/README.md
	git add ./env/ondrejsika-prod/README.md

	# Generate the docs for apps
	terraform-docs markdown ./apps/example-infra > ./apps/example-infra/README.md
	git add ./apps/example-infra/README.md

	# Generate the docs for modules
	terraform-docs markdown ./modules/vm > ./modules/vm/README.md
	git add ./modules/vm/README.md


	# Commit
	git commit -m "[auto] docs: Terraform generated docs"
