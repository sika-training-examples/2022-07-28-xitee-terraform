fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

fmt-check-diff:
	terraform fmt -check -diff -recursive

setup-git-hooks:
	rm -rf .git/hooks
	(cd .git && ln -s ../.git-hooks hooks)
