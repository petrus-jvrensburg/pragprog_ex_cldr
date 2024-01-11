# Pragprog Docker Container for Book Builds

--------------------------------------
DISCLAIMER!

This is experimental and NOT SUPPORTED BY PRAGPROG AT THIS TIME.

Only authors with experience building and running Docker containers
should follow this approach. This is not an official way to build books and 
editors or staff cannot support you if something goes wrong or doesn't work.

It's tested on Windows 10 Pro with Docker and Bash, and macOS with Docker and Bash.

-------------------------------------


Build your books in a Docker container instead of installing all of the prereqs (Ruby, Java, GhostScript, etc)

This works by mapping your book directory as a volume to a Docker container which has all of the prerequistes you need. The resulting book files end up where they normally would - in the same directory.

## Prerequisites

You'll need Docker installed, which you can do by using the official installer, based on your operating system.

* Windows 11/10: 
  * Install Windows Terminal from the store.
  * Use WSL2 and install Docker Desktop: https://docs.docker.com/desktop/install/windows-install/
* macOS: [Install Docker for Mac](https://docs.docker.com/docker-for-mac/install/)


## Create a local image

Ensure Docker is installed.

On macOS, open a new Terminal.

On Windows, open a new Bash session with Windows Terminal.

Navigate to the `YourBook/PerBook/util/docker_build` folder.

Run the command  `build_image.sh`

```
./build_image.sh
```

This will take up to 5 minutes to create the image, depending on the speed of your network connection and computer.

When you're done you'll have the image `ppbookshelf/bookbuilder`.

Switch back to your `Book` folder:

```
cd ../../../Book
```

Now copy the commands to build the book into your `Book` folder.

On macOS, copy the file `../PerBook/util/docker_build/local/drake`:

```
cp ../PerBook/util/docker_build/local/drake drake
```

For Windows, copy the `drake.bat` file instead using this command:

```
copy ..\PerBook\util\docker_build\local\drake.bat drake.bat
```

You've completed the setup.

## Building books

To build your PDF copy, run this command:

```
./drake clean screen
```

to build the PDF.

Run 

```
./drake clean epub
```

to build the ePub version.

Run 

```
./drake clean mobi
```

to build the Kindle version.





## Internal notes

Here's how each piece works:

```
├── Dockerfile           - Defines the container image.
├── README.md            - You're reading this.
├── build_image.sh       - Builds the docker image.
├── bin
│   └── build.sh         - This script runs in the container. It sets the CWD and invokes the build.
├── local
│   ├── drake             - Bash version of the script that launches the container.
│   └── drake.bat         - Windows version of the script that launches the container.
└── vendor
    └── kindlegen
        ├── kindlegen    - Kindlegen, needed to build Kindle books.
```

The `Dockerfile` sets up a container image based on OpenJDK8 and installs all the build tool prereqs. It then launches the Bash shell.

The `Dockerfile` explicitly loads individual paths so we only include what we need. If you add new files to the build system you may need to add them to the Dockerfile in the future.

The `local/drake*` scripts go in the root of each book. This script creates a Docker container, maps the `Book` directory of your book into the container as a volume, and then executes a build script in the container which calls the actual build system. It's a little complex, but this builds in some layers of indirection so we can change things up if necessary. Right now we're naming it `drake` to avoid any potential conflicts with existing systems. (drake is docker+rake).


