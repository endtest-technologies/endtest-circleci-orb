# Endtest CircleCI Orb

The official CircleCI orb for running [Endtest](https://endtest.io) end-to-end tests from CircleCI pipelines.

Use this orb to trigger automated web or mobile tests in Endtest, wait for the execution to finish, display the results in CircleCI, and fail the pipeline when the test execution reports failures or errors.

- [Endtest website](https://endtest.io)
- [CircleCI Orb Registry](https://circleci.com/developer/orbs/orb/endtest/endtest)
- [CircleCI integration documentation](https://endtest.io/docs/integrations/circleci)
- [Endtest API documentation](https://endtest.io/docs/advanced/how-to-use-the-endtest-api)

## What the orb does

The orb provides a reusable CircleCI job that:

- starts an Endtest execution using a dynamically supplied Endtest API request
- authenticates with each user's own Endtest `appId` and `appCode`
- polls Endtest for the execution results
- prints the test suite, configuration, test counts, timestamps, and results URL
- passes the CircleCI job when the Endtest execution succeeds
- fails the CircleCI job when Endtest reports failed assertions, execution errors, or a timeout

The orb never contains or stores customer credentials. Each CircleCI project supplies its own Endtest credentials through environment variables.

## Prerequisites

You need:

1. An [Endtest](https://endtest.io) account.
2. Your Endtest `appId` and `appCode`, available from the Endtest settings page.
3. An Endtest API request that starts the test execution you want to run.
4. A CircleCI project connected to your repository.

## Configure the environment variables

In CircleCI, open:

```text
Project Settings → Environment Variables
```

Add these variables:

```text
ENDTEST_APP_ID
ENDTEST_APP_CODE
ENDTEST_API_REQUEST
```

Use your own Endtest values:

- `ENDTEST_APP_ID`: your Endtest App ID
- `ENDTEST_APP_CODE`: your Endtest App Code
- `ENDTEST_API_REQUEST`: the complete Endtest API request used to start the execution

Keeping these values in CircleCI environment variables prevents credentials from being committed to your repository.

## Basic usage

Add the orb to `.circleci/config.yml`:

```yaml
version: 2.1

orbs:
  endtest: endtest/endtest@0.0.1

workflows:
  endtest-tests:
    jobs:
      - endtest/run:
          app_id: ENDTEST_APP_ID
          app_code: ENDTEST_APP_CODE
          api_request: ENDTEST_API_REQUEST
          number_of_loops: 10
```

The orb checks the execution status once every 30 seconds. In this example, `number_of_loops: 10` allows the execution to run for approximately five minutes before the CircleCI job times out.

Always use the latest published version shown in the [CircleCI Orb Registry](https://circleci.com/developer/orbs/orb/endtest/endtest).

## Use custom environment-variable names

The parameter values are environment-variable names, not the credentials themselves. You may use different names in your CircleCI project:

```yaml
version: 2.1

orbs:
  endtest: endtest/endtest@0.0.1

workflows:
  endtest-tests:
    jobs:
      - endtest/run:
          app_id: MY_ENDTEST_APP_ID
          app_code: MY_ENDTEST_APP_CODE
          api_request: MY_ENDTEST_API_REQUEST
          number_of_loops: 20
```

In that case, add these variables in CircleCI:

```text
MY_ENDTEST_APP_ID
MY_ENDTEST_APP_CODE
MY_ENDTEST_API_REQUEST
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `app_id` | Environment-variable name | `ENDTEST_APP_ID` | Variable containing the user's Endtest App ID. |
| `app_code` | Environment-variable name | `ENDTEST_APP_CODE` | Variable containing the user's Endtest App Code. |
| `api_request` | Environment-variable name | `ENDTEST_API_REQUEST` | Variable containing the Endtest API request that starts the execution. |
| `number_of_loops` | Integer | `10` | Maximum number of result checks. Each check occurs after a 30-second wait. |

Because the three environment-variable parameters have defaults, the shorter configuration below is also valid when you use the standard variable names:

```yaml
version: 2.1

orbs:
  endtest: endtest/endtest@0.0.1

workflows:
  endtest-tests:
    jobs:
      - endtest/run:
          number_of_loops: 10
```

## Pipeline behavior

The CircleCI job succeeds when the completed Endtest execution reports no failed assertions and no execution errors.

The job fails when:

- Endtest reports one or more failed assertions
- Endtest reports one or more execution errors
- the execution enters an error state
- the API returns an invalid or unexpected response
- the execution does not finish within the configured polling period

This allows teams to use Endtest as a deployment gate in CircleCI workflows.

## Development version

During orb development, a development version can be referenced using a tag such as:

```yaml
orbs:
  endtest: endtest/endtest@dev:api-v1
```

Development versions are intended for testing. Production projects should use an immutable semantic version from the Orb Registry.

## Local development

Pack and validate the orb source:

```bash
circleci config pack src > orb.yml
circleci orb validate orb.yml
```

Publish a development version:

```bash
circleci orb publish orb.yml endtest/endtest@dev:api-v1
```

After validating a passing execution and a failing execution, promote the development version:

```bash
circleci orb publish promote endtest/endtest@dev:api-v1 patch
```

## Support

For questions about Endtest or the CircleCI integration:

- Read the [Endtest CircleCI integration guide](https://endtest.io/docs/integrations/circleci)
- Read the [Endtest API guide](https://endtest.io/docs/advanced/how-to-use-the-endtest-api)
- Visit [endtest.io](https://endtest.io)
