format:
	@$(MAKE) js-format
	@$(MAKE) python-format

python-format:
	@isort . && black . && ruff .

js-format:
	@npx prettier --write .
