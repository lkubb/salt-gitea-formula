# vim: ft=sls

{#-
  *Meta-state*.

  This installs the gitea package,
  manages the gitea configuration file
  and then starts the associated gitea service.
#}

include:
  - .package
  - .config
  - .service
