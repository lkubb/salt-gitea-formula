# vim: ft=sls

{#-
    *Meta-state*.

    This state will undo everything performed in the ``gitea`` meta-state
    in reverse order, i.e.
    stops the service,
    removes the configuration file and then
    uninstalls the package.
    Some paths are left to avoid accidental data loss
    (namely ``GITEA_WORKDIR``, ``APP_DATA_PATH`` and the gitea user home).
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
