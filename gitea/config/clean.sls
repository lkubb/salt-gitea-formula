# vim: ft=sls

{#-
    Removes Gitea configuration. Has a dependency on `gitea.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

include:
  - {{ sls_service_clean }}

Gitea configuration is absent:
  file.absent:
    - names:
      - {{ gitea.lookup.paths.conf | path_join("app.ini") }}
{%- if gitea._generate_token %}
      - {{ gitea.lookup.paths.internal_token_uri[7:] }}
{%- endif %}
      - {{ gitea.lookup.paths.conf | path_join(".saltcache.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
