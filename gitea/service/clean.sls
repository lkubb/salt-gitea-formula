# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

gitea-service-clean-service-dead:
  service.dead:
    - name: {{ gitea.lookup.service.name }}
    - enable: False
