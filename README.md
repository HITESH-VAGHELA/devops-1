# Baby Care - Name your Baby Meaningful

## Operations Supported
### Admin
1. Can login and logout.
2. Can add baby names.
3. Can view baby names.
4. Can delete baby names.
5. Can add new pages.
### Users
1. Can view baby names.
2. Can view baby tips.
3. Can view baby food.
4. Can view baby products.

## Pre-Requisites
1. Java Version 8 and above
2. Ant Build tool
3. Apache Tomcat
4. MySQL


## Build
> update the jdbc connection string in `src/com/babycare/dao/BabyDao.java`
`example: jdbc:mysql://localhost:3306/babycare","root","abcd1234"`
here 
mysql username is `root`
mysql password is `abcd1234`

login to mysql database and create babycare database;
`$ cd <project_dir>/babycare `
` > mysql -u root -pabcd1234`
` > create database babycare;`
` > use babycare; `
` > source db/babname.sql;`
` > exit; `
`$ ant`
> A babycare.war file will be avaialble in the Application root directory
## 
## Deploy
> login to Tomcat webserver. 
> navigate to Manager App
> Choose a war to deploy 
> click deploy

### Dockerfile, Docker-compose and deployment should be on Kubernetes
### Also use Sonarqube