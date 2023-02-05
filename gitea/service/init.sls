# vim: ft=sls

{#-
    This state will start the gitea service
    and has a dependency on ``gitea.config`` via include list.
#}

include:
  - .running
