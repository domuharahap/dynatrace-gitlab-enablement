#!/bin/bash
##############################################################
##  In here you add whatever action should happen after the container ha been created
##  such as exposing the application.
##############################################################
#Load the functions into the shell
source .devcontainer/util/source_framework.sh

#TODO: BeforeGoLive comment this so the Mkdocs are not exposed in the container.
# we want to monitor all interactions of the users in the live github pages.
#exposeMkdocs

# Re-establish GitLab port-forward (port 8929) if GitLab is installed.
# kubectl port-forward processes die when the container stops, so post-start
# restarts them so the Codespaces URL remains accessible after a resume.
if kubectl get ns "${GITLAB_NAMESPACE:-gitlab}" &>/dev/null && \
   kubectl get svc -n "${GITLAB_NAMESPACE:-gitlab}" gitlab-webservice-default &>/dev/null; then
  pkill -f "kubectl port-forward.*gitlab-webservice-default.*8929" 2>/dev/null || true
  nohup kubectl port-forward -n "${GITLAB_NAMESPACE:-gitlab}" svc/gitlab-webservice-default \
    8929:8080 --address 0.0.0.0 >/dev/null 2>&1 &
  printInfo "GitLab port-forward re-established on :8929"
fi

printInfoSection "Your dev.container finished starting up"