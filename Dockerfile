FROM chelseamboling/ubuntu-codeql-test:1.0

# SET WORKSPACE
WORKDIR codeql-app

# GET ARGS
 ARG REPO
 ARG REF
 ARG COMMIT
 ARG PAT

# SET ENV
ENV \
    CODEQL_QUERY_SUITE=/usr/bin/codeql/qlpacks/codeql-javascript/codeql-suites/javascript-code-scanning.qls \
    CODEQL_BINARY=/usr/bin/codeql/codeql \
    CODEQL_DATABASE=/codeql-database \
    CODEQL_SARIF=/codeql-sarif-results \
    CODEQL_SARIF_FILE=/codeql-sarif-results/code-scanning-alerts.sarif \
    REPO=${REPO} \
    REF=${REF} \
    COMMIT=${COMMIT} \
    PAT=${PAT}

# CHECKOUT/COPY SRC
COPY . .

RUN echo $REPO

# SETUP REQUIRED DIR AND FILES
RUN mkdir $CODEQL_SARIF
RUN touch $CODEQL_SARIF_FILE

# CREATE CODEQL DATABASE
RUN $CODEQL_BINARY database create $CODEQL_DATABASE --language=javascript

# ANALYZE CODEQL DATABASE
RUN $CODEQL_BINARY database analyze $CODEQL_DATABASE $CODEQL_QUERY_SUITE --format=sarif-latest --output=$CODEQL_SARIF_FILE

# UPLOAD CODEQL SARIF RESULTS TO CODE SCANNING ALERTS PAGE ON GITHUB
RUN $CODEQL_BINARY github upload-results --repository=$REPO --ref=$REF --commit=$COMMIT --sarif=$CODEQL_SARIF_FILE --github-auth-stdin=$PAT -v
