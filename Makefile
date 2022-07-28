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
	terraform-docs markdown ./modules/vm > ./modules/vm/README.md
	git add ./modules/vm/README.md

	# Commit
	git commit -m "[auto] docs: Terraform generated docs"
