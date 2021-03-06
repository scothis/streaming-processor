#!/usr/bin/env bash

set -Eeuxo pipefail

function get_maven_project_version() {
  mvn -q org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -DforceStdout
}

function deploy() {
  mvn -B com.google.cloud.tools:jib-maven-plugin:1.3.0:build \
    -Djib.to.image="${1}" \
    -Djib.to.auth.username="${DOCKER_USER}" \
    -Djib.to.auth.password="${DOCKER_PASS}"
}

function main() {
  base_image="projectriff/streaming-processor"
  version=$(get_maven_project_version)

  echo "Deploying ${base_image} (latest and ${version})"
  deploy "${base_image}"
  deploy "${base_image}:${version}"
}

main
