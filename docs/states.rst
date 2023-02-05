Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


gitea
^^^^^
*Meta-state*.

This installs the gitea package,
manages the gitea configuration file
and then starts the associated gitea service.


gitea.package
^^^^^^^^^^^^^
This state will install the gitea package only.


gitea.config
^^^^^^^^^^^^
This state will configure the gitea service
and has a dependency on ``gitea.install`` via include list.


gitea.service
^^^^^^^^^^^^^
This state will start the gitea service
and has a dependency on ``gitea.config`` via include list.


gitea.go
^^^^^^^^



gitea.mods.rst
^^^^^^^^^^^^^^



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
This state will remove the gitea package and has a depency on
``gitea.config.clean`` via include list.


gitea.config.clean
^^^^^^^^^^^^^^^^^^
This state will remove the configuration of the gitea service and has a
dependency on ``gitea.service.clean`` via include list.


gitea.service.clean
^^^^^^^^^^^^^^^^^^^
This state will stop the gitea service and disable it at boot time.


gitea.go.clean
^^^^^^^^^^^^^^



gitea.mods.rst.clean
^^^^^^^^^^^^^^^^^^^^



