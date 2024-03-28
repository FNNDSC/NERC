#!/bin/bash -e

secret_json="$(oc get secret openobserve-user-otel-collector -o jsonpath='{.data}')"
email="$(jq -r .email <<< "$secret_json" | base64 -d)"
password="$(jq -r .password <<< "$secret_json" | base64 -d)"

auth="$(echo "$email:$password" | base64)"

exec oc apply -f - << EOF
kind: OpenTelemetryCollector
apiVersion: opentelemetry.io/v1alpha1
metadata:
  name: otel-collector
  namespace: hosting-of-medical-image-analysis-platform-dcb83b
spec:
  config: |
    receivers:
      otlp:
        protocols:
          http:

    exporters:
      otlphttp/openobserve:
        endpoint: http://openobserve:5080/api/default/
        headers:
          Authorization: Basic $auth
          stream-name: default

    service:
      pipelines:
        traces:
          receivers: [otlp]
          exporters: [otlphttp/openobserve]
EOF
