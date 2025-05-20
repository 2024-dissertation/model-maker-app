[![main](https://github.com/2024-dissertation/frontend/actions/workflows/main.yml/badge.svg)](https://github.com/2024-dissertation/frontend/actions/workflows/main.yml)

# Model Maker Frontend

This is the frontend for my dissertation project. It is built using Flutter. 

## Tests

To run the tests, run the following command:

```bash
flutter test
```

To generate coverage reports, run the following command:

```bash
flutter test --coverage
```

To convert the report to html, run the following command:

```bash
genhtml coverage/lcov.info -o coverage/html
```

## CI/CD

This project uses GitHub Actions for CI/CD. The workflow is defined in `.github/workflows/main.yml`.

Sources
 - https://yayocode.com/codelabs/flutter/flutter_simple_crud_with_firebase_and_cubit/
