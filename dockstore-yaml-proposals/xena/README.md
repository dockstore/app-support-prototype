# Overview

The .dockstore.yml should provide enough information to programatically
run an instance of a Xena instance. This includes not only running Xena, but loading
it up with data.

This is an attempt for the docker-compose defined at https://github.com/coverbeck/xenahub,
i.e., once this is all worked out, the files would be checked into that repo.

## Example Usage by a client

1. Client downloads index files from Dockstore (docker-compose.yml and README.md).
2. Client downloads genomics data for Xena
    * Either using one of the pre-defined JSON files, which has references to genomics datasets on the web; Note that this isn't a very likely use case for Xena, as you would typically only install your own instance to visualie private data, but it's useful as for services in general.
    * And/or generating a template JSON, which the user fills in, either manually or through some nice UI, and downloads.
3. Client runs the commands in the `scripts` section.

## Issues/Fuzzy Stuff

1. The second command in the `scripts` section should only run after the docker container is up and running, as well as the service itself inside of the container. How do we indicate this reliably, i.e., not a hacky sleep?
2. The probemap file should preferably be loaded, but the decision to do so is independent of the other data.
3. The second command in the scripts section is referencing the name of the dataFile. This introduces variables
4. Have tried adding the `multiple` property 
5. What if a user wants to add something the next day?
