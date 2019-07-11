# Proposals

This contains subdirectories of evolving example and proposed .dockstore.yml files, to try to handle
concrete services that might get registered with Dockstore.

The services are:

* Xena Hub
* JBrowse
* (not ready) [Bravo](https://github.com/statgen/bravo) -- Variant browser
* (not ready) generick8s -- this is a Kubernetes guest book example application. Using it until I can find a bioinformatics, K8s service.

The schema of the .dockstore.yml follows. For now, we will describe by example; a formal schema may follow.

### Terms

* Service -- what the .dockstore.yml describes.
* User -- the consumer of the service.
* Input Parameter file -- allows the user to specify inputs to the service, e.g., what genomics data to download, what environment variables to set.
* Launcher -- the application that launches the service, using the information provided in the .dockstore.yml and the input parameter file. Examples: Leonardo, Dockstore CLI.


### The .dockstore.yml

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
     - healthcheck.sh

  scripts:
    # The scripts section has 8 pre-defined keys. 5 are run in a defined order,
    # the other 3 are utilities that can be invoked by the service launcher.
    # Only 3 of the keys must exist and have values: start, port, and stop.
    # The keys' values, if present, must be script files that are indexed (in the files section, above).

    # The service launcher will execute the scripts in the following order. All steps other than start are optional,
    # and if they are missing or have no value specified, will be ignored.
    #
    # 1. preprovision -- Invoked before anything has been done.
    # 2. prestart -- Executed after data has been downloaded locally (see the data section)
    # 3. start -- Starts up the service.
    # 4. poststart -- After the service has been started
    # 5. postprovision -- Also after the service has been started. This might be invoked multiple times, e.g., if the user decides to load multiple sets of data. 

    # In addition, the following scripts, if present, are for use by the launcher:
    # 1. port - Which port the service is exposing. This provides a generic way for the tool to know which port is being exposed, e.g., to reverse proxy it.
    # 2. healthcheck - exit code of 0 if service is running normally, non-0 otherwise.
    # 3. stop - stops the service

    preprovision: 
    prestart: 
    start: stand_up.sh
    poststart: 
    postprovision: load.sh

    port: port.sh
    healthcheck: healthcheck.sh
    stop: stop.sh

  environment:
    # These are environment variables that the tool is responsible for passing to any scripts that it invokes.
    # The names must be valid environment variable names.
    # Users can override these.
    # These variables are service-specific, i.e., the service creator decides what values, if any, to 
    # expose as environment variables.
    # There are three parts to the environment variable
    #    - The name
    #    - An optional default value, which will be used if the user does not specify in the input file
    #    - An optional description, which can be used by the service launcher as a prompt
    #
    # Note that environment variables values' are strings. Because YAML recognizes both
    # strings, booleans, and numbers, it is safest to double quote values that may be
    # interpreted as booleans, integers, or floats.
    #
    #
    
    httpPort:
        default: "7222"
        description: The host's HTTP port. The default is 7222.

  data:
    # This section describes data that should be provisioned locally for use by
    # the service. The service launcher is responsible for provisioning the data.
    #
    # Each key in this section is the name of a dataset. Each dataset can have
    # 1 to n files. 
    #
    # Each dataset has the following properties:
    #   - targetDirectory -- required, indicates where the files in the dataset should be downloaded to. Paths are relative.
    #   - files -- required, 1 to n files, where each file has the following attributes:
    #           - description -- a description of the file
    #           - targetDirectory -- optionally override the dataset's targetDirectory if this file needs to go in a diffferent location.
    dataset_1:
        targetDirectory: xena/files 
        files:
            tsv:
                description: Data for Xena in TSV format

                # Could override targetDirectory here, but since all files go into xena/files, no need
                # targetDirectory:
            metadata:
                description: The metadata, in JSON format, that corresponds to the previous tsv file

```

### The Input Parameter JSON

Users will specify values for their services via an input parameter JSON. This is inspired by how parameters
are handled in CWL and WDL. The user will create an input parameter JSON file, and specify the file to the
service launcher. Alternatively, the service launcher can generate the JSON, perhaps after dynamically
prompting the user for inputs. The way the input parameter JSON is passed to the service launcher
is specific to the service launcher.

The input parameter JSON has 3 sections.

#### description

This is an optional property that describes the JSON. If the service creator wants to provide several
"pre-canned" JSON files, the descriptions can be used to distinguish between the files.

#### environment

This section is a map of environment variable names to environment variable values.

### data

This section is a map of dataset names, where each dataset specifies the files to be downloaded to the local system.
