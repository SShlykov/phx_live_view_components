## Phoenix live view + postgres + docker + docker-compose 

There is some components that was created with live view
1. Auth
1. Chat
1. Yolo object detection (with photo and video)
1. Crypto module (with wss)
1. Simple galery
Also some more components like
1. Clock
1. Snake game
1. Live search
1. Loader...

<!-- ***It works only with linux(you should make changes for windows)***

Unfortunately, I did not find a nice and beauty case to transfer volumes data for postgres container. Therefore, in order to run practically the same application on ***windows*** system (bcs of difference in access rights), so you need to ***comment out the volumes*** in the docker-compose file. Unfortunately, because of this, you can lose the entered data on restart -->

***Docker compose only works without object recognition as installation in docker ecosystem takes about 40 minutes***
```bash
# docker and docker-compose should be installed in your system
docker-compose up --build
```



***Manual installation***
***pre install***
```bash
#we need yolo (python -> conda), postgres db and elixir installed in your system 
# elixir instructions: https://elixir-lang.org/install.html
# postgres instruction: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-20-04
# python instruction: https://www.digitalocean.com/community/tutorials/how-to-install-python-3-and-set-up-a-local-programming-environment-on-ubuntu-18-04
# conda instructions: https://docs.conda.io/projects/conda/en/latest/user-guide/install/
# please ensure that "conda inited"
# then we need to create yolo env and install following packages:
conda create -n yolo python={python version}
conda activate yolo
conda install tensorflow opencv
pip install cvlib
# make sure you have default user postgres with password postgres and run from backend folder:
mix ecto.reset
```

***Run it***
```bash
# then you just need to be sure your yolo env is activated and then just go to backend folder and run:
iex -S mix phx.server 
# for login you have test user - login: test@gmail.com, pwd: secret
# and login: zeitment@gmail.com, pwd: secret
```