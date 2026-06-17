# Endtest CircleCI Orb

The official CircleCI orb for running [Endtest](https://endtest.io) web and mobile tests from CircleCI pipelines.

The orb can start one or more Endtest executions, wait for all results, display each result, and fail the CircleCI job when any execution reports failed assertions or errors.

- [Endtest website](https://endtest.io)
- [CircleCI Orb Registry](https://circleci.com/developer/orbs/orb/endtest/endtest)
- [CircleCI integration documentation](https://endtest.io/docs/integrations/circleci)
- [Endtest API documentation](https://endtest.io/docs/advanced/how-to-use-the-endtest-api)

## Configure CircleCI

In **Project Settings → Environment Variables**, add:

```text
ENDTEST_APP_ID
ENDTEST_APP_CODE
```

Keep those credentials secret. Put the API request visibly in `.circleci/config.yml` without `appId` or `appCode`.

## Run one test suite

```yaml
version: 2.1

orbs:
  endtest: endtest/endtest@0.0.7

workflows:
  endtest-tests:
    jobs:
      - endtest/run:
          api_request: 'https://app.endtest.io/api.php?action=runWeb&suite=YOUR_SUITE_ID&platform=windows&os=windows11&browser=chrome&browserVersion=latest&resolution=1280x1024&geolocation=sanfrancisco&cases=all&notes='
          number_of_loops: 10
```

The orb securely appends `appId` and `appCode` from the CircleCI environment variables.

## Run multiple test suites

Use an Endtest label:

```yaml
version: 2.1

orbs:
  endtest: endtest/endtest@0.0.7

workflows:
  critical-tests:
    jobs:
      - endtest/run:
          api_request: 'https://app.endtest.io/api.php?action=runWeb&label=Critical&platform=windows&os=windows11&browser=chrome&browserVersion=latest&resolution=1280x1024&geolocation=sanfrancisco&cases=all&notes='
          number_of_loops: 10
```

When Endtest returns multiple comma-separated execution hashes, the orb waits for all executions, prints individual and aggregate results, and fails if any execution fails.

## Custom credential variable names

```yaml
- endtest/run:
    app_id: MY_ENDTEST_APP_ID
    app_code: MY_ENDTEST_APP_CODE
    api_request: 'https://app.endtest.io/api.php?action=runWeb&label=Critical&platform=windows&os=windows11&browser=chrome&browserVersion=latest&resolution=1280x1024&geolocation=sanfrancisco&cases=all&notes='
    number_of_loops: 10
```

The values passed to `app_id` and `app_code` are environment-variable names, not credentials.

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `app_id` | Environment-variable name | `ENDTEST_APP_ID` | Variable containing the Endtest App ID. |
| `app_code` | Environment-variable name | `ENDTEST_APP_CODE` | Variable containing the Endtest App Code. |
| `api_request` | String | Empty | Visible API request without `appId` or `appCode`. |
| `api_request_env_var` | Environment-variable name | `ENDTEST_API_REQUEST` | Legacy fallback containing a complete API request. |
| `number_of_loops` | Integer | `10` | Maximum result checks, one every 30 seconds. |

The visible `api_request` parameter takes priority over the legacy environment variable.

## Pipeline behavior

The job succeeds only when every execution reports:

```text
Failed: 0
Errors: 0
```

The job fails when any execution fails, errors, returns an invalid response, or exceeds the configured polling period.

## Local development

```bash
circleci config pack src > orb.yml
circleci orb validate orb.yml
circleci orb publish orb.yml endtest/endtest@dev:your-version
circleci orb publish promote endtest/endtest@dev:your-version patch
```

## Support

- [Endtest CircleCI integration guide](https://endtest.io/docs/integrations/circleci)
- [Endtest API guide](https://endtest.io/docs/advanced/how-to-use-the-endtest-api)
- [Endtest website](https://endtest.io)
