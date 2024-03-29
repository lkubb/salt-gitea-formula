# vim: ft=sls

{#-
    Stops the gitea service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

Gitea is dead:
  service.dead:
    - name: {{ gitea.lookup.service.name }}
    - enable: false
