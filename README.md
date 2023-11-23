# WebDP
An open API for Differential Privacy systems

## Goal
The main goal of this project is to provide the design of WebDP, a simple
Application Public Interface (API) that other developers and systems can rely on
to communicate with different Differential Privacy (DP) systems through the web
in a transparent manner. This design is based on a comprehensive literature
review of the existing DP frameworks, and aims to provide a sensible interface
to encode the most common DP tasks a data owner or analyst might want to perform
through a WebDP server.

## Shortcuts

* [API specification version 1.0.0](https://editor.swagger.io/?url=https://webdp.dev/api/WebDP-1.0.0.yml)
* [A walkthrough over WebDP](/mockup/webdp_mockup.ipynb) (an interactive Jypyter
  notebook with simple examples of intended use to get started)

# Design

This API is designed using standard development practices and open-source tools.
In particular, we use the [OpenAPI](https://www.openapis.org/) version 3.0.0
specification to define the API schemas (i.e., the types of the data handled by
requests and responses to/from a WebDP server), as well as the different HTTP
endpoint (i.e., the differentially private operations that a compliant WebDP
server must support). More concretely, the API is divided into four main
operation categories:

* User management:
  + Creating, updating and deleting users
  + DP Roles (i.e., granting or removing user access to certain operations)
  + User authentication
* Dataset management:
  + Creating, updating and deleting datasets
  + Uploading datasets’ raw data into the server’s memory or external database
* Budget tracking:
  + Allocating the global privacy budget of different datasets across different
    users
  + Enforcing that users cannot violate the dataset’s global budget or their
    allocated one before performing queries
* Query evaluation:
  + Interpreting generic JSON-defined DP queries
  + Gathering DP results and presenting them to the user

Perhaps most interestingly, the WebDP API allows users to define DP queries in a
simple step-wise manner. On each step, the query can perform either a data
transformation or partition, and must finish with a DP measurement. Concretely,
our initial design encompasses the following query operation steps:

* Data transformations:
  +  `select`: project one or more columns of the dataset
  +  `rename`: rename one or more columns of the dataset
  +  `filter`: filter the dataset rows based on a boolean predicate (akin to an
     SQL WHERE clause)
  +  `map`: transform the dataset rows into new ones using a mapping function
  +  `bin`: map the values of a column to a predefined bin
* Data partitions:
  + `groupby`: group rows depending on the value of a column against a
    predefined set of keys
* DP measurements:
  + `count`: a differentially private count of the number of rows in the dataset
  + `min`: a differentially private minimum of a row in the dataset
  + `max`: a differentially private maximum of a row in the dataset
  + `sum`: a differentially private sum of a row in the dataset
  + `mean`: a differentially private mean of a row in the dataset

As an example, if the system has a loaded dataset with columns `age`, `salary`
(both numeric), and `job` (an enumeration), a user would be able to write the
following query to create a differentially private analysis of the mean salary
young professionals across jobs:

```json
[
  { "filter": [ "age > 18", "age < 35" ] },
  { "groupby": { "job": [ "Accountant", "Dentist", "High School Teacher", "Software Engineer" ] } },
  { "mean": { "column": "salary" } }
]
```

Obtaining a result like it follows:

```json
{
  "rows": [
    { "job": "Accountant"         , "mean_salary": 7214.23  },
    { "job": "Dentist"            , "mean_salary": 9513.44  },
    { "job": "High School Teacher", "mean_salary": 4432.09  },
    { "job": "Software Engineer"  , "mean_salary": 10584.12 },
  ]
}
```

# Proof of Concept

With the API design in place, developers can rely on open-source tools like
[OpenAPI Generator](https://github.com/OpenAPITools/openapi-generator) to
automatically generate client and server code that implements the communication
protocol defined in the WebDP API, making it easy for both DP users and
implementors to join the project’s proposed ecosystem. In this fashion, DP
users can easily start using any WebDP-compliant server to execute
differentially private queries using either an automatically generated client
in their programming language of choice, or by encoding requests directly using
the familiar JSON format.

On the other hand, DP implementors can develop WebDP-compliant servers by
automatically generating a server stub for the programming language of their
choice and implementing the mocked-up endpoint controllers using their own DP
framework primitives.

As a starting point for these tasks, this project provides two scripts for the
generation of WebDP's [client](/scripts/generate-client-stub-python.sh) and
[server](/scripts/generate-server-stub-python.sh) stubs as Python libraries.
These serve as an entry point for DP implementors looking to develop the WebDP
connector of their choice.

# Contributing
WebDP relies on the collaborative efforts of our community, and we
enthusiastically invite you to join us in shaping its development! Should you
wish to get involved, don't hesitate to reach out to us at
[webdp@dpella.io](mailto:webdp@dpella.io) or on [our website](https://dpella.io).

## Bug Reports
Found a bug or have a feature request? Please open an issue
[here](https://github.com/dpella/WebDP/issues).

# Acknowledgments
This project was founded by the [TERMINET
consortium](https://terminet-h2020.eu/).

# License
Distributed under the Apache License Version 2.0. See [LICENSE](LICENSE) for more
information.
