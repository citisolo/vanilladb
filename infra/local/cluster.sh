#!/bin/bash



function create_cluster() {
    kind create cluster --name terraform-learn --config infra/local/kind-config.yaml
}

function start_cluster() {
    kubectl cluster-info --context kind-terraform-learn
}


function get_cluster_config() {
    kubectl config view --minify --flatten --context=kind-terraform-learn -ojsonpath='{"host="}{.clusters[0].cluster.server}{"\n"}{"client_certificate="}{.users[0].user.client-certificate-data}{"\n"}{"client_key="}{.users[0].user.client-key-data}{"\n"}{"cluster_ca_certificate="}{.clusters[0].cluster.certificate-authority-data}{"\n"}'
}

function get_cockroach_db_operator(){
    kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/v2.4.0/install/crds.yaml
    kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/v2.4.0/install/operator.yaml
    kubectl config set-context --current --namespace=cockroach-operator-system
}

function use_cluster(){
    kubectl run cockroachdb -it --image=cockroachdb/cockroach --rm --restart=Never -- sql --insecure --host=cockroachdb-public
}

