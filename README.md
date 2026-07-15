# zabbix-openpbs

A small Bash integration that reports OpenPBS problem nodes to Zabbix agent2.
It is independent of `pbs_monitor` and uses `pbsnodes -l` as its only data source.

The script reports every node returned by `pbsnodes -l`, including states such
as `down`, `offline`, and `state-unknown`. A 45-second local cache prevents each
Zabbix item from running another PBS query.

## Install

```bash
sudo ./install.sh
sudo systemctl restart zabbix-agent2
```

> **Required:** Restart `zabbix-agent2` after installation. The new OpenPBS
> checks will not be loaded until the service is restarted.

The installer copies the files to:

```text
/etc/zabbix/scripts/zabbix-openpbs
/etc/zabbix/zabbix_agent2.d/zabbix-openpbs.conf
```

Import `zabbix-openpbs.yaml` into Zabbix and link **OpenPBS node status by
Zabbix agent** to the host running the script.

The Zabbix service account must be able to run `/opt/pbs/bin/pbsnodes -l`.
Override the command or cache settings with environment variables when needed:

```text
PBSNODES=/opt/pbs/bin/pbsnodes
CACHE_TTL=45
CACHE_DIR=/tmp/zabbix-openpbs-<uid>
```

## Verify

```bash
/etc/zabbix/scripts/zabbix-openpbs discovery
zabbix_agent2 -t openpbs.node.problem.count
zabbix_agent2 -t openpbs.node.discovery
```

## Test

```bash
./tests/test.sh
```
