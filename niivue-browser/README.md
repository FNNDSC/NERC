# niivue-browser on NERC

This app is available at:
https://niivue-hosting-of-medical-image-analysis-platform-dcb83b.apps.shift.nerc.mghpcc.org/

This is a demo deployment of https://github.com/FNNDSC/niivue-browser

## Usage

At a minimum, you need to run

```shell
kubectl apply -f volume.yml,deployment.yml,services.yml
```

There are some optional components specific for OpenShift:

```shell
oc apply -f volume.yml,deployment.yml,services.yml,route.yml
```
