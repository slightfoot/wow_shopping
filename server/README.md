## WOW Shopping App Server

This is HTTP server that hosts the application API. If you want to 
run the application you must first start a server.

### Running the server

```shell
dart run bin/main_dev.dart
```

### Test the server is running

From a second terminal:
```shell
curl http://0.0.0.0:8080/ping
```

### Building a Docker image

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```shell
docker build . -t myserver
```

Test built image:

```shell
docker run -it -p 8080:8080 myserver
```

## Testing

Run test suite with:
```shell
dart run test
```

### Generating coverage reports

#### Prerequisites

To generate reports you'll need to install [coverage](https://pub.dev/packages/coverage) 
and [lcov](https://github.com/linux-test-project/lcov).

1. Coverage: `dart pub global activate coverage`

2. LCOV `brew install lcov`

#### Generating reports

Get coverage report with:
```shell
dart pub global run coverage:test_with_coverage
genhtml -o coverage coverage\lcov.info
open coverage\index.html
```
