# ingress-tls

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.6.1](https://img.shields.io/badge/AppVersion-v1.6.1-informational?style=flat-square)

`ingress-tls` installs and configures `cert-manager`, an `Ingress Controller` and a Let's Encrypt Issuer for automating TLS Certificates on AsyncAPI K8s services.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.jetstack.io | cert-manager | 1.6.1 |
| https://kubernetes.github.io/ingress-nginx | ingress-nginx | 4.0.16 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cert-manager.installCRDs | bool | `true` |  |
| certificates.issuer.acme.email | string | `"info@asyncapi.io"` |  |
| certificates.issuer.acme.server | string | `"https://acme-v02.api.letsencrypt.org/directory"` |  |
| certificates.issuer.acme.tokenSecretDestination | string | `"letsencrypt-prod"` |  |
| certificates.issuer.name | string | `"letsencrypt-prod"` |  |
| certificates.issuer.namespace | string | `"default"` |  |

## Installation

First, install all dependencies:
```bash
helm dependency update
```

Then install the chart:
```bash
helm install ingress-tls . --namespace ingress-tls --create-namespace --atomic
```

This will install: 

- [cert-manager](https://cert-manager.io/docs/), which takes care of issuing certificates, renewing them and managing the certificate resources. It can issue certificates from a variety of supported sources, including Let’s Encrypt, HashiCorp Vault, and Venafi as well as private PKI.
- A cert-manager [Issuer](https://cert-manager.io/docs/concepts/issuer/), which represent Certificat Authorities that generate signed certificates. This is a needed piece for making [cert-manager](https://cert-manager.io/docs/) to work. By default, a Let's Encrypt Issuer is created.
- [ingress-nginx](https://kubernetes.github.io/ingress-nginx/), which is an Nginx running as reverse-proxy and behaving as [K8s Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/), listening to the creation of [K8s Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) resources, which are K8s resources that exposes services publicly, and allows configuring TLS.

What this chart does not install:

- [K8s Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) for all services. This is something each service should take care of. An example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: server-api
  annotations:
    cert-manager.io/issuer: letsencrypt-prod # here we use the name of the issuer we created through this chart.
spec:
  tls: 
  - hosts:
    - api.asyncapi.com
    secretName: letsencrypt-prod-foo
  ingressClassName: nginx
  rules:
  - host: api.asyncapi.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: server-api
            port:
              number: 80
```

With this, you will be able to configure your service to serve traffic over HTTPS with a Let's Encrypt certificate.