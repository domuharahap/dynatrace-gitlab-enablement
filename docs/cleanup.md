--8<-- "snippets/dt-enablement.md"

# Cleanup

Remove all workshop resources when you are done.

---

## Stop the JMeter Test

If a JMeter test is still running, stop it first:

```bash
stopJmeterTest
```

!!! info ""
    `stopJmeterTest` deletes the JMeter Kubernetes Job and removes the `jmeter` namespace. Any running pod is terminated immediately.

---

## Remove dtpay

=== "Using the framework function"

    ```bash
    undeployDtpay
    ```

=== "Using kubectl directly"

    ```bash
    kubectl -n dtusecase delete -f .devcontainer/apps/dtpay/manifests/dtpay.yaml
    kubectl delete ns dtusecase
    ```

---

## Remove Dynatrace Operator (optional)

If you want to fully remove Dynatrace monitoring from the cluster:

```bash
uninstallDynatrace
```

!!! warning ""
    This removes the Dynatrace Operator Helm release, all Dynakubes, and the `dynatrace` namespace. OneAgent stops reporting immediately.

---

## Delete the Codespace

!!! tip "Delete from inside the terminal"
    There is a convenience function loaded in the shell — just type:

    ```bash
    deleteCodespace
    ```

    This triggers deletion of the Codespace from inside the container itself.

Alternatively, go to [https://github.com/codespaces](https://github.com/codespaces){target=_blank} and delete the Codespace from the GitHub UI.

!!! warning "Revoke the API token"
    After the workshop, revoke or delete the Dynatrace API token you used (`DT_OPERATOR_TOKEN`) to avoid leaving unused credentials active.

<div class="grid cards" markdown>
- [Resources :octicons-arrow-right-24:](resources.md)
</div>
