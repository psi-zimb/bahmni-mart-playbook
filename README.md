# bahmni-mart-playbook
Automated ansible playbook to deploy [bahmni-mart](https://github.com/bahmni-msf/bahmni-mart) along with [metabase](https://metabase.com)(docker container) and [spring cloud data flow server](https://cloud.spring.io/spring-cloud-dataflow/)(docker container) 
## For Bahmni-mart installation please do the following:

* Before running the installtion please add the following parameters in setup.yml file

|Property | Mandatory |
|:-----------|:------|
| analytics_db_password | Yes
| openmrs_db_password | Yes
| metabase_db_password | Yes


### HTTPS for metabase
* Update metabase_with_ssl to true
#### Let's encrypt ssl
Certificates generated from [let's encrypt](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/35586093/Configure+Valid+SSL+Certificates) can be used for metabase by converting them into jks format.
Update the following properties in setup.yml to run metabase with https.

|Property | Comment |
|:-----------|:---------|
| metabase_with_ssl | Set to true to add ssl certificate for metabase. When this is true, the properties **bahmni_lets_encrypt_cert_dir, metabase_keystore_password** should be provided. Default value is 'false'
| bahmni_lets_encrypt_cert_dir | Let's encrypt certificates directory, it is mandatory if **metabase_with_ssl** set to true. Eg: /etc/letsencrypt/live/demo.bahmni.org
| metabase_keystore_password | Some password to generate jks file, it is mandatory if **metabase_with_ssl** set to true|

Since let's encrypt certificates expires after 90 days, you need to regenerate jks file after renewing bahmni certificates. Use following command to regenerate jks file

```/opt/bahmni-mart/bin/pemtojks.sh <bahmni_lets_encrypt_cert_dir> <metabase_keystore_password>```

Stop metabase container and update metabase docker container

```docker-compose -f /opt/bahmni-mart/metabase-ssl-docker-compose.yml up -d```
#### Custom ssl
If you use other than let's encrypt certificates, generate jks(Java Key Store) file from your ssl certificate and provide jks file path in **custom_keystore_location** and provide the **metabase_keystore_password**(password which was used to generating jks file)
 ### Command to deploy
 #### Metabase without ssl
```foo@bar:~# ansible-playbook -i /etc/bahmni-mart-playbook/inventories/bahmni-mart /etc/bahmni-mart-playbook/all.yml --extra-vars '@/etc/bahmni-mart-playbook/setup.yml' --skip-tags "custom_ssl,lets_encrypt_ssl"```
#### Metabase with let's encrypt ssl
```foo@bar:~# ansible-playbook -i /etc/bahmni-mart-playbook/inventories/bahmni-mart /etc/bahmni-mart-playbook/all.yml --extra-vars '@/etc/bahmni-mart-playbook/setup.yml' --skip-tags "without_ssl,custom_ssl"```
#### Metabase with custom ssl
```foo@bar:~# ansible-playbook -i /etc/bahmni-mart-playbook/inventories/bahmni-mart /etc/bahmni-mart-playbook/all.yml --extra-vars '@/etc/bahmni-mart-playbook/setup.yml' --skip-tags "without_ssl,lets_encrypt_ssl"```

