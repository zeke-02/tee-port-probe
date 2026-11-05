# tee-port-probe

Throwaway probe. Asks whether a Tinfoil container without `cvm_admin` can accept
public inbound TCP on exactly port 25. Holds no secrets and stores no data.

1. Publish this repo publicly and release `v0.0.1`. A rejected config is an answer.
2. `tinfoil container create port25 --repo zeke-02/tee-port-probe --tag v0.0.1`
3. `tinfoil container get port25 -o json`, and note any allocated external port.
4. `./probe.sh <instance-hostname> [allocated-port]` from a network that allows
   outbound 25.
5. If non-admin is rejected, add `cvm_admin: true` to a test release only, to learn
   whether the block is the port or the admin requirement.
6. `tinfoil container stop port25`, then delete the instance and repo.
