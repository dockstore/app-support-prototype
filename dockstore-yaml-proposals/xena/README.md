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
```
        - docker-compose up -d 
        - docker exec xena java -jar /ucsc_xena/cavm-0.24.0-standalone.jar --load /root/xena/files/$(dataset.data.name)
```
1. The probemap file should preferably be loaded, but the decision to do so is independent of the other data.
1. Both the dataFile and the metadataFile need to be present. Schema currently does not capture the relationship.
1. The second command in the scripts section is referencing the name of the dataFile, `...files/$(dataset.data.name)`. This is referring to the the dataset.data parameter declared later in the file. Is there a better way to do this? How would this interact with any environment variables -- would those get substituted as well.
1. The idea of the `multiple` property is that there might n datasets that might get loaded. The `afterrun` would need to be invoked.
1. What if a user wants to add something the next day? The client would have to know to only run `afterrun`.
1. How to know that the service is ready to run?
