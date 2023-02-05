# vim: ft=sls

{#-
  *Meta-state*.

  This installs Gitea,
  manages its configuration
  and then starts the ``gitea`` service.
#}

include:
  - .package
  - .config
  - .service
