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
After successful implementation we can verify on AWS that our VMs are created. 

[![Screenshot-2022-11-25-at-20-15-50.png](https://i.postimg.cc/DzNNKC1Y/Screenshot-2022-11-25-at-20-15-50.png)](https://postimg.cc/t1hk3NSh)

The application script will install latest updates, maven ,git ,change hostname on the Ubuntu Machine.Then source code will be cloned and it will start to download dependencies from maven repository and build the source code via maven ,as a result artifact will be created.

```
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.20/commons-compress-1.20.jar (632 kB at 7.1 MB/s)
    app: Downloaded from central: https://repo.maven.apache.org/maven2/org/tukaani/xz/1.9/xz-1.9.jar (116 kB at 1.1 MB/s)
    app: [INFO] Building jar: /home/ubuntu/spring-petclinic/target/spring-petclinic-2.7.3.jar
    app: [INFO]
    app: [INFO] --- spring-boot-maven-plugin:2.7.3:repackage (repackage) @ spring-petclinic ---
    app: [INFO] Replacing main artifact with repackaged archive
    app: [INFO] ------------------------------------------------------------------------
    app: [INFO] BUILD SUCCESS
    app: [INFO] ------------------------------------------------------------------------
    app: [INFO] Total time:  01:57 min
    app: [INFO] Finished at: 2022-11-25T19:17:06Z
    app: [INFO] ------------------------------------------------------------------------

```
After the maven build we should see directory called target which will contain our artifacts.

```
ubuntu@app-vm:~/spring-petclinic$ ls -l target/
total 52448
-rw-r--r-- 1 root root    10615 Nov 25 19:15 checkstyle-cachefile
-rw-r--r-- 1 root root      283 Nov 25 19:15 checkstyle-checker.xml
-rw-r--r-- 1 root root    11360 Nov 25 19:15 checkstyle-header.txt
-rw-r--r-- 1 root root    11483 Nov 25 19:15 checkstyle-result.xml
-rw-r--r-- 1 root root      459 Nov 25 19:15 checkstyle-suppressions.xml
drwxr-xr-x 8 root root     4096 Nov 25 19:16 classes
drwxr-xr-x 3 root root     4096 Nov 25 19:16 generated-sources
drwxr-xr-x 3 root root     4096 Nov 25 19:16 generated-test-sources
-rw-r--r-- 1 root root   586391 Nov 25 19:17 jacoco.exec
drwxr-xr-x 2 root root     4096 Nov 25 19:17 maven-archiver
drwxr-xr-x 3 root root     4096 Nov 25 19:16 maven-status
drwxr-xr-x 3 root root     4096 Nov 25 19:17 site
-rw-r--r-- 1 root root 52643110 Nov 25 19:17 spring-petclinic-2.7.3.jar
-rw-r--r-- 1 root root   391710 Nov 25 19:17 spring-petclinic-2.7.3.jar.original
drwxr-xr-x 2 root root     4096 Nov 25 19:16 surefire-reports
drwxr-xr-x 3 root root     4096 Nov 25 19:16 test-classes

```

We can also see that as maven package manager is providing custom tests for source code and result will be written to **checkstyle-result.xml**.

Application will be started with default profile ,by default it uses in memory database (H2) ,as a requirement we will need to change to mysql profile in order to leverage MySQL DB.

Script will be started with detached mode ,which means it will run in the background.Below output shows that application is started with default profile and using Java 11.0.17 on app-vm with PID 20546.

```
ubuntu@app-vm:~/spring-petclinic$ 

              |\      _,,,--,,_
             /,`.-'`'   ._  \-;;,_
  _______ __|,4-  ) )_   .;.(__`'-'__     ___ __    _ ___ _______
 |       | '---''(_/._)-'(_\_)   |   |   |   |  |  | |   |       |
 |    _  |    ___|_     _|       |   |   |   |   |_| |   |       | __ _ _
 |   |_| |   |___  |   | |       |   |   |   |       |   |       | \ \ \ \
 |    ___|    ___| |   | |      _|   |___|   |  _    |   |      _|  \ \ \ \
 |   |   |   |___  |   | |     |_|       |   | | |   |   |     |_    ) ) ) )
 |___|   |_______| |___| |_______|_______|___|_|  |__|___|_______|  / / / /
 ==================================================================/_/_/_/

:: Built with Spring Boot :: 2.7.3


2022-11-25 19:33:09.431  INFO 20739 --- [           main] o.s.s.petclinic.PetClinicApplication     : Starting PetClinicApplication v2.7.3 using Java 11.0.17 on app-vm with PID 20739 (/home/ubuntu/spring-petclinic/target/spring-petclinic-2.7.3.jar started by ubuntu in /home/ubuntu/spring-petclinic)
2022-11-25 19:33:09.438  INFO 20739 --- [           main] o.s.s.petclinic.PetClinicApplication     : No active profile set, falling back to 1 default profile: "default"
2022-11-25 19:33:12.375  INFO 20739 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
2022-11-25 19:33:12.520  INFO 20739 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 126 ms. Found 2 JPA repository interfaces.
ubuntu@app-vm:~/spring-petclinic$ 2022-11-25 19:33:14.309  INFO 20739 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2022-11-25 19:33:14.343  INFO 20739 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2022-11-25 19:33:14.344  INFO 20739 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.65]
2022-11-25 19:33:14.571  INFO 20739 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2022-11-25 19:33:14.578  INFO 20739 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 4989 ms
2022-11-25 19:33:16.369  INFO 20739 --- [           main] org.ehcache.core.EhcacheManager          : Cache 'vets' created in EhcacheManager.
2022-11-25 19:33:16.399  INFO 20739 --- [           main] org.ehcache.jsr107.Eh107CacheManager     : Registering Ehcache MBean javax.cache:type=CacheStatistics,CacheManager=urn.X-ehcache.jsr107-default-config,Cache=vets
2022-11-25 19:33:16.448  INFO 20739 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2022-11-25 19:33:17.078  INFO 20739 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2022-11-25 19:33:17.516  INFO 20739 --- [           main] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2022-11-25 19:33:17.660  INFO 20739 --- [           main] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.6.10.Final
ubuntu@app-vm:~/spring-petclinic$ 2022-11-25 19:33:18.081  INFO 20739 --- [           main] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
ubuntu@app-vm:~/spring-petclinic$ 2022-11-25 19:33:18.431  INFO 20739 --- [           main] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.H2Dialect
ubuntu@app-vm:~/spring-petclinic$ 2022-11-25 19:33:20.832  INFO 20739 --- [           main] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
2022-11-25 19:33:20.856  INFO 20739 --- [           main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
2022-11-25 19:33:23.571  INFO 20739 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 13 endpoint(s) beneath base path '/actuator'
2022-11-25 19:33:23.662  WARN 20739 --- [           main] ConfigServletWebServerApplicationContext : Exception encountered during context initialization - cancelling refresh attempt: org.springframework.context.ApplicationContextException: Failed to start bean 'webServerStartStop'; nested exception is org.springframework.boot.web.server.PortInUseException: Port 8080 is already in use
2022-11-25 19:33:23.670  INFO 20739 --- [           main] j.LocalContainerEntityManagerFactoryBean : Closing JPA EntityManagerFactory for persistence unit 'default'
2022-11-25 19:33:23.680  INFO 20739 --- [           main] org.ehcache.core.EhcacheManager          : Cache 'vets' removed from EhcacheManager.
2022-11-25 19:33:23.706  INFO 20739 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - 

```
We can verify via ps and netstat command that our application is listening to port 8080 with Process ID 20546

```
ubuntu@app-vm:~/spring-petclinic$ ps ax | grep java
  20546 ?        Sl     0:19 java -jar target/spring-petclinic-2.7.3.jar
  20766 pts/0    S+     0:00 grep --color=auto java
ubuntu@app-vm:~/spring-petclinic$ netstat -tulnp 
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
tcp6       0      0 :::8080                 :::*                    LISTEN      -                   
tcp6       0      0 :::22                   :::*                    LISTEN      -                   
udp        0      0 127.0.0.53:53           0.0.0.0:*                           -                   
udp        0      0 172.31.18.10:68         0.0.0.0:*                           -    

```


