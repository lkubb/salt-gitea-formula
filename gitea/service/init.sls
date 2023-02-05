# vim: ft=sls

{#-
    Starts the Gitea service and enables it at boot time.
    Has a dependency on `gitea.config`_.
#}

include:
  - .running
