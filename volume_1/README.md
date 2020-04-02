This is the companion notebook to "How would ReproNim..." Volume 1.

The notebook can be run if Docker is installed and the Python packages datalad, datalad_container, and jupyter are installed (as well as the Jupyter bash kernel).

To ease installation issues, the notebook can also be run from a Docker container.  An empty work directory must be mounted in the container at the same location as on the host, and the Docker socket must be available in the container as well.  So this will work:

    mkdir work

    cd work

    docker run \
           -p 8888:8888 \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v `pwd`:`pwd` \
           repronim/how-would-1:latest

The casual reader may stop reading now; the interested reader can find information about these caveats below.

The notebook launches containers; running the notebook in a container means running containers from a container.  Arguably the easiest way of doing this is by letting the container access Docker on the host; this is done by making /var/run/docker.sock available in the container; hence `-v /var/run/docker.sock:/var/run/docker.sock`.

The (processing) containers need access to data to work on.  Usually this is done by mounting a directory on the host (where Docker is running and from which containers are launched) to the processing container, but in this case we are trying to mount a directory that exists in the notebook container, and the host doesn't have access to this filesystem.  We solve this by making sure there is a directory that exists in the same place on the notebook container and the host.  The notebook container tells Docker that it wants to mount that directory in the processing container, and since the directory exists in the same place on the host, Docker can find it and mount it.  Hence ``-v `pwd`:`pwd` ``.

We require that the working directory be empty to avoid overwriting data.
