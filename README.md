## Phoenix live view + postgres + docker + docker-compose 

There is some components that was created with live view

***It works only with linux(you should make changes for windows)***

Unfortunately, I did not find a nice and beauty case to transfer volumes data for postgres container. Therefore, in order to run practically the same application on ***windows*** system (bcs of difference in access rights), so you need to ***comment out the volumes*** in the docker-compose file. Unfortunately, because of this, you can lose the entered data on restart

***Run it***
```bash
docker-compose up --build
```