#! /bin/bash

# Switch to script dir
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

ansibleSshKeyArguments=()

if [ -n "$ANSIBLE_SSH_KEY" ] && [ -f "$ANSIBLE_SSH_KEY" ]; then
	chmod 600 "$ANSIBLE_SSH_KEY"
	ansibleSshKeyArguments=("--private-key" "$ANSIBLE_SSH_KEY")
fi

if [ -n "$ANSIBLE_VAULT_PASSWORD_FILE" ] && [ -f "$ANSIBLE_VAULT_PASSWORD_FILE" ]; then
	chmod 600 "$ANSIBLE_VAULT_PASSWORD_FILE"
fi

mkdir -p ~/.ssh/sockets

ansible-playbook \
	-i "inventory/hosts" \
	-D \
	-b -u ansible \
	"${ansibleSshKeyArguments[@]}" \
	"playbook.yml" \
	"$@"
