# vim: ft=sls

{#-
    Creates a build user and downloads Go.
    Required for building Chroma.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

Gitea build user is present:
  user.present:
    - name: {{ gitea.lookup.build_user }}
    - home: {{ gitea.lookup.build_user_home }}
    - createhome: true

Go is installed for build user:
  archive.extracted:
    - name: {{ gitea.lookup.build_user_home }}
    - source: {{ gitea.lookup.go.pkg }}
    - source_hash: {{ gitea.lookup.go.source_hash }}
    - user: {{ gitea.lookup.build_user }}
