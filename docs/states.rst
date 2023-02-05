Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


gitea
^^^^^
*Meta-state*.

This installs Gitea,
manages its configuration
and then starts the ``gitea`` service.


gitea.package
^^^^^^^^^^^^^
Installs Gitea only.

Releases are downloaded from the official server by default
and their signatures verified.


gitea.config
^^^^^^^^^^^^
Manages Gitea configuration.
Has a dependency on `gitea.package`_.


gitea.service
^^^^^^^^^^^^^
Starts the Gitea service and enables it at boot time.
Has a dependency on `gitea.config`_.


gitea.go
^^^^^^^^
Creates a build user and downloads Go.
Required for building Chroma.


gitea.mods.rst
^^^^^^^^^^^^^^
Compiles `Chroma <https://github.com/alecthomas/chroma>`_ from source
and installs a Python script that can be setup as an external renderer
for ``*.rst`` files.

Has a dependency on `gitea.go`_.


gitea.clean
^^^^^^^^^^^
*Meta-state*.

This state will undo everything performed in the ``gitea`` meta-state
in reverse order, i.e.
stops the service,
removes the configuration file and then
uninstalls the package.
Some paths are left to avoid accidental data loss
(namely ``GITEA_WORKDIR``, ``APP_DATA_PATH`` and the gitea user home).


gitea.package.clean
^^^^^^^^^^^^^^^^^^^
Removes Gitea.
Has a dependency on `gitea.config.clean`_.


gitea.config.clean
^^^^^^^^^^^^^^^^^^
Removes Gitea configuration. Has a dependency on `gitea.service.clean`_.


gitea.service.clean
^^^^^^^^^^^^^^^^^^^
Stops the gitea service and disables it at boot time.


gitea.go.clean
^^^^^^^^^^^^^^
Removes the build user and Go installation.


gitea.mods.rst.clean
^^^^^^^^^^^^^^^^^^^^
Removes the built ``chroma`` binary, the build path and the
``grst`` script.


