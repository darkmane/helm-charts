{{- define "metallb.address.pool" -}}
{{ printf "metallb.universe.tf/address-pool: %s" .Values.metallb.address_pool }}
{{- end -}}
