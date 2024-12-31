
resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "51.1.0"

  values = [
    <<EOF
    prometheus:
      service:
        type: LoadBalancer
    EOF
  ]

  depends_on = [kubernetes_namespace.monitoring]
}
