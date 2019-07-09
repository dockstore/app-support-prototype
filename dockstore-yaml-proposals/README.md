# Proposals

This contains subdirectories of evolving example and proposed .dockstore.yml files, to try to handle
concrete services that might get registered with Dockstore.

The services are:

* Xena Hub
* JBrowse
* (not ready) [Bravo](https://github.com/statgen/bravo) -- Variant browser
* (not ready) generick8s -- this is a Kubernetes guest book example application. Using it until I can find a bioinformatics, K8s service.

The schema of the .dockstore.yml follows. For now, we will describe by example; a more formal schema may follow.

### Terms

* Service -- what the .dockstore.yml describes
* Tool -- the software that launches the service, using the information provided in the .dockstore.yml
* User -- the consumer of the service.

```
# The dockstore.yml version; 1.1 is required for services
version: 1.1

# The service key, which is required for services
service:
  # The type is required, and can be docker-compose, kubernetes, or helm. 
  type: docker-compose 

  # The name of the service, required
  name: UCSC Xena Browser # The name of the service, required

  # The author, optional
  author: UCSC Genomics Institute # The service's author

  # An optional description
  description: | 
    The UCSC Xena browser is an exploration tool for public and private,
    multi-omic and clinical/phenotype data.
    It is recommended that you configure a reverse proxy to handle HTTPS

  # These are files the Dockstore will index. They will be directly downloadable from Dockstore. Wildcards are not allowed.
  files:
     - docker-compose.yml
     - README.md
     - stand_up.sh
     - load.sh
     - port.sh
     - stop.sh
     - xena-all.json

  scripts:
    # The scripts section has 8 pre-defined keys. 5 are run in a defined order,
    # the other 3 are utilities that can be invoked by the tool launching the service.
    # Only 3 keys must exist and have values: start, port, and stop.

    # The tool launching the service will execute the scripts in the following order
    # 1. preprovision -- Invoked before anything has been done.
    # 2. prestart -- Executed after data has been downloaded locally (see the data section)
    # 3. start -- Starts up the service.
    # 4. poststart -- After the service has been started
    # 5. postprovision -- Also after the service has been started. This might be invoked multiple times, e.g., if the user decides to load multiple sets of data. 

    # In addition, the following scripts will be invoked by the tool launching the service:
    # 1. port - Which port the service is exposing. This provides a generic way for the tool to
    

    preprovision:

    prestart:

    # Starts the service
    start: stand_up.sh

    # After the service has started
    poststart:

    # After the service has started. For multiple provisionings, e.g., the user may decide to add more data later.
    postprovision: load.sh

    # Returns the port the service is exposing. Can be used by a client to know what port to proxy
    port: port.sh

    # Returns an exit code of 0 if service is running successfully.
    healthcheck:

    # Stops the service
    stop: stop.sh

  # Items in this section are passed to the scripts as environment variables.
  # The names must be valid enviornment variable names.
  environment:
    httpPort: # The name of the environment variable
        default: "7222" # An optional default value
        # A description that tools can use for prompting a user.
        description: The host's HTTP port. The default is 7222.

  # Data are files that are provisioned locally for the service. Each key is a dataset name,
  # and each dataset can contain 1 to n files
  data:
    # The name of a dataset, can be anything
    dataset_1:
        # The location on the local system where files should be downloaded to. This
        # can be overriden if desired on an individual file level.
        # In this case, Xena requires files to be located in the subdirectory xena/files
        # relative to where Xena is running.
        targetDirectory: xena/files 

        # The files property is required for datasets. It contains one or more files.
        # The sets of files can be repeated. In the sample xena-all.json, there are
        # 3 pairs of tsv/metadata files.
        files:
            tsv:
                description: Data for Xena in TSV format

                # Could override targetDirectory here, but since all files go into xena/files, no need
                # targetDirectory:
            metadata:
                description: The metadata, in JSON format, that corresponds to the previous tsv file

```
