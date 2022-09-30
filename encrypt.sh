#! /bin/bash

# Switch to script dir
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

if [[ ! ( -n "$ANSIBLE_VAULT_PASSWORD_FILE" && -f "$ANSIBLE_VAULT_PASSWORD_FILE" ) ]]; then
	echo "Vault Password File not found."
	echo "Make sure the environment variable ANSIBLE_VAULT_PASSWORD_FILE is set to the password file"

	exit 1
fi

# Ansible is fussy about that
chmod 600 "$ANSIBLE_VAULT_PASSWORD_FILE"

variable="${1:-variable}"

if [ $# -ge 2 ]; then
	value="$2"
else
	read -r -p "Enter value for the variable \"$variable\": " value
fi

ansible-vault \
	encrypt_string \
	"--vault-password-file=$ANSIBLE_VAULT_PASSWORD_FILE" \
	--encrypt-vault-id default \
	--name "$variable" \
	"$value"
