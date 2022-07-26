# fastapi-scratch

Scratch project to play with fastapi.

## Running services

```sh
docker-compose up --detach
curl -k https://localhost:8000                              # hello world!
curl -k -u elastic:$ELASTIC_PASSWORD https://localhost:9200 # hello search!
open http://localhost:5601/app/dev_tools#/console           # hello kibana!
# user: elastic, pw: changeme
# from .env / .envrc files
```

## Testing

`make test`

## Project Dependencies

### App

-   [fastapi](https://fastapi.tiangolo.com/)
-   [uvicorn](https://www.uvicorn.org/)

### Testing

-   [pre-commit](https://pre-commit.com/index.html)
-   [schemathesis](https://schemathesis.readthedocs.io/en/stable/)

Surprisingly, I had to install requests as a dev dependency...I would have
expected that to be installed by default with fastapi so testing could be done
without having to specify that dependency...but maybe it's better this way so
when running in production there's one less dependency?

### CLI / Terminal

-   [direnv](https://direnv.net/)
    -   install with `brew install direnv`
-   [jq](https://stedolan.github.io/jq/)

## References

-   Elasticsearch setup was pulled from [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
