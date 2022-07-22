.PHONY: openapi.json

POETRY_VERSION = 1.1.14
TEST = poetry run pytest tests -s -vv

all: poetry 
	poetry install

app-open:
	open http://localhost:8000/docs

app-run:
	poetry run uvicorn fastapi_scratch.main:app --reload & \
		echo Run "'kill $$!'" to kill app.

cov-reports:
	$(TEST) --cov-report html --cov-report xml --cov fastapi_scratch/

cover: cov-reports
	open htmlcov/index.html

docs:
	open http://localhost:8000/docs

docker-run:
	docker build . -t fastapi:latest
	docker run --detach -p 8000:443 --name fastapi_scratch --rm fastapi:latest

docker-stop:
	docker stop fastapi_scratch

openapi.json:
	curl -ks https://localhost:8000/openapi.json | jq . > $@

poetry:
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/$(POETRY_VERSION)/get-poetry.py | python3 -

pre-commit:
	poetry run pre-commit

pre-commit-update:
	poetry run pre-commit autoupdate

test: test-openapi
	$(TEST)

test-name:
ifdef name
	$(TEST) -k $(name)
else
	@echo Syntax is 'make $@ name=<test name>'
endif

test-openapi:
	PYTHONPATH=./ poetry run schemathesis run \
		--app=fastapi_scratch.main:app \
		--checks all \
		/openapi.json