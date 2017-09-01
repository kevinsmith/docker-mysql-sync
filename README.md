# klsmith/mysql-sync

A Docker utility that wraps MySQL command line tools to perform a one-way sync from one database to another.

Since the source database may be in another Docker container that is still in the process of coming up, this utility automatically waits on the source database to become accessible before continuing.

## Usage

There are several ways to run `klsmith/mysql-sync`.

Stand-alone:

```
docker run -e SRC_HOST=sourcehost.example.com \
    -e SRC_NAME=source_db_name \
    -e SRC_PASS=source_db_pass \
    -e SRC_USER=source_db_user \
    -e DEST_HOST=destinationhost.example.com \
    -e DEST_NAME=destination_db_name \
    -e DEST_PASS=destination_db_pass \
    -e DEST_USER=destination_db_user \
    klsmith/mysql-sync
```

Docker Compose:

```
version: '2'

services:
  mysql-sync:
    image: 'klsmith/mysql-sync:latest'
    environment:
      - SRC_HOST=sourcehost.example.com
      - SRC_NAME=source_db_name
      - SRC_PASS=source_db_pass
      - SRC_USER=source_db_user
      - DEST_HOST=destinationhost.example.com
      - DEST_NAME=destination_db_name
      - DEST_PASS=destination_db_pass
      - DEST_USER=destination_db_user

```

The important bits are the environment variables, **all of which are required**.

| Environment Variable | Description |
|----------------------|-------------|
| SRC_HOST | Source db hostname |
| SRC_NAME | Source db name |
| SRC_PASS | Source db password |   
| SRC_USER | Source db username |
| DEST_HOST | Destination db hostname |
| DEST_NAME | Destination db name |
| DEST_PASS | Destination db password |   
| DEST_USER | Destination db username |

The container will exit with code 0 when the sync finishes.

## Bug Reports

If you think you've found a bug, please post a good quality bug report in [this project's GitHub Issues](https://github.com/kevinsmith/docker-mysql-sync/issues). Quoting from [Coen Jacobs](https://coenjacobs.me/2013/12/06/effective-bug-reports-on-github/), this is how you can best help me understand and fix the issue:

- The title **explains the issue** in just a couple words
- The description **is detailed enough** and contains at least:
  - **steps to reproduce** the issue
  - what the expected result is and **what actually happens**
  - the **version** of the software being used
  - versions of **relevant external software** (e.g. hosting platform, orchestrator, MySQL version, etc.)
- Explain **what you’ve already done** trying to fix this issue
- The report is **written in proper English**

## License

Copyright 2017 Kevin Smith

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
