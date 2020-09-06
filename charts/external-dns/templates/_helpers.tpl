{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "externaldns.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "externaldns.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "externaldns.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "externaldns.labels" -}}
app.kubernetes.io/name: {{ include "externaldns.name" . }}
helm.sh/chart: {{ include "externaldns.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Build the full image
*/}}
{{- define "externaldns.image" -}}
{{- printf "%s/%s:%s" (.repository | default "") .image_name (.tag | default "latest") | trimPrefix "/" -}}
{{- end -}}

{{/*
Provide the arguments for externaldns
*/}}
{{- define "externaldns.args" -}}
{{- with .Values.args }}
- --source={{ .source }}
{{ template "externaldns.args.pdns" .provider }}
- --txt-owner-id={{ .owner_id }}
- --domain-filter={{ .domain_filter }}
- --log-level={{ .log_level }}
- --interval={{ .interval }}
{{- end }}
{{- end -}}

{{/*
Arguments to connect externaldns to powerdns
*/}}
{{- define "externaldns.args.pdns" -}}
{{- with .pdns }}
- --provider=pdns
- --pdns-server={{ .server }}
- --pdns-api-key={{ .api_key }}
{{- end }}
{{- end -}}

{{- define "externaldns.envs" -}}
{{- $root := . -}}
{{ range ( keys . ) -}}
- name: {{ upper . }}
  value: {{ get $root . }}
{{- end }}
{{- end -}}
