# vim: ft=sls

{#-
    Removes the build user and Go installation.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

Go is absent for build user:
  file.absent:
    - name: {{ gitea.lookup.build_user_home | path_join("go") }}

Gitea build user is absent:
  user.absent:
    - name: {{ gitea.lookup.build_user }}
