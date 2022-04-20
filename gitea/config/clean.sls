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
      - {{ gitea.lookup.paths.custom | path_join('conf', 'app.ini') }}
    - require:
      - sls: {{ sls_service_clean }}
