.PHONY: init
init:
	bash set_region_for_makefile.sh && terraform init && terraform -chdir=./working-environment init

.PHONY: apply
apply:
	terraform apply && terraform -chdir=./working-environment apply

.PHONY: destroy
destroy:
	terraform -chdir=./working-environment destroy && terraform destroy
