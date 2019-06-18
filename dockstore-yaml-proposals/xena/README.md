# Overview

The .dockstore.yml should provide enough information to programatically
run an instance of a Xena instance. This includes not only running Xena, but loading
it up with data.

This is an attempt for the docker-compose defined at https://github.com/coverbeck/xenahub,
i.e., once this is all worked out, the files would be checked into that repo.

## Example Usage by a client

1. Client downloads index files from Dockstore (docker-compose.yml and README.md).
2. Client downloads genomics data for Xena
    * Either using one of the pre-defined JSON files, which has references to genomics datasets on the web; Note that this isn't a very likely use case for Xena, as you would typically only install your own instance to visualize private data, but it's useful as example for services in general.
    * And/or generating a template JSON, which the user fills in, either manually or through some nice UI, and downloads.
3. Client runs the commands in the `scripts` section.

## Issues/Fuzzy Stuff

1. The probemap file should preferably be loaded, but the decision to do so is independent of the other data.
1. The second command in the scripts section is referencing the name of the data file, `...files/$(parameters.dataset.data.name)`. This is referring to the the dataset.data parameter declared later in the file. Is there a better way to do this? How would this interact with any environment variables -- would those get substituted as well. Doing so with `parameters` prefix.
1. The idea of the `multiple` property is that there might n datasets that might get loaded. The `afterrun` would need to be invoked.
1. What if a user wants to add something the next day? The client would have to know to only run `afterrun`.
1. Should we require certain parameters, in particular the port? That way the consumer of this will know what port to access the service on.
