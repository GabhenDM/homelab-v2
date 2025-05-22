# Ansible for K3s Cluster

## Dependencies

- `ansible >= 2.13`
- `python3` & `pip3` with any required collections’ Python deps

## Bootstrap collections

```bash
cd ansible
ansible-galaxy collection install -r requirements.yml 
ansible-playbook k3s.orchestration.site -i inventory.yml
```

