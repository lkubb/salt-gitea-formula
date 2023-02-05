# vim: ft=sls

{#-
    This state will configure the gitea service
    and has a dependency on ``gitea.install`` via include list.
#}

include:
  - .file
