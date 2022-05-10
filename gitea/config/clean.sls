# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

include:
  - {{ sls_service_clean }}

gitea-config-clean-file-absent:
  file.absent:
    - names:
      - {{ gitea.lookup.paths.conf | path_join('app.ini') }}
{%- if gitea._generate_token %}
      - {{ gitea.lookup.paths.internal_token_uri[7:] }}
{%- endif %}
    - require:
      - sls: {{ sls_service_clean }}
