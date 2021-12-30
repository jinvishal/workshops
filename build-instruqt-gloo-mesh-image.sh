#!/bin/sh
cd packer/instruqt-gloo-mesh
packer init k3s.pkr.hcl
packer build -force -color=true -timestamp-ui -var 'k3s_version=v1.21.8+k3s1' -var 'gloo_version=1.2.7' -var 'istio_version=1.11.5' -var 'vcluster_version=v0.4.5' k3s.pkr.hcl
