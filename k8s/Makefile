ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: help lint_lint_files _lint_k8s _pull-tf _pull-tf-docs

CURRENT_DIR     = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	@echo "lint       Static source code analysis"

lint:
	@$(MAKE) --no-print-directory _lint_k8s

_lint_k8s:
	docker run --rm -v $(CURRENT_DIR):/data cytopia/kubeval *.yml
