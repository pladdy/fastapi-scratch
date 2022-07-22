.PHONY: openapi.json

APP = fastapi_scratch
POETRY_VERSION = 1.1.14
TEST = poetry run pytest -s -vv --durations=10 --cov=$(APP) tests

all: poetry install

app-open:
	open http://localhost:8000/docs

cov-reports:
	$(TEST) --cov-report html --cov-report xml --cov $(APP)/

cover: cov-reports
	open htmlcov/index.html

docs:
	open http://localhost:8000/docs

install:
	poetry install

openapi.json:
	curl -ks https://localhost:8000/openapi.json | jq .

poetry:
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/$(POETRY_VERSION)/get-poetry.py | python3 -

pre-commit:
	poetry run pre-commit run --all-files

pre-commit-update:
	poetry run pre-commit autoupdate

run-app:
	poetry run uvicorn $(APP).main:app --reload & \
		echo Run "'kill $$!'" to kill app.

run-compose:
	docker-compose up --build --detach

run-docker:
	docker build . -t fastapi:latest
	docker run --detach -p 8000:443 --name $(APP) --rm fastapi:latest

stop-app:
	pgrep -f fastapi | xargs kill

stop-compose:
	docker-compose down

stop-docker:
	docker stop $(APP)

test:
	$(TEST)

test-name:
ifdef name
	$(TEST) -k $(name)
else
	@echo Syntax is 'make $@ name=<test name>'
endif

test-openapi:
	PYTHONPATH=./ poetry run schemathesis run \
		--app=$(APP).main:app \
		--checks all \
		/openapi.json

tests: test test-openapi
