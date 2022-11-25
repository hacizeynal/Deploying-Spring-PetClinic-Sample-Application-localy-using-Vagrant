# DevOps Project Demo I
## Deploying Spring PetClinic Sample Application localy using Vagrant

### Create repository on GitHub and commit all changes to your github repository

Create a deployment script for the **PetClinic** application. Use **Vagrant** to automate the process of creating the infrastructure for the deployment with **Virtualbox** (*preferably*). As for provisioning you can choose to use **bash**, **python** or **ansible** in any combination.

- Subtask I - Infrastructure
	* Describe *[two](https://www.vagrantup.com/docs/multi-machine/)* virtual machines using Vagrantfile for deployment of the application (codename **APP_VM**) and the database (codename **DB_VM**) 
	* Preferably use [private networking](https://www.vagrantup.com/docs/networking/private_network.html) feature for easy VM communication
	* VMs should be either Centos or Ubuntu
	* If not using private networking then **APP_VM** should have port `8080` forwarded to host

- Subtask II - Database
	* Use any [provisioning](https://www.vagrantup.com/docs/provisioning/basic_usage.html) script that you created to install `MySQL` and any dependency on **DB_VM**
	* Customize the mysql database to accept connections only from your vagrant private network subnet
	* Create a non root user and password (codename **DB_USER** and **DB_PASS**) in mysql. Use host environment variable to set these values and pass them to the Vagrantfile using `ENV`
	* Create a database in mysql (codename **DB_NAME**) and grant all privileges for the **DB_USER** to access the database
	

- Subtask III - Application
	* Create a non root user (codename **APP_USER**) that will be used to run the application on **APP_VM**
	* Use any provisioner to install `Java JDK`, `git` and any dependency on **APP_VM**
	* Clone [this repository](https://gitlab.com/dan-it/az-groups/az-devops1.git) to the working folder (codename **PROJECT_DIR**)
	* Use the Maven tool to run tests and package the application. For more info you can use this [5 minutes maven](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html) documentation. For convenience the project folder has Maven wrapper script (`mvnw`) that downloads and executes the required Maven binary automaticaly.
	* If testing and packaging is successful, then get the `*.jar` package from `$PROJECT_DIR/target` folder and place it in the **APP_USER** home folder (codename **APP_DIR**).
	* Set environment variables in **APP_VM** (preferable use the same environment variables passed from host machine using `ENV` as in **DB_VM**):
		* `DB_HOST` - IP of the **DB_VM**
		* `DB_PORT` - MySql port (default 3306)
		* `DB_NAME` - MySql database name
		* `DB_USER` - MySql user
		* `DB_PASS` - MySql user's password
	* Run the application with the **APP_USER** using the `java -jar` command
    * If everything is successful - you will see the PetClinic application on `$APP_VM_IP:8080`
- Additional tasks
	* Check if the mysql server is up and running and the database is accessible by created user (using either bash, python or ansible). If the databse is not accessible - break the provisoning process.
    * Create a script to wait for up to 1 minute to check if the application is up and running. Use application healthcheck endpoint `http://localhost:8080/actuator/health` to see if response code is `200` and the status in the response body is up (`{"status":"UP"}`)
    * Implement database connection fallback logic.  So that by default your java application should connect to mysql database on another VM. In case if that DB is not accessible application should connect to in-memory database (H2)
    * Instead **Virtualbox** use **AWS** provider

## Solution

In this project we will spin up 2 VMs on AWS via Vagrant, we will deploy our Spring Petclinic application in 1st VM and on the 2nd VM we will install MySQL DB.

Let's start to run our Vagrant and start to provision our Infrastructure via bash script.Make sure that your SG is allowing SSH access from your machine ,otherwise Vagrant will not able to SSH to Ubuntu VMs.We will see that scripts will be started to be executed once SSH connection is successful.

```
==> db: you can access this machine, otherwise Vagrant will not be able
==> db: to SSH into it.
==> db: Launching an instance with the following settings...
==> db:  -- Type: t2.micro
==> db:  -- AMI: ami-0149b2da6ceec4bb0
==> db:  -- Region: us-east-1
==> db:  -- Keypair: AWS_KEY_PAIR
==> db:  -- Subnet ID: subnet-0eac26c67bd7e38da
==> db:  -- Security Groups: ["sg-0afee790418d871a5"]
==> db:  -- Block Device Mapping: []
==> db:  -- Terminate On Shutdown: false
==> db:  -- Monitoring: false
==> db:  -- EBS optimized: false
==> db:  -- Source Destination check: 
==> db:  -- Assigning a public IP address in a VPC: true
==> db:  -- VPC tenancy specification: default
==> db: Waiting for SSH to become available...
==> app: Waiting for SSH to become available...

```
[![Screenshot-2022-11-25-at-20-15-50.png](https://i.postimg.cc/DzNNKC1Y/Screenshot-2022-11-25-at-20-15-50.png)](https://postimg.cc/t1hk3NSh)


