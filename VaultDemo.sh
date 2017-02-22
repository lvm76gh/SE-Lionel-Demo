#! /bin/bash 


# Read IPs from Terraform artifacts
LISTIPS=`grep \"public_ip\" terraform.tfstate | awk -F: '{print $2}' | sed  's/\"//g' | sed  's/\,//g'`

# Pick an valid AWS IP
VAULTIP=`echo $LISTIPS | awk '{print $1}'`

echo "Using Detected AWS IP $VAULTIP"


# Initialize Vault

function setkeys {
VAULT_TOKEN=$(jq -r  .root_token .vault_init_response)
VAULT_KEYS=$(jq  .keys_base64[0] .vault_init_response)
}

function extract_ids {
SECRET_ID=$(grep \"secret_id\" .secret_id | awk '{print $2}')
ROLE_ID=$(grep "role_id" .role_id | awk '{print $2}')
}

case $1 in
	put)
		if [ ! -f .vault_init_response ]; then
			echo "Please run init command first"
			exit 1
		else
		#	if [ -f .client_token ]; then
		#		VAULT_TOKEN=$(grep client_token .client_token | awk '{print $2}')	
	  	#	else	
				setkeys		# default to root token if client token doesn't exist
	 	#	fi
			echo "Enter KeyID"
			read KEY
			echo "Enter Value"
			read VALUE
			KEY=$KEY
			VALUE=$VALUE
			echo "Writing $KEY=$VALUE from VaultDemo at $VAULTIP"
			curl -X POST -H "X-Vault-Token:$VAULT_TOKEN" -d "{\"$KEY\":\"$VALUE\"}" http://$VAULTIP:8200/v1/secret/vaultdemo
		fi
		;;
	get)
		if [ ! -f .vault_init_response ]; then
			echo "Please run init command first"
			exit 1
		else
		#	if [ -f .client_token ]; then
		#		VAULT_TOKEN=$( grep client_token .client_token | awk '{print $2}' )	
		#	else	
				setkeys		# default to root token if client token doesn't exist
		#	fi
			echo "Obtaining $KEY=$VALUE from VaultDemo at $VAULTIP"
			curl -X GET -H "X-Vault-Token:$VAULT_TOKEN" http://$VAULTIP:8200/v1/secret/vaultdemo | jq .
		fi
		;;	
	init)
		if [  -f .vault_init_response ]; then
			echo "Init already completed, please run get|put|auth|post "
			exit 1
		else
			echo "Initializing Vault.... obtaining Vault unseal keys...  can only be run once"
			curl -X PUT -d "{\"secret_shares\":1, \"secret_threshold\":1}" http://$VAULTIP:8200/v1/sys/init | jq . > .vault_init_response
			echo "Intialization complete. ".vault_init_response"  written to local path - DO NOT DELETE"
		fi
		;;
	unseal)
		if [ ! -f .vault_init_response ]; then
			echo "Please run init command first"
			exit 1
		else
			setkeys
			curl -X PUT -d "{\"key\": $VAULT_KEYS}" http://$VAULTIP:8200/v1/sys/unseal
		fi
		;;
	auth)
		setkeys    # use root token
		curl -X POST -H "X-Vault-Token:$VAULT_TOKEN" -d '{"type":"approle"}' http://$VAULTIP:8200/v1/sys/auth/approle
		curl -X POST -H "X-Vault-Token:$VAULT_TOKEN" -d '{"policies":"dev-policy,test-policy"}' http://$VAULTIP:8200/v1/auth/approle/role/testrole
		curl -X GET -H "X-Vault-Token:$VAULT_TOKEN" http://$VAULTIP:8200/v1/auth/approle/role/testrole/role-id | jq . > .role_id
		curl -X POST -H "X-Vault-Token:$VAULT_TOKEN" http://$VAULTIP:8200/v1/auth/approle/role/testrole/secret-id | jq . > .secret_id
		extract_ids
		curl -X POST  -d "{\"role_id\":$ROLE_ID,\"secret_id\":$SECRET_ID}" http://$VAULTIP:8200/v1/auth/approle/login | jq . > .client_token
		echo "Client token written to .client_token"
		;;
	*)
		echo $"Usage: $0 {init|unseal|auth|put|get}"
                exit 1

esac
