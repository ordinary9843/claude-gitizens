# system — examples

Use for plugin infrastructure: hooks, setup scripts, settings files.

## Good

```
system: add session-start hook to inject world context
system: add settings.local.json with bash permissions
system: rewrite session-start to use python3 base64 decode
system: add check-access script for gh CLI verification
```

## Bad

```
system: update hook            ← too vague
system: Infrastructure         ← not imperative, not lowercase
chore: add session-start       ← wrong type — infrastructure is `system:`
```
